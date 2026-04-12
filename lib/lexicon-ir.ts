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
	cycleAnalysis?: IRCycleAnalysis;
};

export type LexiconIRFilter = GenerationFilter;

export type IRCycleAnalysis = {
	boxedObjectProperties: Set<string>;
	indirectUnions: Set<string>;
	indirectInlineUnionKeys: Set<string>;
};

type CycleNodeKind = "object" | "union";

type CycleEdge = {
	target: string;
	kind: CycleNodeKind;
	propertyKey?: string;
};

type CycleNode = {
	fullName: string;
	kind: CycleNodeKind;
	edges: CycleEdge[];
	canonicalUnionKey?: string;
};

type CycleAnalysisState = {
	definitionIndex: Map<string, IRNamedType>;
	nodes: Map<string, CycleNode>;
	visitedNamed: Set<string>;
	visitedObjects: Set<string>;
	visitedUnions: Set<string>;
};

type CycleTarget = {
	fullName: string;
	kind: CycleNodeKind;
};

export function createEmptyCycleAnalysis(): IRCycleAnalysis {
	return {
		boxedObjectProperties: new Set<string>(),
		indirectUnions: new Set<string>(),
		indirectInlineUnionKeys: new Set<string>(),
	};
}

export function cyclePropertyKey(
	fullName: string,
	propertyKey: string,
): string {
	return `${fullName}\u0000${propertyKey}`;
}

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

function modelGroupFromId(id: string): string {
	const parts = id.split(".");
	return parts.slice(0, Math.min(parts.length, 3)).join(".");
}

function inlineUnionCycleKey(group: string, refs: string[]): string {
	return `${group}\u0000${refs.join("\u0001")}`;
}

function isObjectLikeDefinition(named: IRNamedType): boolean {
	if (named.type === "object" || named.type === "params") {
		return true;
	}

	return named.type === "record" && named.definition.record != null;
}

function isUnionLikeDefinition(named: IRNamedType): boolean {
	return named.type === "union";
}

function ensureCycleNode(
	state: CycleAnalysisState,
	fullName: string,
	kind: CycleNodeKind,
	options: {
		canonicalUnionKey?: string;
	} = {},
): CycleNode {
	const existing = state.nodes.get(fullName);
	if (existing) {
		if (!existing.canonicalUnionKey && options.canonicalUnionKey) {
			existing.canonicalUnionKey = options.canonicalUnionKey;
		}
		return existing;
	}

	const node: CycleNode = {
		fullName,
		kind,
		edges: [],
		canonicalUnionKey: options.canonicalUnionKey,
	};
	state.nodes.set(fullName, node);
	return node;
}

function registerStandaloneSchema(
	state: CycleAnalysisState,
	schema: RawLexiconSchema | undefined,
	fullName: string,
	referenceBase: string,
	group: string,
): void {
	if (!schema) {
		return;
	}

	if (schema.type === "array" && schema.items) {
		registerStandaloneSchema(
			state,
			schema.items,
			`${fullName}.item`,
			referenceBase,
			group,
		);
		return;
	}

	resolveSchemaTarget(state, schema, fullName, referenceBase, group);
}

function resolveNamedTarget(
	state: CycleAnalysisState,
	ref: string,
	referenceBase: string,
): CycleTarget | null {
	const target = normalizeRef(ref, referenceBase);
	const named = state.definitionIndex.get(target);
	if (!named) {
		return null;
	}

	ensureNamedCycleRegistration(state, target);

	if (isObjectLikeDefinition(named)) {
		return { fullName: target, kind: "object" };
	}

	if (isUnionLikeDefinition(named)) {
		return { fullName: target, kind: "union" };
	}

	if (named.type === "array" && named.definition.items) {
		registerStandaloneSchema(
			state,
			named.definition.items,
			`${target}.item`,
			named.id,
			modelGroupFromId(named.source),
		);
	}

	return null;
}

function resolveSchemaTarget(
	state: CycleAnalysisState,
	schema: RawLexiconSchema,
	fullName: string,
	referenceBase: string,
	group: string,
): CycleTarget | null {
	if (schema.type === "ref" && typeof schema.ref === "string") {
		return resolveNamedTarget(state, schema.ref, referenceBase);
	}

	if (schema.type === "object" || schema.type === "params") {
		registerObjectCycleNode(state, fullName, schema, referenceBase, group);
		return { fullName, kind: "object" };
	}

	if (schema.type === "record" && schema.record) {
		registerObjectCycleNode(
			state,
			fullName,
			schema.record,
			referenceBase,
			group,
		);
		return { fullName, kind: "object" };
	}

	if (schema.type === "union") {
		const normalizedRefs = (schema.refs ?? []).map((ref) =>
			normalizeRef(ref, referenceBase),
		);
		registerUnionCycleNode(state, fullName, schema.refs ?? [], referenceBase, {
			canonicalUnionKey: inlineUnionCycleKey(group, normalizedRefs),
		});
		return { fullName, kind: "union" };
	}

	if (schema.type === "array" && schema.items) {
		registerStandaloneSchema(
			state,
			schema.items,
			`${fullName}.item`,
			referenceBase,
			group,
		);
	}

	return null;
}

