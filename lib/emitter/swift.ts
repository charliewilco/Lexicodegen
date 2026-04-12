import fs from "node:fs/promises";
import path from "node:path";
import ejs from "ejs";

import type {
	IREndpoint,
	IRNamedType,
	LexiconIR,
	RawLexiconSchema,
} from "../lexicon-ir";
import { normalizeRef } from "../lexicon-ir";

type SwiftModel = {
	name: string;
	body: string;
	group: string;
};

type GeneratedContext = {
	definitions: Map<string, IRNamedType>;
	models: Map<string, SwiftModel>;
	knownValueEnums: Map<string, string>;
	inlineUnions: Map<string, string>;
};

type EndpointOutputKind = "json" | "binary" | "jsonl" | "car";

type EndpointSurface = {
	id: string;
	namespaceSegments: string[];
	functionName: string;
	method: "GET" | "POST";
	path: string;
	kind: "query" | "procedure" | "subscription";
	inputType: string | null;
	outputType: string | null;
	errorType: string | null;
	inputEncoding?: string;
	outputEncoding?: string;
	outputKind: EndpointOutputKind;
	binaryInput: boolean;
};

type NamespaceNode = {
	segment: string;
	prefix: string[];
	children: Map<string, NamespaceNode>;
	endpoints: EndpointSurface[];
};

type ObjectDeclarationOptions = {
	typeIdentifier?: string;
	queryEncodable?: boolean;
	protocols?: string[];
};

export type SwiftEmitterOptions = {
	filePrefix?: string;
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
		return `\`${replaced}\``;
	}
	return replaced;
}

function toPascalCase(input: string): string {
	const parts = input
		.replace(/([a-z0-9])([A-Z])/g, "$1 $2")
		.split(/[^a-zA-Z0-9]+|\s+/)
		.filter((part) => part.length > 0)
		.map((part) => part.charAt(0).toUpperCase() + part.slice(1));
	return parts.join("") || "Item";
}

function toCamelCase(input: string): string {
	const parts = input
		.replace(/([a-z0-9])([A-Z])/g, "$1 $2")
		.split(/[^a-zA-Z0-9]+|\s+/)
		.filter((part) => part.length > 0)
		.map((part) => part.toLowerCase());

	if (parts.length === 0) {
		return "item";
	}

	const [head, ...tail] = parts;
	return toSwiftSafeIdentifier(
		`${head}${tail.map((part) => part.charAt(0).toUpperCase() + part.slice(1)).join("")}`,
	);
}

function modelName(fullName: string): string {
	return fullName.split(".").map(toPascalCase).join("");
}

function hasDefinitionModelNameCollision(
	name: string,
	fullName: string,
	context: GeneratedContext,
): boolean {
	return Array.from(context.definitions.values()).some(
		(definition) =>
			definition.fullName !== fullName &&
			modelName(definition.fullName) === name,
	);
}

function uniqueInlineUnionName(
	fullName: string,
	context: GeneratedContext,
): string {
	const baseName = modelName(fullName);
	let candidate = baseName;
	let index = 1;

	while (hasDefinitionModelNameCollision(candidate, fullName, context)) {
		candidate = `${baseName}Union${index === 1 ? "" : index}`;
		index += 1;
	}

	return candidate;
}

function typealiasBody(name: string, target: string): string {
	return `public typealias ${name} = ${target}`;
}

function modelGroupFromId(id: string): string {
	const parts = id.split(".");
	return parts.slice(0, Math.min(parts.length, 3)).join(".");
}

function prefixedFileName(fileName: string, filePrefix: string): string {
	return `${filePrefix}${fileName}`;
}

function modelFileName(group: string, filePrefix: string): string {
	return prefixedFileName(`${toPascalCase(group)}.generated.swift`, filePrefix);
}

function ensureModel(
	models: Map<string, SwiftModel>,
	name: string,
	body: string,
	group: string,
): string {
	if (!models.has(name)) {
		models.set(name, { name, body, group });
	}
	return name;
}

function propertySwiftName(key: string): string {
	if (key === "$type") {
		return "typeIdentifier";
	}
	return toCamelCase(key);
}

function isRequired(schema: RawLexiconSchema, key: string): boolean {
	return (schema.required ?? []).includes(key);
}

function isNullable(schema: RawLexiconSchema, key: string): boolean {
	return (schema.nullable ?? []).includes(key);
}

