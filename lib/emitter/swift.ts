import fs from "node:fs/promises";
import path from "node:path";
import ejs from "ejs";

import type { IREndpoint, IRNamedType, LexiconIR } from "../lexicon-ir";
import { normalizeRef } from "../lexicon-ir";

type RawLexiconSchema = {
	type: string;
	description?: string;
	required?: string[];
	properties?: Record<string, RawLexiconSchema>;
	items?: RawLexiconSchema;
	knownValues?: string[];
	refs?: string[];
	record?: RawLexiconSchema;
};

type SwiftModel = {
	name: string;
	body: string;
	group: string;
};

type EndpointModel = {
	id: string;
	method: "GET" | "POST";
	path: string;
	functionName: string;
	inputType: string | null;
	outputType: string;
};

const SWIFT_RESERVED_WORDS = new Set([
	"associatedtype",
	"class",
	"deinit",
	"enum",
	"extension",
	"func",
	"import",
	"init",
	"let",
	"protocol",
	"struct",
	"subscript",
	"typealias",
	"var",
	"break",
	"case",
	"catch",
	"continue",
	"default",
	"defer",
	"do",
	"else",
	"fallthrough",
	"for",
	"if",
	"in",
	"repeat",
	"return",
	"throw",
	"where",
	"while",
]);

function toSwiftSafeIdentifier(input: string): string {
	const replaced = input
		.replace(/[^a-zA-Z0-9_]/g, "_")
		.replace(/^([0-9])/, "_$1");
	if (SWIFT_RESERVED_WORDS.has(replaced)) {
		return `${replaced}_`;
	}
	return replaced;
}

function toPascalCase(input: string): string {
	const parts = input
		.split(/[^a-zA-Z0-9]+/)
		.filter((part) => part.length > 0)
		.map((part) => part.charAt(0).toUpperCase() + part.slice(1));
	return toSwiftSafeIdentifier(parts.join("") || "Item");
}

function toCamelCase(input: string): string {
	const parts = input
		.split(/[^a-zA-Z0-9]+/)
		.filter((part) => part.length > 0)
		.map((part) => part.toLowerCase());
	if (parts.length === 0) return "item";
	const head = parts.shift();
	if (!head) {
		return "item";
	}
	return `${head}${parts.map((part) => part.charAt(0).toUpperCase() + part.slice(1)).join("")}`;
}

function modelName(fullName: string): string {
	return fullName.split(".").map(toPascalCase).join("");
}

function unknownType(): string {
	return "ATProtocolAny";
}

function modelGroupFromId(id: string): string {
	const parts = id.split(".");
	return parts.slice(0, Math.min(parts.length, 3)).join(".");
}

function modelFileName(group: string): string {
	return `${toPascalCase(group)}.generated.swift`;
}

function ensureAlias(
	names: Map<string, SwiftModel>,
	name: string,
	body: string,
	group: string,
): string {
	if (!names.has(name)) {
		names.set(name, { name, body, group });
	}
	return name;
}

function primitiveSwiftType(schema: RawLexiconSchema): string {
	switch (schema.type) {
		case "integer":
			return "Int";
		case "boolean":
			return "Bool";
		case "number":
			return "Double";
		case "bytes":
		case "blob":
		case "cid-link":
		case "token":
		case "string":
			return "String";
		default:
			return unknownType();
	}
}