function registerObjectCycleNode(
	state: CycleAnalysisState,
	fullName: string,
	schema: RawLexiconSchema,
	referenceBase: string,
	group: string,
): void {
	ensureCycleNode(state, fullName, "object");
	if (state.visitedObjects.has(fullName)) {
		return;
	}
	state.visitedObjects.add(fullName);

	const node = ensureCycleNode(state, fullName, "object");
	const properties = schema.properties ?? {};
	for (const key of Object.keys(properties).sort()) {
		const property = properties[key];
		if (!property || key === "$type") {
			continue;
		}

		const target = resolveSchemaTarget(
			state,
			property,
			`${fullName}.${key}`,
			referenceBase,
			group,
		);
		if (!target) {
			continue;
		}

		node.edges.push({
			target: target.fullName,
			kind: target.kind,
			propertyKey: key,
		});
	}
}

function registerUnionCycleNode(
	state: CycleAnalysisState,
	fullName: string,
	refs: string[],
	referenceBase: string,
	options: {
		canonicalUnionKey?: string;
	} = {},
): void {
	ensureCycleNode(state, fullName, "union", options);
	if (state.visitedUnions.has(fullName)) {
		return;
	}
	state.visitedUnions.add(fullName);

	const node = ensureCycleNode(state, fullName, "union", options);
	for (const ref of [...refs].sort()) {
		const target = resolveNamedTarget(state, ref, referenceBase);
		if (!target) {
			continue;
		}
		node.edges.push({ target: target.fullName, kind: target.kind });
	}
}

function ensureNamedCycleRegistration(
	state: CycleAnalysisState,
	fullName: string,
): void {
	if (state.visitedNamed.has(fullName)) {
		return;
	}
	state.visitedNamed.add(fullName);

	const named = state.definitionIndex.get(fullName);
	if (!named) {
		return;
	}

	const group = modelGroupFromId(named.source);
	if (named.type === "object" || named.type === "params") {
		registerObjectCycleNode(state, fullName, named.definition, named.id, group);
		return;
	}

	if (named.type === "record" && named.definition.record) {
		registerObjectCycleNode(
			state,
			fullName,
			named.definition.record,
			named.id,
			group,
		);
		return;
	}

	if (named.type === "union") {
		registerUnionCycleNode(
			state,
			fullName,
			named.definition.refs ?? [],
			named.id,
		);
		return;
	}

	if (named.type === "array" && named.definition.items) {
		registerStandaloneSchema(
			state,
			named.definition.items,
			`${fullName}.item`,
			named.id,
			group,
		);
	}
}

