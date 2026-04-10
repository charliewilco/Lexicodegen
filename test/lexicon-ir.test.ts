import { describe, expect, test } from "bun:test";
import type { LexiconDoc } from "@atproto/lexicon";
import { buildLexiconIR, normalizeRef } from "../lib/lexicon-ir";

describe("buildLexiconIR", () => {
	test("applies filters and excludes unsupported def kinds", () => {
		const docs: LexiconDoc[] = [
			{
				lexicon: 1,
				id: "app.bsky.feed.getFeed",
				defs: {
					main: {
						type: "query",
						output: {
							encoding: "application/json",
							schema: {
								type: "object",
								properties: {
									cursor: {
										type: "string",
									},
								},
							},
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
					deprecatedThing: {
						type: "object",
						description: "Deprecated: old shape",
						properties: {
							old: {
								type: "string",
							},
						},
					},
				},
			},
			{
				lexicon: 1,
				id: "app.bsky.feed.subscribeFeed",
				defs: {
					main: {
						type: "subscription",
						message: {
							schema: {
								type: "union",
								refs: ["app.bsky.feed.getFeed.recordType"],
							},
						},
					},
				},
			},
			{
				lexicon: 1,
				id: "app.bsky.unspecced.widget",
				defs: {
					main: {
						type: "record",
						record: {
							type: "object",
							properties: {
								value: {
									type: "integer",
								},
							},
						},
					},
				},
			},
			{
				lexicon: 1,
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
		];

		const ir = buildLexiconIR(docs, {
			allowPrefixes: ["app.bsky"],
			denyPrefixes: ["com.other"],
			denyUnspecced: true,
			denyDeprecated: true,
		});

		expect(ir.documents.map((doc) => doc.id)).toEqual([
			"app.bsky.feed.getFeed",
			"app.bsky.feed.subscribeFeed",
		]);
		expect(ir.endpoints.map((endpoint) => endpoint.fullName)).toEqual([
			"app.bsky.feed.getFeed",
			"app.bsky.feed.subscribeFeed",
		]);
		expect(ir.namedTypes.map((named) => named.fullName)).toEqual([
			"app.bsky.feed.getFeed.recordType",
		]);
		expect(
			ir.definitionIndex.has("app.bsky.feed.getFeed.recordType"),
		).toBeTrue();
		expect(ir.definitionIndex.has("app.bsky.unspecced.widget")).toBeFalse();
		expect(
			ir.definitionIndex.has("app.bsky.feed.getFeed.deprecatedThing"),
		).toBeFalse();
	});

	test("returns deterministic ordering for unsorted documents and definitions", () => {
		const docs: LexiconDoc[] = [
			{
				lexicon: 1,
				id: "com.zed.alpha",
				defs: {
					zz: { type: "object", properties: { name: { type: "string" } } },
					aa: { type: "object", properties: { value: { type: "string" } } },
				},
			},
			{
				lexicon: 1,
				id: "app.bsky.alpha",
				defs: {
					bb: { type: "object", properties: { value: { type: "string" } } },
					main: {
						type: "procedure",
						input: {
							encoding: "application/json",
						},
						output: {
							encoding: "application/json",
						},
					},
				},
			},
		];

		const ir = buildLexiconIR(docs, {
			allowPrefixes: [],
			denyPrefixes: [],
			denyUnspecced: false,
			denyDeprecated: false,
		});

		expect(ir.documents.map((doc) => doc.id)).toEqual([
			"app.bsky.alpha",
			"com.zed.alpha",
		]);
		expect(ir.namedTypes.map((named) => named.fullName)).toEqual([
			"app.bsky.alpha.bb",
			"com.zed.alpha.aa",
			"com.zed.alpha.zz",
		]);
		expect(ir.endpoints.map((endpoint) => endpoint.fullName)).toEqual([
			"app.bsky.alpha",
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