function mapSchemaToSwiftType(
	schema: RawLexiconSchema | undefined,
	currentId: string,
	group: string,
	definitions: Map<string, IRNamedType>,
	generated: Map<string, SwiftModel>,
): string {
	if (!schema) {
		return unknownType();
	}

	if (schema.type === "ref" && "ref" in schema) {
		const target = normalizeRef((schema as { ref: string }).ref, currentId);
		return definitions.has(target) ? modelName(target) : unknownType();
	}

	if (schema.type === "array" && schema.items) {
		return `[${mapSchemaToSwiftType(
			schema.items,
			currentId,
			group,
			definitions,
			generated,
		)}]`;
	}

	if (schema.type === "record" && schema.record) {
		const nested = `RecordFor${toPascalCase(currentId)}`;
		return mapSchemaToSwiftType(
			schema.record,
			nested,
			group,
			definitions,
			generated,
		);
	}

	if (schema.type === "union") {
		return unknownType();
	}

	if (schema.type === "object" && schema.properties) {
		const name = toPascalCase(`${currentId}Properties`);
		return buildObjectDeclaration(name, schema, group, definitions, generated);
	}

	if (
		schema.type === "string" &&
		schema.knownValues &&
		schema.knownValues.length > 0
	) {
		const unionName = toPascalCase(
			`${currentId} ${schema.knownValues.join(" ").slice(0, 8)}`,
		);
		return ensureAlias(
			generated,
			unionName,
			`public enum ${unionName}: String, Codable {\n${schema.knownValues
				.map(
					(entry) =>
						`\tcase ${toSwiftSafeIdentifier(toCamelCase(entry))} = "${entry}"`,
				)
				.join("\n")}\n}`,
			group,
		);
	}

	return primitiveSwiftType(schema);
}

function buildObjectDeclaration(
	fullName: string,
	schema: RawLexiconSchema,
	group: string,
	definitions: Map<string, IRNamedType>,
	generated: Map<string, SwiftModel>,
): string {
	const name = modelName(fullName);
	const properties = schema.properties ?? {};
	const required = new Set(schema.required ?? []);
	const keys = Object.keys(properties).sort();

	if (keys.length === 0) {
		return ensureAlias(
			generated,
			name,
			`public typealias ${name} = [String: ATProtocolAny]`,
			group,
		);
	}

	const declarations = keys.flatMap((key) => {
		const property = properties[key];
		if (property == null) {
			return [];
		}

		if (property.description?.toLowerCase().includes("deprecated")) {
			return [];
		}

		const swiftType = mapSchemaToSwiftType(
			property,
			fullName,
			group,
			definitions,
			generated,
		);
		const propertyName = toSwiftSafeIdentifier(toCamelCase(key));
		const optionalSuffix = required.has(key) ? "" : "?";
		return [`\tpublic let ${propertyName}: ${swiftType}${optionalSuffix}`];
	});

	const codingKeys = [
		"\tprivate enum CodingKeys: String, CodingKey {",
		...keys.map((key) => {
			const keyName = toSwiftSafeIdentifier(toCamelCase(key));
			return `\t\tcase ${keyName} = "${key}"`;
		}),
		"\t}",
	];

	return ensureAlias(
		generated,
		name,
		[
			`public struct ${name}: Codable {`,
			...declarations,
			"",
			...codingKeys,
			"}",
		].join("\n"),
		group,
	);
}

function buildRecordDeclaration(
	named: IRNamedType,
	group: string,
	definitions: Map<string, IRNamedType>,
	generated: Map<string, SwiftModel>,
): string {
	const record = named.definition as { record?: RawLexiconSchema };
	if (!record.record) {
		return ensureAlias(
			generated,
			modelName(named.fullName),
			`public typealias ${modelName(named.fullName)} = ATProtocolAny`,
			group,
		);
	}

	return buildObjectDeclaration(
		named.fullName,
		record.record,
		group,
		definitions,
		generated,
	);
}

function buildUnionDeclaration(
	fullName: string,
	refs: string[],
	group: string,
	definitions: Map<string, IRNamedType>,
	generated: Map<string, SwiftModel>,
): string {
	const name = modelName(fullName);
	if (refs.length === 0) {
		return ensureAlias(
			generated,
			name,
			`public typealias ${name} = ATProtocolAny`,
			group,
		);
	}

	const cases = refs.map((ref, index) => {
		const target = normalizeRef(ref, fullName);
		const caseType = definitions.has(target)
			? modelName(target)
			: unknownType();
		return `\tcase option${index}(${caseType})`;
	});

	const body = [
		`public enum ${name}: Codable {`,
		...cases,
		"\tcase unknown(ATProtocolAny)",
		"}",
	].join("\n");

	return ensureAlias(generated, name, body, group);
}