function primitiveSwiftType(schema: RawLexiconSchema): string {
	const format =
		typeof schema.format === "string" ? schema.format.toLowerCase() : undefined;

	if (schema.type === "string") {
		switch (format) {
			case "cid":
				return "CID";
			case "datetime":
				return "ATProtocolDate";
			case "did":
				return "DID";
			case "handle":
				return "Handle";
			case "tid":
				return "TID";
			case "at-identifier":
				return "ATIdentifier";
			case "at-uri":
				return "ATURI";
			case "nsid":
				return "NSID";
			case "record-key":
				return "RecordKey";
			default:
				return "String";
		}
	}

	switch (schema.type) {
		case "integer":
			return "Int";
		case "boolean":
			return "Bool";
		case "number":
			return "Double";
		case "blob":
			return "Blob";
		case "bytes":
			return "Bytes";
		case "cid-link":
			return "CID";
		case "token":
			return "String";
		case "unknown":
			return "ATProtocolValueContainer";
		default:
			return "ATProtocolValueContainer";
	}
}

function classifyOutputKind(
	encoding: string | undefined,
): EndpointSurface["outputKind"] {
	switch (encoding?.toLowerCase()) {
		case undefined:
		case "application/json":
			return "json";
		case "application/jsonl":
			return "jsonl";
		case "application/vnd.ipld.car":
			return "car";
		default:
			return "binary";
	}
}

function isBinaryInputEncoding(encoding: string | undefined): boolean {
	const normalized = encoding?.toLowerCase();
	return normalized != null && normalized !== "application/json";
}

function defaultBinaryContentType(encoding: string | undefined): string {
	return encoding ?? "application/octet-stream";
}

function typeIdentifierForNamedType(named: IRNamedType): string {
	return named.name === "main" ? named.id : `${named.id}#${named.name}`;
}

function knownValueEnumKey(group: string, values: string[]): string {
	return `${group}\u0000${[...new Set(values)].join("\u0001")}`;
}

function inlineUnionKey(group: string, refs: string[]): string {
	return `${group}\u0000${refs.join("\u0001")}`;
}

function quotedSwiftString(value: string | undefined): string {
	return value == null ? "nil" : JSON.stringify(value);
}

function permissionMethodName(value: string): string {
	return toSwiftSafeIdentifier(toCamelCase(value));
}

function uniqueCaseName(existing: Set<string>, input: string): string {
	let candidate = toCamelCase(input);
	if (!existing.has(candidate)) {
		existing.add(candidate);
		return candidate;
	}

	let index = 2;
	while (existing.has(`${candidate}${index}`)) {
		index += 1;
	}
	candidate = `${candidate}${index}`;
	existing.add(candidate);
	return candidate;
}

function mapSchemaToSwiftType(
	schema: RawLexiconSchema | undefined,
	fullName: string,
	referenceBase: string,
	group: string,
	context: GeneratedContext,
	options: {
		typeIdentifier?: string;
		queryEncodable?: boolean;
	} = {},
): string {
	if (!schema) {
		return "ATProtocolValueContainer";
	}

	if (schema.type === "ref" && typeof schema.ref === "string") {
		const target = normalizeRef(schema.ref, referenceBase);
		return context.definitions.has(target)
			? modelName(target)
			: "ATProtocolValueContainer";
	}

	if (schema.type === "array" && schema.items) {
		return `[${mapSchemaToSwiftType(
			schema.items,
			`${fullName}.item`,
			referenceBase,
			group,
			context,
		)}]`;
	}

	if (schema.type === "union") {
		const normalizedRefs = (schema.refs ?? []).map((ref) =>
			normalizeRef(ref, referenceBase),
		);
		return buildUnionDeclaration(
			fullName,
			referenceBase,
			schema.refs ?? [],
			group,
			context,
			{
				canonicalKey: inlineUnionKey(group, normalizedRefs),
			},
		);
	}

	if (schema.type === "object" || schema.type === "params") {
		return buildObjectDeclaration(
			fullName,
			referenceBase,
			schema,
			group,
			context,
			{
				typeIdentifier: options.typeIdentifier,
				queryEncodable: options.queryEncodable || schema.type === "params",
			},
		);
	}

	if (schema.type === "record" && schema.record) {
		return buildObjectDeclaration(
			fullName,
			referenceBase,
			schema.record,
			group,
			context,
			{
				typeIdentifier: options.typeIdentifier,
			},
		);
	}

	if (
		schema.type === "string" &&
		Array.isArray(schema.knownValues) &&
		schema.knownValues.length > 0
	) {
		return buildKnownValueEnum(fullName, schema.knownValues, group, context, {
			canonicalKey: knownValueEnumKey(group, schema.knownValues),
		});
	}

	return primitiveSwiftType(schema);
}

