import fs from "node:fs/promises";
import { styleText } from "node:util";
import type { OpenAPIV3_1 } from "openapi-types";

import * as Converters from "../converters/mod";
import type { IREndpoint, IRNamedType, LexiconIR } from "../lexicon-ir";
import { calculateTag } from "../utils";

type PermissionSetExtension = {
	scope: string;
	title?: string;
	detail?: string;
	permissions: unknown[];
};

function descriptionPrefix(id: string): string {
	if (id.startsWith("tools.ozone.")) {
		return `*This endpoint is part of the Ozone moderation service.*`;
	}

	if (id.startsWith("chat.bsky.")) {
		return `*This endpoint is part of the Bluesky Chat (DM) APIs.*`;
	}

	if (id.startsWith("com.atproto.admin.")) {
		return `*This endpoint is part of the atproto PDS management APIs.*`;
	}

	if (id.startsWith("com.atproto.sync.")) {
		return `*This endpoint is part of the atproto repository synchronization APIs.*`;
	}

	if (id.startsWith("com.atproto.repo.")) {
		return `*This endpoint is part of the atproto PDS repository management APIs.*`;
	}

	if (id.startsWith("com.atproto.server.")) {
		return `*This endpoint is part of the atproto PDS server and account management APIs.*`;
	}

	if (id.startsWith("app.bsky.")) {
		return `*This endpoint is part of the Bluesky application Lexicon APIs (app.bsky.*).*`;
	}

	return `*To learn more about calling atproto API endpoints like this one, see the [API Hosts and Auth](/docs/advanced-guides/api-directory) guide.*`;
}

function addDefinitionDescription(
	definition: { description?: string },
	prefix: string,
): void {
	if (!definition.description) {
		definition.description = prefix;
		return;
	}

	if (!definition.description.includes(prefix)) {
		definition.description = `${prefix}\n\n${definition.description}`;
	}
}

function addEndpointDescription<T extends { description?: string }>(
	target: T,
	endpointId: string,
): T {
	addDefinitionDescription(target, descriptionPrefix(endpointId));
	return target;
}

function convertNamedType(
	def: IRNamedType,
): OpenAPIV3_1.SchemaObject | undefined {
	switch (def.definition.type) {
		case "array":
			return Converters.convertArray(def.id, def.name, def.definition as never);
		case "object":
			return Converters.convertObject(
				def.id,
				def.name,
				def.definition as never,
			);
		case "record":
			return Converters.convertRecord(
				def.id,
				def.name,
				def.definition as never,
			);
		case "string":
			return Converters.convertString(
				def.id,
				def.name,
				def.definition as never,
			);
		case "token":
			return Converters.convertToken(def.id, def.name, def.definition as never);
		case "permission-set":
			return Converters.convertPermissionSet(def.definition as never);
		default:
			return undefined;
	}
}

export async function emitOpenAPI(
	ir: LexiconIR,
	outputPath: string,
): Promise<void> {
	const paths: Record<string, Record<string, unknown>> = {};
	const components: OpenAPIV3_1.ComponentsObject = {
		schemas: {},
		securitySchemes: {
			Bearer: {
				type: "http",
				scheme: "bearer",
			},
		},
	};

	const tagNames = new Set<string>();
	const permissionSets: Record<string, PermissionSetExtension> = {};

	console.info(
		styleText("blue", "Processing from IR with"),
		styleText("bold", `${ir.namedTypes.length} named types`),
		styleText("blue", "and"),
		styleText("bold", `${ir.endpoints.length} endpoints`),
	);

	for (const def of ir.namedTypes) {
		tagNames.add(calculateTag(def.id));
		const schema = convertNamedType(def);

		if (schema) {
			if (components.schemas) {
				components.schemas[def.fullName] = schema;
			}
			continue;
		}

		if (def.definition.type === "permission-set") {
			if (components.schemas) {
				components.schemas[def.fullName] = Converters.convertPermissionSet(
					def.definition as never,
				);
			}
			permissionSets[def.fullName] = {
				scope: `include:${def.fullName}`,
				...("title" in def.definition && def.definition.title
					? { title: def.definition.title as string }
					: {}),
				...("detail" in def.definition && def.definition.detail
					? { detail: def.definition.detail as string }
					: {}),
				permissions:
					"permissions" in def.definition &&
					Array.isArray(
						(def.definition as { permissions?: unknown[] }).permissions,
					)
						? ((def.definition as { permissions?: unknown[] }).permissions ??
							[])
						: [],
			};
		}
	}

	for (const endpoint of ir.endpoints as IREndpoint[]) {
		tagNames.add(endpoint.tag);

		if (endpoint.method === "query") {
			const query = endpoint.definition as never;
			const operation = await Converters.convertQuery(
				endpoint.id,
				endpoint.name,
				query,
			);
			if (operation) {
				const item = paths[endpoint.path] ?? {};
				item.get = operation;
				paths[endpoint.path] = item;
				addEndpointDescription(
					operation as OpenAPIV3_1.OperationObject,
					endpoint.id,
				);
			}
			continue;
		}

		const procedure = endpoint.definition as never;
		const operation = await Converters.convertProcedure(
			endpoint.id,
			endpoint.name,
			procedure,
		);
		if (operation) {
			const item = paths[endpoint.path] ?? {};
			item.post = operation;
			paths[endpoint.path] = item;
			addEndpointDescription(
				operation as OpenAPIV3_1.OperationObject,
				endpoint.id,
			);
		}
	}

	const api = {
		openapi: "3.1.0",
		info: {
			title: "AT Protocol XRPC API",
			summary:
				"Conversion of AT Protocol's lexicons to OpenAPI's schema format.",
			description:
				"This section contains HTTP API reference docs for AT Protocol lexicons. Generate a bearer token to test API calls directly from the docs.",
			version: "0.0.0",
		},
		servers: [],
		paths,
		components,
		tags: Array.from(tagNames).map((name) => ({ name })),
	} as OpenAPIV3_1.Document;

	if (Object.keys(permissionSets).length > 0) {
		(api as OpenAPIV3_1.Document & { "x-atproto-permission-sets": unknown })[
			"x-atproto-permission-sets"
		] = permissionSets;
	}

	await fs.writeFile(outputPath, `${JSON.stringify(api, null, "\t")}\n`);
}
