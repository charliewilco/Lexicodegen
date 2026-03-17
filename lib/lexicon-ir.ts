import type { LexiconDoc } from "@atproto/lexicon";
import type { GenerationFilter } from "./config";
import { calculateTag, isDeprecatedDefinition } from "./utils";

type RawLexiconDef = {
	type?: string;
	description?: string;
	[key: string]: unknown;
};

type LexiconDefMap = Record<string, RawLexiconDef>;

export type IRNamedType = {
	id: string;
	name: string;
	fullName: string;
	definition: RawLexiconDef;
	source: string;
	tag: string;
	type: string;
};

export type IREndpoint = {
	id: string;
	name: string;
	fullName: string;
	definition: RawLexiconDef;
	method: "query" | "procedure";
	source: string;
	tag: string;
	path: string;
};

export type LexiconIRDocument = {
	id: string;
	source: string;
	defs: IRNamedType[];
	endpoints: IREndpoint[];
};

export type LexiconIR = {
	documents: LexiconIRDocument[];
	namedTypes: IRNamedType[];
	endpoints: IREndpoint[];
	definitionIndex: Map<string, IRNamedType>;
};

export type LexiconIRFilter = GenerationFilter;

function matchesPrefixFilter(value: string, prefixes: string[]): boolean {
	return prefixes.some((prefix) => value.startsWith(prefix));
}

function isAllowedIdentifier(id: string, filters: LexiconIRFilter): boolean {
	if (filters.allowPrefixes?.length) {
		if (!matchesPrefixFilter(id, filters.allowPrefixes)) {
			return false;
		}
	}

	if (filters.denyPrefixes?.length) {
		if (matchesPrefixFilter(id, filters.denyPrefixes)) {
			return false;
		}
	}

	return true;
}

function shouldIncludeDefinition(
	id: string,
	definition: RawLexiconDef,
	filters: LexiconIRFilter,
): boolean {
	if (!isAllowedIdentifier(id, filters)) {
		return false;
	}

	if (filters.denyUnspecced && id.includes(".unspecced.")) {
		return false;
	}

	if (
		filters.denyDeprecated &&
		isDeprecatedDefinition(definition.description)
	) {
		return false;
	}

	return true;
}

function isLexiconDefinition(value: unknown): value is RawLexiconDef {
	return (
		value != null &&
		typeof value === "object" &&
		"type" in value &&
		typeof (value as { type?: unknown }).type === "string"
	);
}

function asSafeDefs(doc: LexiconDoc): LexiconDefMap {
	return (doc.defs ?? {}) as LexiconDefMap;
}

export function normalizeRef(ref: string, currentId: string): string {
	if (ref.startsWith("#")) {
		return `${currentId}.${ref.slice(1)}`;
	}

	if (ref.includes("#")) {
		return ref.replace("#", ".");
	}

	return ref;
}

export function buildLexiconIR(
	lexiconDocs: LexiconDoc[],
	filters: LexiconIRFilter,
): LexiconIR {
	const byLexicon: LexiconIRDocument[] = [];
	const namedTypes: IRNamedType[] = [];
	const endpoints: IREndpoint[] = [];

	const sortedDocs = [...lexiconDocs].sort((a, b) => a.id.localeCompare(b.id));

	for (const doc of sortedDocs) {
		const defs = asSafeDefs(doc);
		const defKeys = Object.keys(defs).sort();
		const matchedTag = calculateTag(doc.id);
		const docNamedTypes: IRNamedType[] = [];
		const docEndpoints: IREndpoint[] = [];

		for (const name of defKeys) {
			const definitionValue = defs[name];
			if (!isLexiconDefinition(definitionValue)) {
				continue;
			}

			const definition = definitionValue;
			const fullName = name === "main" ? doc.id : `${doc.id}.${name}`;
			const type = definition.type;

			if (!shouldIncludeDefinition(fullName, definition, filters)) {
				continue;
			}

			if (type === "query" || type === "procedure") {
				const endpoint: IREndpoint = {
					id: doc.id,
					name,
					fullName,
					definition,
					method: type,
					source: doc.id,
					tag: matchedTag,
					path: `/xrpc/${doc.id}`,
				};
				docEndpoints.push(endpoint);
				endpoints.push(endpoint);
			}

			if (type !== "query" && type !== "procedure" && type !== "subscription") {
				const namedType: IRNamedType = {
					id: doc.id,
					name,
					fullName,
					definition,
					source: doc.id,
					tag: matchedTag,
					type: type ?? "unknown",
				};
				docNamedTypes.push(namedType);
				namedTypes.push(namedType);
			}
		}

		if (docNamedTypes.length === 0 && docEndpoints.length === 0) {
			continue;
		}

		byLexicon.push({
			id: doc.id,
			source: doc.id,
			defs: docNamedTypes,
			endpoints: docEndpoints,
		});
	}

	const definitionIndex = new Map<string, IRNamedType>();
	for (const namedType of namedTypes) {
		definitionIndex.set(namedType.fullName, namedType);
	}

	return {
		documents: byLexicon.sort((a, b) => a.id.localeCompare(b.id)),
		namedTypes: namedTypes.sort((a, b) => a.fullName.localeCompare(b.fullName)),
		endpoints: endpoints.sort((a, b) => a.fullName.localeCompare(b.fullName)),
		definitionIndex,
	};
}