function buildKnownValueEnum(
	fullName: string,
	values: string[],
	group: string,
	context: GeneratedContext,
	options: {
		canonicalKey?: string;
	} = {},
): string {
	if (
		options.canonicalKey &&
		context.knownValueEnums.has(options.canonicalKey)
	) {
		return (
			context.knownValueEnums.get(options.canonicalKey) ?? modelName(fullName)
		);
	}

	const name = modelName(fullName);
	const uniqueValues = [...new Set(values)];
	const resolvedName = ensureModel(
		context.models,
		name,
		[
			`public enum ${name}: String, Codable, CaseIterable, QueryParameterValue, Sendable {`,
			...uniqueValues.map((entry) => {
				const identifier = toSwiftSafeIdentifier(toCamelCase(entry));
				return `\tcase ${identifier} = "${entry}"`;
			}),
			"}",
		].join("\n"),
		group,
	);
	if (options.canonicalKey) {
		context.knownValueEnums.set(options.canonicalKey, resolvedName);
	}
	return resolvedName;
}

function buildObjectDeclaration(
	fullName: string,
	referenceBase: string,
	schema: RawLexiconSchema,
	group: string,
	context: GeneratedContext,
	options: ObjectDeclarationOptions = {},
): string {
	const name = modelName(fullName);
	if (context.models.has(name)) {
		return name;
	}
	context.models.set(name, { name, body: "", group });

	const properties = schema.properties ?? {};
	const keys = Object.keys(properties)
		.filter((key) => key !== "$type")
		.sort();

	const protocols = options.protocols ?? ["Codable", "Sendable", "Equatable"];
	const storedProperties = keys.map((key) => {
		const property = properties[key];
		if (!property) {
			return null;
		}
		const type = mapSchemaToSwiftType(
			property,
			`${fullName}.${key}`,
			referenceBase,
			group,
			context,
		);
		const optional = !isRequired(schema, key) || isNullable(schema, key);
		return {
			key,
			swiftName: propertySwiftName(key),
			type,
			optional,
		};
	});

	const usableProperties = storedProperties.filter(
		(
			property,
		): property is {
			key: string;
			swiftName: string;
			type: string;
			optional: boolean;
		} => property != null,
	);

	const typeIdentifierKey = options.typeIdentifier
		? '\t\tcase typeIdentifier = "$type"'
		: null;
	const propertyDecls = usableProperties.map(
		(property) =>
			`\tpublic let ${property.swiftName}: ${property.type}${property.optional ? "?" : ""}`,
	);
	const initializerParams = usableProperties.map(
		(property) =>
			`\t\t${property.swiftName}: ${property.type}${property.optional ? "? = nil" : ""}`,
	);
	const initializerBody = usableProperties.map(
		(property) => `\t\tself.${property.swiftName} = ${property.swiftName}`,
	);
	const decodeLines = usableProperties.map((property) => {
		const decoderCall = property.optional ? "decodeIfPresent" : "decode";
		return `\t\t${property.swiftName} = try container.${decoderCall}(${property.type}.self, forKey: .${property.swiftName})`;
	});
	const encodeLines = usableProperties.map((property) => {
		const encoderCall = property.optional ? "encodeIfPresent" : "encode";
		return `\t\ttry container.${encoderCall}(${property.swiftName}, forKey: .${property.swiftName})`;
	});
	const hasNamedCodingKeys =
		typeIdentifierKey != null || usableProperties.length > 0;
	const codingKeys = hasNamedCodingKeys
		? [
				"\tprivate enum CodingKeys: String, CodingKey {",
				...(typeIdentifierKey ? [typeIdentifierKey] : []),
				...usableProperties.map(
					(property) => `\t\tcase ${property.swiftName} = "${property.key}"`,
				),
				"\t}",
			]
		: [
				"\tprivate struct CodingKeys: CodingKey {",
				'\t\tlet stringValue = ""',
				"\t\tinit?(stringValue: String) {",
				"\t\t\treturn nil",
				"\t\t}",
				"",
				"\t\tlet intValue: Int? = nil",
				"\t\tinit?(intValue: Int) {",
				"\t\t\treturn nil",
				"\t\t}",
				"\t}",
			];

	const queryItemsMethod = options.queryEncodable
		? usableProperties.length === 0
			? [
					"",
					"\tpublic func asQueryItems() -> [URLQueryItem] {",
					"\t\t[]",
					"\t}",
				]
			: [
					"",
					"\tpublic func asQueryItems() -> [URLQueryItem] {",
					"\t\tvar items: [URLQueryItem] = []",
					...usableProperties.flatMap((property) => {
						if (property.optional) {
							return [
								`\t\tif let value = ${property.swiftName} {`,
								`\t\t\tvalue.appendQueryItems(named: "${property.key}", to: &items)`,
								"\t\t}",
							];
						}

						return [
							`\t\t${property.swiftName}.appendQueryItems(named: "${property.key}", to: &items)`,
						];
					}),
					"\t\treturn items",
					"\t}",
				]
		: [];

	const initializer =
		usableProperties.length === 0
			? ["\tpublic init() {}", ""]
			: [
					"\tpublic init(",
					initializerParams.join(",\n"),
					"\t) {",
					...initializerBody,
					"\t}",
					"",
				];

	const body = [
		`public struct ${name}: ${protocols.join(", ")} {`,
		...(options.typeIdentifier
			? [`\tpublic static let typeIdentifier = "${options.typeIdentifier}"`, ""]
			: []),
		...propertyDecls,
		"",
		...initializer,
		"\tpublic init(from decoder: Decoder) throws {",
		hasNamedCodingKeys
			? "\t\tlet container = try decoder.container(keyedBy: CodingKeys.self)"
			: "\t\t_ = try decoder.container(keyedBy: CodingKeys.self)",
		...(options.typeIdentifier
			? [
					"\t\t_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)",
				]
			: []),
		...decodeLines,
		"\t}",
		"",
		"\tpublic func encode(to encoder: Encoder) throws {",
		hasNamedCodingKeys
			? "\t\tvar container = encoder.container(keyedBy: CodingKeys.self)"
			: "\t\t_ = encoder.container(keyedBy: CodingKeys.self)",
		...(options.typeIdentifier
			? [
					"\t\ttry container.encode(Self.typeIdentifier, forKey: .typeIdentifier)",
				]
			: []),
		...encodeLines,
		"\t}",
		...queryItemsMethod,
		"",
		...codingKeys,
		"}",
	].join("\n");

	context.models.set(name, { name, body, group });
	return name;
}