function emitNamedType(
	named: IRNamedType,
	group: string,
	definitions: Map<string, IRNamedType>,
	generated: Map<string, SwiftModel>,
): string {
	const type =
		typeof named.definition.type === "string"
			? named.definition.type
			: "unknown";

	switch (type) {
		case "object":
			return buildObjectDeclaration(
				named.fullName,
				named.definition as RawLexiconSchema,
				group,
				definitions,
				generated,
			);
		case "array": {
			const schema = named.definition as RawLexiconSchema;
			const element = mapSchemaToSwiftType(
				schema.items,
				named.fullName,
				group,
				definitions,
				generated,
			);
			return ensureAlias(
				generated,
				modelName(named.fullName),
				`public typealias ${modelName(named.fullName)} = [${element}]`,
				group,
			);
		}
		case "record":
			return buildRecordDeclaration(named, group, definitions, generated);
		case "string": {
			const values = (named.definition as RawLexiconSchema).knownValues;
			if (values && values.length > 0) {
				return ensureAlias(
					generated,
					modelName(named.fullName),
					[
						`public enum ${modelName(named.fullName)}: String, Codable {`,
						...values.map(
							(entry) =>
								`\tcase ${toSwiftSafeIdentifier(toCamelCase(entry))} = "${entry}"`,
						),
						"}",
					].join("\n"),
					group,
				);
			}
			return ensureAlias(
				generated,
				modelName(named.fullName),
				`public typealias ${modelName(named.fullName)} = String`,
				group,
			);
		}
		case "token":
			return ensureAlias(
				generated,
				modelName(named.fullName),
				`public typealias ${modelName(named.fullName)} = String`,
				group,
			);
		case "union":
			return buildUnionDeclaration(
				named.fullName,
				(named.definition as RawLexiconSchema).refs ?? [],
				group,
				definitions,
				generated,
			);
		case "permission-set":
			return ensureAlias(
				generated,
				modelName(named.fullName),
				`public typealias ${modelName(named.fullName)} = ATProtocolAny`,
				group,
			);
		default:
			return ensureAlias(
				generated,
				modelName(named.fullName),
				`public typealias ${modelName(named.fullName)} = ATProtocolAny`,
				group,
			);
	}
}

function schemaFromEndpointInput(
	container: RawLexiconSchema | undefined,
	endpointName: string,
	group: string,
	normalizedBase: string,
	definitions: Map<string, IRNamedType>,
	generated: Map<string, SwiftModel>,
	typePrefix: "Parameters" | "Input",
): string | null {
	if (!container) {
		return null;
	}

	if (container.type === "object" && container.properties) {
		const target = modelName(`${endpointName} ${typePrefix}`);
		buildObjectDeclaration(target, container, group, definitions, generated);
		return target;
	}

	if (container.type === "record" && container.record) {
		const target = modelName(`${endpointName} ${typePrefix}`);
		buildObjectDeclaration(
			target,
			container.record,
			group,
			definitions,
			generated,
		);
		return target;
	}

	if (container.type === "array" && container.items) {
		const element = mapSchemaToSwiftType(
			container.items,
			normalizedBase,
			group,
			definitions,
			generated,
		);
		const alias = modelName(`${endpointName} ${typePrefix}`);
		return ensureAlias(
			generated,
			alias,
			`public typealias ${alias} = [${element}]`,
			group,
		);
	}

	return mapSchemaToSwiftType(
		container,
		normalizedBase,
		group,
		definitions,
		generated,
	);
}

