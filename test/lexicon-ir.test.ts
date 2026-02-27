import { describe, expect, test } from "bun:test";
import { buildLexiconIR, normalizeRef } from "../lib/lexicon-ir";

describe("buildLexiconIR", () => {
	test("applies filters and excludes unsupported def kinds", () => {
		const ir = buildLexiconIR(
			[
				{
					id: "app.bsky.feed.getFeed",
					defs: {
						main: {
							type: "query",
							output: {
								schema: { type: "string" },
							},
						},
						recordType: {
							type: "record",
							record: {
								type: "object",
								properties: {
									cursor: {
										type: "string",
									},
								},
							},
						},
						unspeccedThing: {
							type: "object",
							properties: {
								value: {
									type: "integer",
								},
							},
						},
						deprecatedThing: {
							type: "object",
							description: "Deprecated: old shape",
							properties: {
								old: {
									type: "string",
								},
							},
						},
						subscriptionType: {
							type: "subscription",
							did: {
								type: "string",
							},
						},
					},
				},
				{
					id: "com.other.test",
					defs: {
						main: {
							type: "record",
							record: {
								type: "object",
								properties: {
									name: {
										type: "string",
									},
								},
							},
						},
					},
				},
			],
			{
				allowPrefixes: ["app.bsky"],
				denyPrefixes: ["com.other"],
				denyUnspecced: true,
				denyDeprecated: true,
			},
		);

		expect(ir.documents.map((doc) => doc.id)).toEqual(["app.bsky.feed.getFeed"]);
		expect(ir.endpoints.map((endpoint) => endpoint.fullName)).toEqual([
			"app.bsky.feed.getFeed.main",
		]);
		expect(ir.namedTypes.map((named) => named.fullName)).toEqual([
			"app.bsky.feed.getFeed.recordType",
		]);
		expect(ir.definitionIndex.has("app.bsky.feed.getFeed.recordType")).toBeTrue();
		expect(ir.definitionIndex.has("app.bsky.feed.getFeed.unspeccedThing")).toBeFalse();
		expect(ir.definitionIndex.has("app.bsky.feed.getFeed.deprecatedThing")).toBeFalse();
	});

	test("returns deterministic ordering for unsorted documents and definitions", () => {
		const ir = buildLexiconIR(
			[
				{
					id: "com.z",
					defs: {
						zz: { type: "object", properties: { name: { type: "string" } } },
						aa: { type: "object", properties: { value: { type: "string" } } },
					},
				},
				{
					id: "app.bsky.a",
					defs: {
						bb: { type: "object", properties: { value: { type: "string" } } },
						aa: { type: "procedure", input: {}, output: {} },
					},
				},
			],
			{
				allowPrefixes: [],
				denyPrefixes: [],
				denyUnspecced: false,
				denyDeprecated: false,
			},
		);

		expect(ir.documents.map((doc) => doc.id)).toEqual(["app.bsky.a", "com.z"]);
		expect(ir.namedTypes.map((named) => named.fullName)).toEqual([
			"app.bsky.a.bb",
			"com.z.aa",
			"com.z.zz",
		]);
		expect(ir.endpoints.map((endpoint) => endpoint.fullName)).toEqual([
			"app.bsky.a.aa",
		]);
	});
});

test("normalizeRef", () => {
	expect(normalizeRef("#main", "app.bsky.feed.getPost")).toBe(
		"app.bsky.feed.getPost.main",
	);
	expect(normalizeRef("app.other#reply", "app.bsky.feed.getPost")).toBe(
		"app.other.reply",
	);
	expect(normalizeRef("app.other.type", "app.bsky.feed.getPost")).toBe(
		"app.other.type",
	);
});