function buildUnionDeclaration(
	fullName: string,
	referenceBase: string,
	refs: string[],
	group: string,
	context: GeneratedContext,
	options: {
		canonicalKey?: string;
	} = {},
): string {
	if (options.canonicalKey && context.inlineUnions.has(options.canonicalKey)) {
		return (
			context.inlineUnions.get(options.canonicalKey) ?? modelName(fullName)
		);
	}

	const name = uniqueInlineUnionName(fullName, context);
	if (context.models.has(name)) {
		return name;
	}
	context.models.set(name, { name, body: "", group });

	if (refs.length === 0) {
		context.models.set(name, {
			name,
			body: typealiasBody(name, "ATProtocolValueContainer"),
			group,
		});
		return name;
	}

	const usedCaseNames = new Set<string>();
	const cases = refs.flatMap((ref) => {
		const target = normalizeRef(ref, referenceBase);
		const definition = context.definitions.get(target);
		if (!definition) {
			return [];
		}

		const caseName = uniqueCaseName(
			usedCaseNames,
			definition.name === "main"
				? (definition.id.split(".").at(-1) ?? "value")
				: definition.name,
		);
		const caseType = modelName(target);
		const typeIdentifier = typeIdentifierForNamedType(definition);

		if (definition.type === "record" && definition.definition.record) {
			buildObjectDeclaration(
				target,
				definition.id,
				definition.definition.record,
				group,
				context,
				{ typeIdentifier },
			);
		}

		return [
			{
				caseName,
				caseType,
				typeIdentifier,
				requiresTaggedEncoding:
					definition.type === "object" || definition.type === "record",
				isRecord: definition.type === "record",
			},
		];
	});

	const body = [
		`public indirect enum ${name}: Codable, Sendable, Equatable {`,
		...cases.map((entry) => `\tcase ${entry.caseName}(${entry.caseType})`),
		"\tcase unexpected(ATProtocolValueContainer)",
		"",
		"\tpublic init(from decoder: Decoder) throws {",
		"\t\tlet typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)",
		"\t\tswitch typeIdentifier {",
		...cases.map(
			(entry) =>
				`\t\tcase "${entry.typeIdentifier}": self = .${entry.caseName}(try ${entry.caseType}(from: decoder))`,
		),
		"\t\tdefault: self = .unexpected(try ATProtocolValueContainer(from: decoder))",
		"\t\t}",
		"\t}",
		"",
		"\tpublic func encode(to encoder: Encoder) throws {",
		"\t\tswitch self {",
		...cases.map((entry) =>
			entry.requiresTaggedEncoding && !entry.isRecord
				? `\t\tcase .${entry.caseName}(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: ${JSON.stringify(entry.typeIdentifier)}, to: encoder)`
				: `\t\tcase .${entry.caseName}(let value): try value.encode(to: encoder)`,
		),
		"\t\tcase .unexpected(let value): try value.encode(to: encoder)",
		"\t\t}",
		"\t}",
		"}",
	].join("\n");

	context.models.set(name, { name, body, group });
	if (options.canonicalKey) {
		context.inlineUnions.set(options.canonicalKey, name);
	}
	return name;
}

