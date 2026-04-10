import type { LexiconDoc } from "@atproto/lexicon";
import type { GenerationFilter } from "./config";
import { calculateTag, isDeprecatedDefinition } from "./utils";

export type RawLexiconSchema = {
	type?: string;
	format?: string;
	description?: string;
	required?: string[];
	nullable?: string[];
	properties?: Record<string, RawLexiconSchema>;
	items?: RawLexiconSchema;
	knownValues?: string[];
	ref?: string;
	refs?: string[];
	record?: RawLexiconSchema;
	schema?: RawLexiconSchema;
	parameters?: RawLexiconSchema;
	input?: {
		encoding?: string;
		schema?: RawLexiconSchema;
	};
	output?: {
		encoding?: string;
		schema?: RawLexiconSchema;
	};
	message?: {
		schema?: RawLexiconSchema;
	};
	errors?: Array<{
		name?: string;
		description?: string;
	}>;
	permissions?: RawLexiconSchema[];
	lxm?: string[];
	accept?: string[];
	closed?: boolean;
	encoding?: string;
	key?: string;
	title?: string;
	detail?: string;
	[key: string]: unknown;
};

type RawLexiconDef = RawLexiconSchema;
type LexiconDefMap = Record<string, RawLexiconDef>;

type DefinitionCandidate = {
	docId: string;
	name: string;
	fullName: string;
	definition: RawLexiconDef;
	source: string;
	tag: string;
	type: string;
};

export type IREndpointError = {
	name: string;
	description?: string;
};

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
	method: "query" | "procedure" | "subscription";
	source: string;
	tag: string;
	path: string;
	parametersSchema?: RawLexiconSchema;
	inputSchema?: RawLexiconSchema;
	inputEncoding?: string;
	outputSchema?: RawLexiconSchema;
	outputEncoding?: string;
	messageSchema?: RawLexiconSchema;
	errors: IREndpointError[];
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

function collectReferencedDefinitions(
	value: unknown,
	currentId: string,
	references = new Set<string>(),
): Set<string> {
	if (Array.isArray(value)) {
		for (const item of value) {
			collectReferencedDefinitions(item, currentId, references);
		}
		return references;
	}

	if (value == null || typeof value !== "object") {
		return references;
	}

	const record = value as Record<string, unknown>;
	if (typeof record.ref === "string") {
		references.add(normalizeRef(record.ref, currentId));
	}

	if (Array.isArray(record.refs)) {
		for (const ref of record.refs) {
			if (typeof ref === "string") {
				references.add(normalizeRef(ref, currentId));
			}
		}
	}

	for (const nested of Object.values(record)) {
		collectReferencedDefinitions(nested, currentId, references);
	}

	return references;
}

function toEndpoint(candidate: DefinitionCandidate): IREndpoint {
	const definition = candidate.definition;
	return {
		id: candidate.docId,
		name: candidate.name,
		fullName: candidate.fullName,
		definition,
		method: candidate.type as IREndpoint["method"],
		source: candidate.source,
		tag: candidate.tag,
		path: `/xrpc/${candidate.docId}`,
		parametersSchema:
			definition.parameters?.type === "params"
				? definition.parameters
				: undefined,
		inputSchema: definition.input?.schema,
		inputEncoding:
			typeof definition.input?.encoding === "string"
				? definition.input.encoding
				: undefined,
		outputSchema: definition.output?.schema,
		outputEncoding:
			typeof definition.output?.encoding === "string"
				? definition.output.encoding
				: undefined,
		messageSchema: definition.message?.schema,
		errors: (definition.errors ?? [])
			.flatMap((error): IREndpointError[] => {
				if (!error?.name) {
					return [];
				}
				return [{ name: error.name, description: error.description }];
			})
			.sort((left, right) => left.name.localeCompare(right.name)),
	};
}

export function buildLexiconIR(
	lexiconDocs: LexiconDoc[],
	filters: LexiconIRFilter,
): LexiconIR {
	const sortedDocs = [...lexiconDocs].sort((a, b) => a.id.localeCompare(b.id));
	const candidates = new Map<string, DefinitionCandidate>();
	const docCandidates = new Map<string, DefinitionCandidate[]>();

	for (const doc of sortedDocs) {
		const defs = asSafeDefs(doc);
		const defKeys = Object.keys(defs).sort();
		const matchedTag = calculateTag(doc.id);
		const perDoc: DefinitionCandidate[] = [];

		for (const name of defKeys) {
			const definitionValue = defs[name];
			if (!isLexiconDefinition(definitionValue)) {
				continue;
			}

			const fullName = name === "main" ? doc.id : `${doc.id}.${name}`;
			const candidate: DefinitionCandidate = {
				docId: doc.id,
				name,
				fullName,
				definition: definitionValue,
				source: doc.id,
				tag: matchedTag,
				type: definitionValue.type ?? "unknown",
			};

			candidates.set(fullName, candidate);
			perDoc.push(candidate);
		}

		docCandidates.set(doc.id, perDoc);
	}

	const included = new Set<string>();
	const queue: string[] = [];

	for (const candidate of candidates.values()) {
		if (
			shouldIncludeDefinition(candidate.fullName, candidate.definition, filters)
		) {
			included.add(candidate.fullName);
			queue.push(candidate.fullName);
		}
	}

	while (queue.length > 0) {
		const next = queue.shift();
		if (!next) {
			continue;
		}

		const candidate = candidates.get(next);
		if (!candidate) {
			continue;
		}

		const refs = collectReferencedDefinitions(
			candidate.definition,
			candidate.docId,
		);
		for (const ref of refs) {
			if (!included.has(ref) && candidates.has(ref)) {
				included.add(ref);
				queue.push(ref);
			}
		}
	}

	const byLexicon: LexiconIRDocument[] = [];
	const namedTypes: IRNamedType[] = [];
	const endpoints: IREndpoint[] = [];

	for (const doc of sortedDocs) {
		const perDoc = docCandidates.get(doc.id) ?? [];
		const docNamedTypes: IRNamedType[] = [];
		const docEndpoints: IREndpoint[] = [];

		for (const candidate of perDoc) {
			if (!included.has(candidate.fullName)) {
				continue;
			}

			if (
				candidate.type === "query" ||
				candidate.type === "procedure" ||
				candidate.type === "subscription"
			) {
				const endpoint = toEndpoint(candidate);
				docEndpoints.push(endpoint);
				endpoints.push(endpoint);
				continue;
			}

			const namedType: IRNamedType = {
				id: candidate.docId,
				name: candidate.name,
				fullName: candidate.fullName,
				definition: candidate.definition,
				source: candidate.source,
				tag: candidate.tag,
				type: candidate.type,
			};

			docNamedTypes.push(namedType);
			namedTypes.push(namedType);
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
