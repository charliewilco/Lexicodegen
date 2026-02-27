import { describe, expect, test } from "bun:test";
import fs from "node:fs/promises";
import os from "node:os";
import { spawnSync } from "node:child_process";
import path from "node:path";
import type { IREndpoint, IRNamedType, LexiconIR } from "../lib/lexicon-ir";
import { emitSwiftFromIR } from "../lib/emitter/swift";

const mockEndpoint = (
	fullName: string,
	method: "query" | "procedure",
): IREndpoint => ({
	id: fullName.split(".").slice(0, 3).join("."),
	name: fullName.split(".").at(-1) ?? fullName,
	fullName,
	definition:
		method === "query"
			? {
					type: "query",
					parameters: {
						type: "object",
						properties: {
							filter: {
								type: "string",
								description: "filtering mode",
							},
						},
					},
					output: {
						schema: { type: "ref", ref: "app.bsky.feed.status" },
					},
			  }
			: {
					type: "procedure",
					input: {
						schema: {
							type: "array",
							items: { type: "integer" },
						},
					},
					output: {
						schema: { type: "ref", ref: "app.bsky.feed.status" },
					},
			  },
	method,
	source: "app.bsky.feed",
	tag: "app.bsky.feed",
	path: `/xrpc/${fullName}`,
});

function hasSwiftCompiler(): boolean {
	const check = spawnSync("swiftc", ["-version"], {
		encoding: "utf8",
	});
	return check.status === 0;
}

describe("emitSwiftFromIR", () => {
	test("writes runtime, grouped models, and endpoints for a basic IR", async () => {
		const outputDir = await fs.mkdtemp(path.join(os.tmpdir(), "lexicodegen-swift-out-"));
		await fs.writeFile(
			path.join(outputDir, "Legacy.generated.swift"),
			"stale",
			"utf8",
		);

		const namedTypes: IRNamedType[] = [
			{
				id: "app.bsky.feed.post",
				name: "post",
				fullName: "app.bsky.feed.post",
				definition: {
					type: "record",
					record: {
						type: "object",
						properties: {
							title: {
								type: "string",
							},
							count: {
								type: "integer",
							},
						},
						required: ["title"],
					},
				},
				source: "app.bsky.feed",
				tag: "app.bsky.feed",
				type: "record",
			},
			{
				id: "app.bsky.feed",
				name: "status",
				fullName: "app.bsky.feed.status",
				definition: {
					type: "string",
					knownValues: ["ok", "error"],
				},
				source: "app.bsky.feed",
				tag: "app.bsky.feed",
				type: "string",
			},
		];

		const ir: LexiconIR = {
			documents: [],
			namedTypes,
			endpoints: [
				mockEndpoint("app.bsky.feed.get", "query"),
				mockEndpoint("app.bsky.feed.create", "procedure"),
			],
			definitionIndex: new Map(
				namedTypes.map((namedType) => [namedType.fullName, namedType]),
			),
		};

		await emitSwiftFromIR(ir, outputDir);

		const generated = await fs.readdir(outputDir);
		expect(generated).toContain("Models.swift");
		expect(generated).toContain("Endpoints.swift");
		expect(generated).toContain("AppBskyFeed.generated.swift");
		expect(generated).not.toContain("Legacy.generated.swift");

		const appBskyFeed = await fs.readFile(
			path.join(outputDir, "AppBskyFeed.generated.swift"),
			"utf8",
		);

		expect(appBskyFeed).toContain(
			"public struct AppBskyFeedPost: Codable",
		);
		expect(appBskyFeed).toContain(
			"public enum AppBskyFeedStatus: String, Codable",
		);

		const endpoints = await fs.readFile(
			path.join(outputDir, "Endpoints.swift"),
			"utf8",
		);

		expect(endpoints).toContain(
			`let encodedBody = try encodedBody(input)`,
		);
		expect(endpoints).toContain('public func appbskyfeedget(');
		expect(endpoints).toContain('public func appbskyfeedcreate(');
		expect(endpoints).toContain('path: "/xrpc/app.bsky.feed.get"');
		expect(endpoints).toContain('path: "/xrpc/app.bsky.feed.create"');
	});

	(hasSwiftCompiler() ? test : test.skip)(
		"generates compilable swift output",
		async () => {
			const outputDir = await fs.mkdtemp(
				path.join(os.tmpdir(), "lexicodegen-swift-compile-"),
			);
			const irNamedTypes: IRNamedType[] = [
				{
					id: "app.bsky.feed.post",
					name: "post",
					fullName: "app.bsky.feed.post",
					definition: {
						type: "object",
						properties: {
							title: {
								type: "string",
							},
							count: {
								type: "integer",
							},
						},
						required: ["title"],
					},
					source: "app.bsky.feed",
					tag: "app.bsky.feed",
					type: "object",
				},
			];

			const ir: LexiconIR = {
				documents: [],
				namedTypes: irNamedTypes,
				endpoints: [
					{
						id: "app.bsky.feed",
						name: "get",
						fullName: "app.bsky.feed.get",
						definition: {
							type: "query",
							output: {
								schema: {
									type: "ref",
									ref: "app.bsky.feed.post",
								},
							},
						},
						method: "query",
						source: "app.bsky.feed",
						tag: "app.bsky.feed",
						path: "/xrpc/app.bsky.feed.get",
					},
				],
				definitionIndex: new Map([
					["app.bsky.feed.post", irNamedTypes[0]],
				]),
			};

			await emitSwiftFromIR(ir, outputDir);

			const sourceFiles = (await fs.readdir(outputDir))
				.filter((file) => file.endsWith(".swift"))
				.map((file) => path.join(outputDir, file))
				.sort();

			const swiftc = spawnSync("swiftc", ["-parse", ...sourceFiles], {
				encoding: "utf8",
			});

			expect(swiftc.status).toBe(0);
			expect(swiftc.stderr).toBe("");
		},
	);
});