function buildPermissionSetDeclaration(
	named: IRNamedType,
	context: GeneratedContext,
): string {
	const group = modelGroupFromId(named.source);
	const name = modelName(named.fullName);
	const methodName = `${name}Method`;
	const permissions = Array.isArray(named.definition.permissions)
		? named.definition.permissions
		: [];
	const knownMethods = [
		...new Set(
			permissions.flatMap((permission) =>
				Array.isArray(permission?.lxm)
					? permission.lxm.filter(
							(value): value is string => typeof value === "string",
						)
					: [],
			),
		),
	];

	ensureModel(
		context.models,
		methodName,
		[
			`public struct ${methodName}: RawRepresentable, Codable, Hashable, Sendable {`,
			"\tpublic let rawValue: String",
			"",
			"\tpublic init(rawValue: String) {",
			"\t\tself.rawValue = rawValue",
			"\t}",
			...(knownMethods.length > 0
				? [
						"",
						...knownMethods.map(
							(value) =>
								`\tpublic static let ${permissionMethodName(value)} = Self(rawValue: ${JSON.stringify(value)})`,
						),
					]
				: []),
			"}",
		].join("\n"),
		group,
	);

	return ensureModel(
		context.models,
		name,
		[
			`public struct ${name}: Codable, Sendable, Equatable {`,
			`\tpublic static let title: String? = ${quotedSwiftString(named.definition.title)}`,
			`\tpublic static let detail: String? = ${quotedSwiftString(named.definition.detail)}`,
			`\tpublic static let knownMethods: [${methodName}] = [${knownMethods
				.map((value) => `.${permissionMethodName(value)}`)
				.join(", ")}]`,
			"",
			`\tpublic let grantedMethods: [${methodName}]`,
			"",
			`\tpublic init(grantedMethods: [${methodName}] = []) {`,
			"\t\tself.grantedMethods = grantedMethods",
			"\t}",
			"",
			"\tpublic init(from decoder: Decoder) throws {",
			"\t\tvar container = try decoder.unkeyedContainer()",
			`\t\tvar grantedMethods: [${methodName}] = []`,
			"\t\twhile !container.isAtEnd {",
			`\t\t\tgrantedMethods.append(${methodName}(rawValue: try container.decode(String.self)))`,
			"\t\t}",
			"\t\tself.grantedMethods = grantedMethods",
			"\t}",
			"",
			"\tpublic func encode(to encoder: Encoder) throws {",
			"\t\tvar container = encoder.unkeyedContainer()",
			"\t\tfor method in grantedMethods {",
			"\t\t\ttry container.encode(method.rawValue)",
			"\t\t}",
			"\t}",
			"}",
		].join("\n"),
		group,
	);
}

function buildNamedType(named: IRNamedType, context: GeneratedContext): string {
	const group = modelGroupFromId(named.source);
	switch (named.type) {
		case "object":
			return buildObjectDeclaration(
				named.fullName,
				named.id,
				named.definition,
				group,
				context,
			);
		case "params":
			return buildObjectDeclaration(
				named.fullName,
				named.id,
				named.definition,
				group,
				context,
				{ queryEncodable: true },
			);
		case "record":
			if (named.definition.record) {
				return buildObjectDeclaration(
					named.fullName,
					named.id,
					named.definition.record,
					group,
					context,
					{ typeIdentifier: typeIdentifierForNamedType(named) },
				);
			}
			return ensureModel(
				context.models,
				modelName(named.fullName),
				typealiasBody(modelName(named.fullName), "ATProtocolValueContainer"),
				group,
			);
		case "string":
			if (
				Array.isArray(named.definition.knownValues) &&
				named.definition.knownValues.length > 0
			) {
				return buildKnownValueEnum(
					named.fullName,
					named.definition.knownValues,
					group,
					context,
				);
			}
			return ensureModel(
				context.models,
				modelName(named.fullName),
				typealiasBody(
					modelName(named.fullName),
					primitiveSwiftType(named.definition),
				),
				group,
			);
		case "array":
			return ensureModel(
				context.models,
				modelName(named.fullName),
				typealiasBody(
					modelName(named.fullName),
					`[${mapSchemaToSwiftType(named.definition.items, `${named.fullName}.item`, named.id, group, context)}]`,
				),
				group,
			);
		case "union":
			return buildUnionDeclaration(
				named.fullName,
				named.id,
				named.definition.refs ?? [],
				group,
				context,
			);
		case "permission-set":
			return buildPermissionSetDeclaration(named, context);
		default:
			return ensureModel(
				context.models,
				modelName(named.fullName),
				typealiasBody(
					modelName(named.fullName),
					primitiveSwiftType(named.definition),
				),
				group,
			);
	}
}

