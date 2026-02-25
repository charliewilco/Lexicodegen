import type { LexPermission, LexPermissionSet } from "@atproto/lexicon";
import type { OpenAPIV3_1 } from "openapi-types";

function buildPermissionSchema(
	permission: LexPermission,
): OpenAPIV3_1.SchemaObject {
	return {
		type: "object",
		required: ["type", "resource"],
		properties: {
			type: { type: "string", const: "permission" },
			resource: { type: "string", const: permission.resource },
			...(permission.description && {
				description: { type: "string", const: permission.description },
			}),
			...(permission.action && {
				action: {
					type: "array",
					items: { type: "string" },
					enum: [permission.action],
				},
			}),
			...(permission.collection && {
				collection: {
					type: "array",
					items: { type: "string" },
					enum: [permission.collection],
				},
			}),
			...(permission.lxm && {
				lxm: {
					type: "array",
					items: { type: "string" },
					enum: [permission.lxm],
				},
			}),
			...(permission.aud && {
				aud: {
					type: "string",
					const: permission.aud,
				},
			}),
			...(permission.inheritAud !== undefined && {
				inheritAud: {
					type: "boolean",
					const: permission.inheritAud,
				},
			}),
		},
		additionalProperties: true,
	};
}

export function convertPermissionSet(
	permissionSet: LexPermissionSet,
): OpenAPIV3_1.SchemaObject {
	const permissionSchemas = permissionSet.permissions.map(
		buildPermissionSchema,
	);

	return {
		type: "object",
		required: ["type", "permissions"],
		properties: {
			type: { type: "string", const: "permission-set" },
			...(permissionSet.description && {
				description: { type: "string", const: permissionSet.description },
			}),
			...(permissionSet.title && {
				title: { type: "string", const: permissionSet.title },
			}),
			...(permissionSet["title:lang"] && {
				"title:lang": {
					type: "object",
					additionalProperties: { type: "string" },
				},
			}),
			...(permissionSet.detail && {
				detail: { type: "string", const: permissionSet.detail },
			}),
			...(permissionSet["detail:lang"] && {
				"detail:lang": {
					type: "object",
					additionalProperties: { type: "string" },
				},
			}),
			permissions: {
				type: "array",
				minItems: permissionSchemas.length,
				maxItems: permissionSchemas.length,
				items: {
					oneOf: permissionSchemas,
				},
			},
		},
		additionalProperties: false,
	};
}