function buildCycleAnalysis(
	namedTypes: IRNamedType[],
	endpoints: IREndpoint[],
	definitionIndex: Map<string, IRNamedType>,
): IRCycleAnalysis {
	const state: CycleAnalysisState = {
		definitionIndex,
		nodes: new Map<string, CycleNode>(),
		visitedNamed: new Set<string>(),
		visitedObjects: new Set<string>(),
		visitedUnions: new Set<string>(),
	};

	for (const namedType of namedTypes) {
		ensureNamedCycleRegistration(state, namedType.fullName);
	}

	for (const endpoint of endpoints) {
		const group = modelGroupFromId(endpoint.source);
		registerStandaloneSchema(
			state,
			endpoint.parametersSchema,
			`${endpoint.fullName}.Parameters`,
			endpoint.id,
			group,
		);
		registerStandaloneSchema(
			state,
			endpoint.inputSchema,
			`${endpoint.fullName}.Input`,
			endpoint.id,
			group,
		);
		registerStandaloneSchema(
			state,
			endpoint.outputSchema,
			`${endpoint.fullName}.Output`,
			endpoint.id,
			group,
		);
		registerStandaloneSchema(
			state,
			endpoint.messageSchema,
			`${endpoint.fullName}.Message`,
			endpoint.id,
			group,
		);
	}

	const boxedObjectProperties = new Set<string>();
	const objectNodes = [...state.nodes.values()]
		.filter((node) => node.kind === "object")
		.map((node) => node.fullName)
		.sort();
	const objectColors = new Map<string, 0 | 1 | 2>();
	const objectNodeSet = new Set(objectNodes);

	for (const fullName of objectNodes) {
		objectColors.set(fullName, 0);
	}

	function visitObject(fullName: string) {
		objectColors.set(fullName, 1);
		const node = state.nodes.get(fullName);
		if (node) {
			const edges = node.edges
				.filter(
					(edge): edge is CycleEdge & { propertyKey: string } =>
						edge.kind === "object" &&
						typeof edge.propertyKey === "string" &&
						objectNodeSet.has(edge.target),
				)
				.sort((left, right) => {
					if (left.propertyKey !== right.propertyKey) {
						return left.propertyKey.localeCompare(right.propertyKey);
					}
					return left.target.localeCompare(right.target);
				});

			for (const edge of edges) {
				const color = objectColors.get(edge.target) ?? 0;
				if (color === 1) {
					boxedObjectProperties.add(
						cyclePropertyKey(fullName, edge.propertyKey),
					);
					continue;
				}
				if (color === 0) {
					visitObject(edge.target);
				}
			}
		}
		objectColors.set(fullName, 2);
	}

	for (const fullName of objectNodes) {
		if ((objectColors.get(fullName) ?? 0) === 0) {
			visitObject(fullName);
		}
	}

	const adjacency = new Map<string, string[]>();
	for (const node of state.nodes.values()) {
		const targets = node.edges
			.filter((edge) => {
				if (node.kind !== "object") {
					return true;
				}
				if (edge.kind !== "object" || !edge.propertyKey) {
					return true;
				}
				return !boxedObjectProperties.has(
					cyclePropertyKey(node.fullName, edge.propertyKey),
				);
			})
			.map((edge) => edge.target)
			.sort();
		adjacency.set(node.fullName, targets);
	}

	let index = 0;
	const indices = new Map<string, number>();
	const lowLink = new Map<string, number>();
	const stack: string[] = [];
	const onStack = new Set<string>();
	const indirectUnions = new Set<string>();
	const indirectInlineUnionKeys = new Set<string>();

	function visitStronglyConnected(nodeName: string) {
		indices.set(nodeName, index);
		lowLink.set(nodeName, index);
		index += 1;
		stack.push(nodeName);
		onStack.add(nodeName);

		for (const target of adjacency.get(nodeName) ?? []) {
			if (!indices.has(target)) {
				visitStronglyConnected(target);
				lowLink.set(
					nodeName,
					Math.min(lowLink.get(nodeName) ?? 0, lowLink.get(target) ?? 0),
				);
				continue;
			}

			if (onStack.has(target)) {
				lowLink.set(
					nodeName,
					Math.min(lowLink.get(nodeName) ?? 0, indices.get(target) ?? 0),
				);
			}
		}

		if ((lowLink.get(nodeName) ?? -1) !== (indices.get(nodeName) ?? -2)) {
			return;
		}

		const component: string[] = [];
		while (stack.length > 0) {
			const current = stack.pop();
			if (!current) {
				break;
			}
			onStack.delete(current);
			component.push(current);
			if (current === nodeName) {
				break;
			}
		}

		const componentSet = new Set(component);
		const isRecursive =
			component.length > 1 ||
			component.some((name) =>
				(adjacency.get(name) ?? []).some((target) => componentSet.has(target)),
			);
		if (!isRecursive) {
			return;
		}

		for (const name of component) {
			const node = state.nodes.get(name);
			if (!node || node.kind !== "union") {
				continue;
			}
			indirectUnions.add(name);
			if (node.canonicalUnionKey) {
				indirectInlineUnionKeys.add(node.canonicalUnionKey);
			}
		}
	}

	for (const nodeName of [...state.nodes.keys()].sort()) {
		if (!indices.has(nodeName)) {
			visitStronglyConnected(nodeName);
		}
	}

	return {
		boxedObjectProperties,
		indirectUnions,
		indirectInlineUnionKeys,
	};
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

	const cycleAnalysis = buildCycleAnalysis(
		namedTypes,
		endpoints,
		definitionIndex,
	);

	return {
		documents: byLexicon.sort((a, b) => a.id.localeCompare(b.id)),
		namedTypes: namedTypes.sort((a, b) => a.fullName.localeCompare(b.fullName)),
		endpoints: endpoints.sort((a, b) => a.fullName.localeCompare(b.fullName)),
		definitionIndex,
		cycleAnalysis,
	};
}