function buildEndpointHelperType(
	endpoint: IREndpoint,
	suffix: "Parameters" | "Input" | "Output" | "Message",
	schema: RawLexiconSchema | undefined,
	context: GeneratedContext,
	options: {
		queryEncodable?: boolean;
		binaryInput?: boolean;
		contentType?: string;
	} = {},
): string | null {
	if (suffix === "Input" && options.binaryInput) {
		const fullName = `${endpoint.fullName}.${suffix}`;
		const name = modelName(fullName);
		return ensureModel(
			context.models,
			name,
			[
				`public struct ${name}: Sendable, Equatable {`,
				"\tpublic let data: Data",
				"\tpublic let contentType: String",
				"",
				`\tpublic init(data: Data, contentType: String = ${JSON.stringify(options.contentType ?? "application/octet-stream")}) {`,
				"\t\tself.data = data",
				"\t\tself.contentType = contentType",
				"\t}",
				"}",
			].join("\n"),
			modelGroupFromId(endpoint.source),
		);
	}

	if (!schema) {
		return null;
	}

	const fullName = `${endpoint.fullName}.${suffix}`;
	const group = modelGroupFromId(endpoint.source);
	if (schema.type === "ref" && typeof schema.ref === "string") {
		const target = normalizeRef(schema.ref, endpoint.id);
		const targetType = context.definitions.has(target)
			? modelName(target)
			: "ATProtocolValueContainer";
		return ensureModel(
			context.models,
			modelName(fullName),
			typealiasBody(modelName(fullName), targetType),
			group,
		);
	}

	return mapSchemaToSwiftType(schema, fullName, endpoint.id, group, context, {
		queryEncodable: options.queryEncodable,
	});
}

function buildEndpointErrorType(
	endpoint: IREndpoint,
	context: GeneratedContext,
): string | null {
	const errors = endpoint.errors ?? [];
	if (errors.length === 0) {
		return null;
	}

	const fullName = `${endpoint.fullName}.Error`;
	const name = modelName(fullName);
	const group = modelGroupFromId(endpoint.source);
	return ensureModel(
		context.models,
		name,
		[
			`public enum ${name}: String, Swift.Error, CaseIterable, Sendable {`,
			...errors.map((error) => {
				const identifier = toSwiftSafeIdentifier(toCamelCase(error.name));
				return `\tcase ${identifier} = "${error.name}"`;
			}),
			"",
			"\tpublic init?(transportError: XRPCTransportError) {",
			"\t\tguard let rawValue = transportError.payload?.error else {",
			"\t\t\treturn nil",
			"\t\t}",
			"\t\tself.init(rawValue: rawValue)",
			"\t}",
			"}",
		].join("\n"),
		group,
	);
}

function buildEndpointModels(
	endpoint: IREndpoint,
	context: GeneratedContext,
): EndpointSurface {
	const binaryInput =
		endpoint.method === "procedure" &&
		isBinaryInputEncoding(endpoint.inputEncoding);
	const outputKind = classifyOutputKind(endpoint.outputEncoding);
	const parametersType =
		endpoint.method === "query" || endpoint.method === "subscription"
			? buildEndpointHelperType(
					endpoint,
					"Parameters",
					endpoint.parametersSchema,
					context,
					{ queryEncodable: true },
				)
			: null;
	const inputType =
		endpoint.method === "procedure"
			? buildEndpointHelperType(
					endpoint,
					"Input",
					endpoint.inputSchema,
					context,
					{
						binaryInput,
						contentType: defaultBinaryContentType(endpoint.inputEncoding),
					},
				)
			: parametersType;
	const outputType =
		endpoint.method === "subscription"
			? null
			: outputKind === "json"
				? endpoint.outputSchema
					? buildEndpointHelperType(
							endpoint,
							"Output",
							endpoint.outputSchema,
							context,
						)
					: "EmptyResponse"
				: null;
	const messageType =
		endpoint.method === "subscription"
			? buildEndpointHelperType(
					endpoint,
					"Message",
					endpoint.messageSchema,
					context,
				)
			: null;
	const errorType = buildEndpointErrorType(endpoint, context);
	const segments = endpoint.id.split(".");

	return {
		id: endpoint.fullName,
		namespaceSegments: segments.slice(0, -1),
		functionName: toCamelCase(segments.at(-1) ?? endpoint.name),
		method: endpoint.method === "query" ? "GET" : "POST",
		path: endpoint.path,
		kind: endpoint.method,
		inputType,
		outputType: endpoint.method === "subscription" ? messageType : outputType,
		errorType,
		inputEncoding: endpoint.inputEncoding,
		outputEncoding: endpoint.outputEncoding,
		outputKind,
		binaryInput,
	};
}