function buildEndpointModel(
	endpoint: IREndpoint,
	group: string,
	definitions: Map<string, IRNamedType>,
	generated: Map<string, SwiftModel>,
): EndpointModel {
	const base = modelName(endpoint.fullName);
	const def = endpoint.definition as {
		parameters?: {
			type?: string;
			schema?: RawLexiconSchema;
			record?: RawLexiconSchema;
		};
		input?: {
			type?: string;
			schema?: RawLexiconSchema;
			record?: RawLexiconSchema;
		};
		output?: { schema?: RawLexiconSchema };
	};
	const inputContainer =
		endpoint.method === "query"
			? (def.parameters as RawLexiconSchema | undefined)
			: (def.input?.schema as RawLexiconSchema | undefined);
	const inputType = schemaFromEndpointInput(
		inputContainer,
		endpoint.fullName,
		group,
		base,
		definitions,
		generated,
		endpoint.method === "query" ? "Parameters" : "Input",
	);

	const outputType = def.output?.schema
		? mapSchemaToSwiftType(
				def.output.schema,
				endpoint.id,
				group,
				definitions,
				generated,
			)
		: unknownType();

	return {
		id: endpoint.fullName,
		method: endpoint.method === "query" ? "GET" : "POST",
		path: endpoint.path,
		functionName: toCamelCase(base),
		inputType,
		outputType,
	};
}

export async function emitSwiftFromIR(
	ir: LexiconIR,
	outputDir: string,
): Promise<void> {
	const outDir = path.resolve(outputDir);
	await fs.mkdir(outDir, { recursive: true });

	const generated = new Map<string, SwiftModel>();
	for (const named of ir.namedTypes) {
		const group = modelGroupFromId(named.source);
		emitNamedType(named, group, ir.definitionIndex, generated);
	}

	const endpointModels = ir.endpoints.map((endpoint) =>
		buildEndpointModel(
			endpoint,
			modelGroupFromId(endpoint.source || endpoint.id),
			ir.definitionIndex,
			generated,
		),
	);
	const groupedModels = new Map<string, SwiftModel[]>();
	for (const model of generated.values()) {
		const group = model.group;
		if (!groupedModels.has(group)) {
			groupedModels.set(group, []);
		}
		groupedModels.get(group)?.push(model);
	}

	for (const models of groupedModels.values()) {
		models.sort((a, b) => a.name.localeCompare(b.name));
	}

	const templatesDir = path.join(process.cwd(), "templates", "swift");
	const modelsTemplate = path.join(templatesDir, "models.ejs");
	const runtimeTemplate = path.join(templatesDir, "runtime.ejs");
	const endpointsTemplate = path.join(templatesDir, "endpoints.ejs");

	const [modelsTemplateText, runtimeTemplateText, endpointsTemplateText] =
		await Promise.all([
			fs.readFile(modelsTemplate, "utf8"),
			fs.readFile(runtimeTemplate, "utf8"),
			fs.readFile(endpointsTemplate, "utf8"),
		]);

	const existingGenerated = await fs.readdir(outDir);
	await Promise.all(
		existingGenerated
			.filter((file) => file.endsWith(".generated.swift"))
			.map((file) => fs.rm(path.join(outDir, file), { force: true })),
	);

	await Promise.all([
		fs.writeFile(
			path.join(outDir, "Models.swift"),
			ejs.render(runtimeTemplateText, {}, { filename: runtimeTemplate }),
		),
		...Array.from(groupedModels.entries()).map(([group, models]) =>
			fs.writeFile(
				path.join(outDir, modelFileName(group)),
				ejs.render(
					modelsTemplateText,
					{ models },
					{ filename: modelsTemplate },
				),
			),
		),
		fs.writeFile(
			path.join(outDir, "Endpoints.swift"),
			ejs.render(
				endpointsTemplateText,
				{ endpoints: endpointModels },
				{ filename: endpointsTemplate },
			),
		),
	]);
}
