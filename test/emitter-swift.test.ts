import { describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { emitSwiftFromIR } from "../lib/emitter/swift";
import type { IREndpoint, IRNamedType, LexiconIR } from "../lib/lexicon-ir";

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
		const outputDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-swift-out-"),
		);
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
			definitionIndex: new Map<string, IRNamedType>(
				namedTypes.map((namedType): [string, IRNamedType] => [
					namedType.fullName,
					namedType,
				]),
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

		expect(appBskyFeed).toContain("public struct AppBskyFeedPost: Codable");
		expect(appBskyFeed).toContain(
			"public enum AppBskyFeedStatus: String, Codable",
		);

		const endpoints = await fs.readFile(
			path.join(outputDir, "Endpoints.swift"),
			"utf8",
		);

		expect(endpoints).toContain(`let encodedBody = try encodedBody(input)`);
		expect(endpoints).toContain("public func appbskyfeedget(");
		expect(endpoints).toContain("public func appbskyfeedcreate(");
		expect(endpoints).toContain('path: "/xrpc/app.bsky.feed.get"');
		expect(endpoints).toContain('path: "/xrpc/app.bsky.feed.create"');
	});

	test("resolves relative refs from named defs against the lexicon id", async () => {
		const outputDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-swift-relative-ref-"),
		);

		const namedTypes: IRNamedType[] = [
			{
				id: "tools.ozone.safelink.defs",
				name: "event",
				fullName: "tools.ozone.safelink.defs.event",
				definition: {
					type: "object",
					required: ["action"],
					properties: {
						action: {
							type: "ref",
							ref: "#actionType",
						},
					},
				},
				source: "tools.ozone.safelink.defs",
				tag: "tools.ozone.safelink",
				type: "object",
			},
			{
				id: "tools.ozone.safelink.defs",
				name: "actionType",
				fullName: "tools.ozone.safelink.defs.actionType",
				definition: {
					type: "string",
					knownValues: ["block", "warn"],
				},
				source: "tools.ozone.safelink.defs",
				tag: "tools.ozone.safelink",
				type: "string",
			},
		];

		const ir: LexiconIR = {
			documents: [],
			namedTypes,
			endpoints: [],
			definitionIndex: new Map<string, IRNamedType>(
				namedTypes.map((namedType): [string, IRNamedType] => [
					namedType.fullName,
					namedType,
				]),
			),
		};

		await emitSwiftFromIR(ir, outputDir);

		const safelinkModels = await fs.readFile(
			path.join(outputDir, "ToolsOzoneSafelink.generated.swift"),
			"utf8",
		);

		expect(safelinkModels).toContain(
			"public let action: ToolsOzoneSafelinkDefsActionType",
		);
		expect(safelinkModels).not.toContain("public let action: ATProtocolAny");
	});

	test("emits concrete inline union and permission-set models instead of ATProtocolAny aliases", async () => {
		const outputDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-swift-specific-"),
		);

		const namedTypes: IRNamedType[] = [
			{
				id: "app.bsky.embed.images",
				name: "main",
				fullName: "app.bsky.embed.images",
				definition: {
					type: "object",
					required: ["images"],
					properties: {
						images: {
							type: "array",
							items: { type: "string" },
						},
					},
				},
				source: "app.bsky.embed",
				tag: "app.bsky.embed",
				type: "object",
			},
			{
				id: "app.bsky.embed.external",
				name: "main",
				fullName: "app.bsky.embed.external",
				definition: {
					type: "object",
					required: ["uri"],
					properties: {
						uri: { type: "string" },
					},
				},
				source: "app.bsky.embed",
				tag: "app.bsky.embed",
				type: "object",
			},
			{
				id: "app.bsky.feed.post",
				name: "main",
				fullName: "app.bsky.feed.post",
				definition: {
					type: "record",
					record: {
						type: "object",
						required: ["createdAt"],
						properties: {
							embed: {
								type: "union",
								refs: ["app.bsky.embed.images", "app.bsky.embed.external"],
							},
							createdAt: { type: "string" },
						},
					},
				},
				source: "app.bsky.feed",
				tag: "app.bsky.feed",
				type: "record",
			},
			{
				id: "app.bsky.authViewAll",
				name: "main",
				fullName: "app.bsky.authViewAll",
				definition: {
					type: "permission-set",
				},
				source: "app.bsky.authViewAll",
				tag: "app.bsky.authViewAll",
				type: "permission-set",
			},
		];

		const ir: LexiconIR = {
			documents: [],
			namedTypes,
			endpoints: [],
			definitionIndex: new Map<string, IRNamedType>(
				namedTypes.map((namedType): [string, IRNamedType] => [
					namedType.fullName,
					namedType,
				]),
			),
		};

		await emitSwiftFromIR(ir, outputDir);

		const feedModels = await fs.readFile(
			path.join(outputDir, "AppBskyFeed.generated.swift"),
			"utf8",
		);
		expect(feedModels).toContain("public enum AppBskyFeedPostEmbed: Codable");
		expect(feedModels).toContain("public let embed: AppBskyFeedPostEmbed?");
		expect(feedModels).toContain("case option0(AppBskyEmbedImages)");
		expect(feedModels).toContain("case option1(AppBskyEmbedExternal)");

		const authModels = await fs.readFile(
			path.join(outputDir, "AppBskyAuthViewAll.generated.swift"),
			"utf8",
		);
		expect(authModels).toContain("public struct AppBskyAuthViewAll: Codable");
		expect(authModels).toContain(
			"public let permissions: [AppBskyAuthViewAllPermission]",
		);
		expect(authModels).not.toContain(
			"typealias AppBskyAuthViewAll = ATProtocolAny",
		);

		const runtime = await fs.readFile(
			path.join(outputDir, "Models.swift"),
			"utf8",
		);
		expect(runtime).toContain("public enum ATProtocolPermissionValue: Codable");
	});

	test("emits params models and empty objects without widening to ATProtocolAny", async () => {
		const outputDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-swift-params-"),
		);

		const namedTypes: IRNamedType[] = [
			{
				id: "com.example.defs",
				name: "target",
				fullName: "com.example.defs.target",
				definition: {
					type: "object",
					required: ["id"],
					properties: {
						id: { type: "string" },
					},
				},
				source: "com.example.defs",
				tag: "com.example.defs",
				type: "object",
			},
			{
				id: "com.example.defs",
				name: "empty",
				fullName: "com.example.defs.empty",
				definition: {
					type: "object",
					properties: {},
				},
				source: "com.example.defs",
				tag: "com.example.defs",
				type: "object",
			},
		];

		const ir: LexiconIR = {
			documents: [],
			namedTypes,
			endpoints: [
				{
					id: "com.example.query",
					name: "main",
					fullName: "com.example.query",
					definition: {
						type: "query",
						parameters: {
							type: "params",
							required: ["subject"],
							properties: {
								subject: { type: "ref", ref: "com.example.defs#target" },
							},
						},
					},
					method: "query",
					source: "com.example.query",
					tag: "com.example.query",
					path: "/xrpc/com.example.query",
				},
			],
			definitionIndex: new Map<string, IRNamedType>(
				namedTypes.map((namedType): [string, IRNamedType] => [
					namedType.fullName,
					namedType,
				]),
			),
		};

		await emitSwiftFromIR(ir, outputDir);

		const exampleDefs = await fs.readFile(
			path.join(outputDir, "ComExampleDefs.generated.swift"),
			"utf8",
		);
		expect(exampleDefs).toContain(
			"public struct ComExampleDefsEmpty: Codable {}",
		);
		expect(exampleDefs).not.toContain(
			"typealias ComExampleDefsEmpty = [String: ATProtocolAny]",
		);

		const endpoints = await fs.readFile(
			path.join(outputDir, "Endpoints.swift"),
			"utf8",
		);
		expect(endpoints).toContain("input: ComExampleQueryParameters? = nil");

		const queryModels = await fs.readFile(
			path.join(outputDir, "ComExampleQuery.generated.swift"),
			"utf8",
		);
		expect(queryModels).toContain("public let subject: ComExampleDefsTarget");
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
							embed: {
								type: "union",
								refs: ["app.bsky.feed.image", "app.bsky.feed.link"],
							},
						},
						required: ["title"],
					},
					source: "app.bsky.feed",
					tag: "app.bsky.feed",
					type: "object",
				},
				{
					id: "app.bsky.feed",
					name: "image",
					fullName: "app.bsky.feed.image",
					definition: {
						type: "object",
						required: ["url"],
						properties: {
							url: { type: "string" },
						},
					},
					source: "app.bsky.feed",
					tag: "app.bsky.feed",
					type: "object",
				},
				{
					id: "app.bsky.feed",
					name: "link",
					fullName: "app.bsky.feed.link",
					definition: {
						type: "object",
						required: ["href"],
						properties: {
							href: { type: "string" },
						},
					},
					source: "app.bsky.feed",
					tag: "app.bsky.feed",
					type: "object",
				},
				{
					id: "app.bsky.authViewAll",
					name: "main",
					fullName: "app.bsky.authViewAll",
					definition: {
						type: "permission-set",
					},
					source: "app.bsky.authViewAll",
					tag: "app.bsky.authViewAll",
					type: "permission-set",
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
				definitionIndex: new Map(
					irNamedTypes.map((namedType): [string, IRNamedType] => [
						namedType.fullName,
						namedType,
					]),
				),
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