function namespaceNode(segment: string, prefix: string[]): NamespaceNode {
	return {
		segment,
		prefix,
		children: new Map<string, NamespaceNode>(),
		endpoints: [],
	};
}

function buildNamespaceTree(endpoints: EndpointSurface[]): NamespaceNode {
	const root = namespaceNode("", []);
	for (const endpoint of endpoints) {
		let current = root;
		for (const segment of endpoint.namespaceSegments) {
			let child = current.children.get(segment);
			if (!child) {
				child = namespaceNode(segment, [...current.prefix, segment]);
				current.children.set(segment, child);
			}
			current = child;
		}
		current.endpoints.push(endpoint);
	}
	return root;
}

function namespaceStructName(prefix: string[]): string {
	return `${prefix.map(toPascalCase).join("")}Namespace`;
}

function endpointReturnType(endpoint: EndpointSurface): string {
	if (endpoint.kind === "subscription") {
		return endpoint.outputType ?? "ATProtocolValueContainer";
	}

	return endpoint.outputKind === "json"
		? (endpoint.outputType ?? "ATProtocolValueContainer")
		: "Data";
}

function renderAsyncEndpointMethod(
	endpoint: EndpointSurface,
	requestExpression: string,
): string[] {
	const signature = endpoint.inputType ? `input: ${endpoint.inputType}` : "";
	const lines = [
		`\tpublic func ${endpoint.functionName}(${signature}) async throws -> ${endpointReturnType(endpoint)} {`,
	];

	if (endpoint.errorType) {
		lines.push("\t\tdo {");
		lines.push(`\t\t\treturn try await ${requestExpression}`);
		lines.push("\t\t} catch let error as XRPCTransportError {");
		lines.push(
			`\t\t\tif let typedError = ${endpoint.errorType}(transportError: error) {`,
		);
		lines.push("\t\t\t\tthrow typedError");
		lines.push("\t\t\t}");
		lines.push("\t\t\tthrow error");
		lines.push("\t\t}");
	} else {
		lines.push(`\t\treturn try await ${requestExpression}`);
	}

	lines.push("\t}");
	return lines;
}

function renderEndpointMethod(endpoint: EndpointSurface): string[] {
	if (endpoint.kind === "subscription") {
		const args = endpoint.inputType ? `input: ${endpoint.inputType}` : "";
		const queryItems = endpoint.inputType ? "input.asQueryItems()" : "[]";
		return [
			`\tpublic func ${endpoint.functionName}(${args}) -> AsyncThrowingStream<XRPCSubscriptionEvent<${endpoint.outputType ?? "ATProtocolValueContainer"}>, Error> {`,
			`\t\tclient.subscribe(path: "${endpoint.path}", queryItems: ${queryItems}, responseType: ${endpoint.outputType ?? "ATProtocolValueContainer"}.self)`,
			"\t}",
		];
	}

	if (endpoint.method === "GET") {
		const queryItems = endpoint.inputType ? "input.asQueryItems()" : "[]";
		return renderAsyncEndpointMethod(
			endpoint,
			endpoint.outputKind === "json"
				? `client.requestJSON(method: "GET", path: "${endpoint.path}", queryItems: ${queryItems}, responseType: ${endpoint.outputType ?? "ATProtocolValueContainer"}.self)`
				: `client.requestData(method: "GET", path: "${endpoint.path}", queryItems: ${queryItems}, responseKind: .${endpoint.outputKind})`,
		);
	}

	if (endpoint.binaryInput && endpoint.inputType) {
		return renderAsyncEndpointMethod(
			endpoint,
			endpoint.outputKind === "json"
				? `client.requestJSON(method: "POST", path: "${endpoint.path}", body: input.data, queryItems: [], headers: ["Content-Type": input.contentType], responseType: ${endpoint.outputType ?? "ATProtocolValueContainer"}.self)`
				: `client.requestData(method: "POST", path: "${endpoint.path}", body: input.data, queryItems: [], headers: ["Content-Type": input.contentType], responseKind: .${endpoint.outputKind})`,
		);
	}

	const body = endpoint.inputType ? "try client.encodedBody(input)" : "nil";
	return renderAsyncEndpointMethod(
		endpoint,
		endpoint.outputKind === "json"
			? `client.requestJSON(method: "POST", path: "${endpoint.path}", body: ${body}, queryItems: [], headers: ${endpoint.inputType ? '["Content-Type": "application/json"]' : "[:]"}, responseType: ${endpoint.outputType ?? "ATProtocolValueContainer"}.self)`
			: `client.requestData(method: "POST", path: "${endpoint.path}", body: ${body}, queryItems: [], headers: ${endpoint.inputType ? '["Content-Type": "application/json"]' : "[:]"}, responseKind: .${endpoint.outputKind})`,
	);
}

function renderNamespaceNode(node: NamespaceNode): string[] {
	const output: string[] = [];
	if (node.prefix.length > 0) {
		const structName = namespaceStructName(node.prefix);
		output.push(`public struct ${structName} {`);
		output.push("\tfileprivate let client: ATProtoClient");
		output.push("");
		output.push("\tfileprivate init(client: ATProtoClient) {");
		output.push("\t\tself.client = client");
		output.push("\t}");

		for (const child of Array.from(node.children.values()).sort((left, right) =>
			left.segment.localeCompare(right.segment),
		)) {
			output.push("");
			output.push(
				`\tpublic var ${toCamelCase(child.segment)}: ${namespaceStructName(child.prefix)} {`,
			);
			output.push(`\t\t${namespaceStructName(child.prefix)}(client: client)`);
			output.push("\t}");
		}

		for (const endpoint of [...node.endpoints].sort((left, right) =>
			left.functionName.localeCompare(right.functionName),
		)) {
			output.push("");
			output.push(...renderEndpointMethod(endpoint));
		}

		output.push("}");
		output.push("");
	}

	for (const child of Array.from(node.children.values()).sort((left, right) =>
		left.segment.localeCompare(right.segment),
	)) {
		output.push(...renderNamespaceNode(child));
	}

	return output;
}

function renderEndpointNamespaces(endpoints: EndpointSurface[]): string {
	const root = buildNamespaceTree(endpoints);
	const topLevel = Array.from(root.children.values()).sort((left, right) =>
		left.segment.localeCompare(right.segment),
	);
	const lines: string[] = ["import Foundation", ""];

	lines.push("public extension ATProtoClient {");
	for (const child of topLevel) {
		lines.push(
			`\tvar ${toCamelCase(child.segment)}: ${namespaceStructName(child.prefix)} {`,
		);
		lines.push(`\t\t${namespaceStructName(child.prefix)}(client: self)`);
		lines.push("\t}");
	}
	lines.push("}");
	lines.push("");
	lines.push(...renderNamespaceNode(root));
	return lines.join("\n");
}

export async function emitSwiftFromIR(
	ir: LexiconIR,
	outputDir: string,
	options: SwiftEmitterOptions = {},
): Promise<void> {
	const outDir = path.resolve(outputDir);
	const filePrefix = options.filePrefix ?? "";
	await fs.mkdir(outDir, { recursive: true });

	const context: GeneratedContext = {
		definitions: ir.definitionIndex,
		models: new Map(),
		knownValueEnums: new Map(),
		inlineUnions: new Map(),
	};

	for (const named of ir.namedTypes) {
		buildNamedType(named, context);
	}

	const endpointSurfaces = ir.endpoints.map((endpoint) =>
		buildEndpointModels(endpoint, context),
	);

	const groupedModels = new Map<string, SwiftModel[]>();
	for (const model of context.models.values()) {
		if (!groupedModels.has(model.group)) {
			groupedModels.set(model.group, []);
		}
		groupedModels.get(model.group)?.push(model);
	}

	for (const models of groupedModels.values()) {
		models.sort((left, right) => left.name.localeCompare(right.name));
	}

	const templatesDir = path.join(process.cwd(), "templates", "swift");
	const modelsTemplate = path.join(templatesDir, "models.ejs");
	const runtimeTemplate = path.join(templatesDir, "runtime.ejs");
	const [modelsTemplateText, runtimeTemplateText] = await Promise.all([
		fs.readFile(modelsTemplate, "utf8"),
		fs.readFile(runtimeTemplate, "utf8"),
	]);

	const existingGenerated = await fs.readdir(outDir);
	await Promise.all(
		existingGenerated
			.filter((file) => file.endsWith(".swift"))
			.map((file) => fs.rm(path.join(outDir, file), { force: true })),
	);

	const runtimeText = ejs.render(
		runtimeTemplateText,
		{},
		{ filename: runtimeTemplate },
	);
	const endpointsText = renderEndpointNamespaces(endpointSurfaces);

	await Promise.all([
		fs.writeFile(
			path.join(outDir, prefixedFileName("Models.swift", filePrefix)),
			runtimeText,
		),
		...Array.from(groupedModels.entries()).map(([group, models]) =>
			fs.writeFile(
				path.join(outDir, modelFileName(group, filePrefix)),
				ejs.render(
					modelsTemplateText,
					{ models },
					{ filename: modelsTemplate },
				),
			),
		),
		fs.writeFile(
			path.join(outDir, prefixedFileName("Endpoints.swift", filePrefix)),
			endpointsText,
		),
	]);
}
