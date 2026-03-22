import { describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { emitSwiftFromIR } from "../lib/emitter/swift";
import {
	buildLexiconIR,
	type IREndpoint,
	type IRNamedType,
	type LexiconIR,
} from "../lib/lexicon-ir";
import { loadLexicon } from "../lib/utils";

function hasSwiftCompiler(): boolean {
	const check = spawnSync("swiftc", ["-version"], {
		encoding: "utf8",
	});
	return check.status === 0;
}

function basicEndpoint(
	fullName: string,
	method: "query" | "procedure",
): IREndpoint {
	return {
		id: fullName,
		name: "main",
		fullName,
		definition:
			method === "query"
				? {
						type: "query",
						parameters: {
							type: "params",
							required: ["actor"],
							properties: {
								actor: { type: "string", format: "at-identifier" },
								limit: { type: "integer" },
							},
						},
						output: {
							encoding: "application/json",
							schema: { type: "ref", ref: "app.bsky.feed.defs#postView" },
						},
						errors: [{ name: "NotFound" }],
					}
				: {
						type: "procedure",
						input: {
							encoding: "application/json",
							schema: {
								type: "object",
								required: ["text"],
								properties: {
									text: { type: "string" },
								},
							},
						},
						output: {
							encoding: "application/json",
							schema: { type: "ref", ref: "app.bsky.feed.defs#postView" },
						},
					},
		method,
		source: "app.bsky.feed",
		tag: "app.bsky.feed",
		path: `/xrpc/${fullName}`,
		parametersSchema:
			method === "query"
				? {
						type: "params",
						required: ["actor"],
						properties: {
							actor: { type: "string", format: "at-identifier" },
							limit: { type: "integer" },
						},
					}
				: undefined,
		inputSchema:
			method === "procedure"
				? {
						type: "object",
						required: ["text"],
						properties: {
							text: { type: "string" },
						},
					}
				: undefined,
		inputEncoding: method === "procedure" ? "application/json" : undefined,
		outputSchema: { type: "ref", ref: "app.bsky.feed.defs#postView" },
		outputEncoding: "application/json",
		messageSchema: undefined,
		errors: method === "query" ? [{ name: "NotFound" }] : [],
	};
}

describe("emitSwiftFromIR", () => {
	test("writes typed runtime, grouped models, and namespaced endpoints", async () => {
		const outputDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-swift-basic-"),
		);

		const namedTypes: IRNamedType[] = [
			{
				id: "app.bsky.feed.defs",
				name: "postView",
				fullName: "app.bsky.feed.defs.postView",
				definition: {
					type: "object",
					required: ["uri", "cid", "createdAt"],
					properties: {
						uri: { type: "string", format: "at-uri" },
						cid: { type: "string", format: "cid" },
						createdAt: { type: "string", format: "datetime" },
					},
				},
				source: "app.bsky.feed.defs",
				tag: "app.bsky.feed",
				type: "object",
			},
		];

		const ir: LexiconIR = {
			documents: [],
			namedTypes,
			endpoints: [
				basicEndpoint("app.bsky.feed.getTimeline", "query"),
				basicEndpoint("app.bsky.feed.createPost", "procedure"),
			],
			definitionIndex: new Map(
				namedTypes.map((namedType): [string, IRNamedType] => [
					namedType.fullName,
					namedType,
				]),
			),
		};

		await emitSwiftFromIR(ir, outputDir);

		const runtime = await fs.readFile(
			path.join(outputDir, "Models.swift"),
			"utf8",
		);
		const grouped = await fs.readFile(
			path.join(outputDir, "AppBskyFeed.generated.swift"),
			"utf8",
		);
		const endpoints = await fs.readFile(
			path.join(outputDir, "Endpoints.swift"),
			"utf8",
		);

		expect(runtime).toContain("public protocol QueryParameterValue");
		expect(runtime).toContain("public struct CID: RawRepresentable");
		expect(runtime).toContain("public struct ATProtocolDate: RawRepresentable");
		expect(runtime).toContain("public final class ATProtoClient");

		expect(grouped).toContain("public struct AppBskyFeedDefsPostView");
		expect(grouped).toContain(
			'public static let typeIdentifier = "app.bsky.feed.defs#postView"',
		);
		expect(grouped).toContain("public struct AppBskyFeedGetTimelineParameters");
		expect(grouped).toContain("public enum AppBskyFeedGetTimelineError");
		expect(grouped).toContain("public struct AppBskyFeedCreatePostInput");

		expect(endpoints).toContain("\tvar app: AppNamespace {");
		expect(endpoints).toContain("\tpublic var bsky: AppBskyNamespace {");
		expect(endpoints).toContain("\tpublic var feed: AppBskyFeedNamespace {");
		expect(endpoints).toContain(
			"public func getTimeline(input: AppBskyFeedGetTimelineParameters) async throws -> AppBskyFeedGetTimelineOutput",
		);
		expect(endpoints).toContain("queryItems: input.asQueryItems()");
		expect(endpoints).toContain(
			'headers: ["Content-Type": "application/json"]',
		);
	});

	test("handles real lexicon regressions for unions, records, subscriptions, binary input, and errors", async () => {
		const docs = await Promise.all([
			loadLexicon("lexicons/com/atproto/repo/applyWrites.json"),
			loadLexicon("lexicons/com/atproto/repo/defs.json"),
			loadLexicon("lexicons/com/atproto/repo/uploadBlob.json"),
			loadLexicon("lexicons/com/atproto/sync/subscribeRepos.json"),
			loadLexicon("lexicons/com/atproto/identity/resolveIdentity.json"),
			loadLexicon("lexicons/com/atproto/identity/defs.json"),
			loadLexicon("lexicons/app/bsky/graph/list.json"),
			loadLexicon("lexicons/app/bsky/graph/defs.json"),
			loadLexicon("lexicons/com/atproto/label/defs.json"),
			loadLexicon("lexicons/app/bsky/richtext/facet.json"),
		]);

		const ir = buildLexiconIR(docs, {
			allowPrefixes: [],
			denyPrefixes: [],
			denyUnspecced: false,
			denyDeprecated: false,
		});

		const outputDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-swift-regressions-"),
		);
		await emitSwiftFromIR(ir, outputDir);

		const repoFile = await fs.readFile(
			path.join(outputDir, "ComAtprotoRepo.generated.swift"),
			"utf8",
		);
		const syncFile = await fs.readFile(
			path.join(outputDir, "ComAtprotoSync.generated.swift"),
			"utf8",
		);
		const graphFile = await fs.readFile(
			path.join(outputDir, "AppBskyGraph.generated.swift"),
			"utf8",
		);
		const identityFile = await fs.readFile(
			path.join(outputDir, "ComAtprotoIdentity.generated.swift"),
			"utf8",
		);
		const endpoints = await fs.readFile(
			path.join(outputDir, "Endpoints.swift"),
			"utf8",
		);

		expect(repoFile).toContain(
			"public enum ComAtprotoRepoApplyWritesInputWritesItem",
		);
		expect(repoFile).toContain("case create(ComAtprotoRepoApplyWritesCreate)");
		expect(repoFile).toContain(
			"case updateResult(ComAtprotoRepoApplyWritesUpdateResult)",
		);
		expect(repoFile).toContain(
			"public struct ComAtprotoRepoUploadBlobInput: Sendable, Equatable",
		);
		expect(repoFile).toContain(
			'public init(data: Data, contentType: String = "application/octet-stream")',
		);
		expect(repoFile).toContain("public enum ComAtprotoRepoApplyWritesError");

		expect(syncFile).toContain(
			"public enum ComAtprotoSyncSubscribeReposMessage",
		);
		expect(syncFile).toContain(
			"case commit(ComAtprotoSyncSubscribeReposCommit)",
		);
		expect(syncFile).toContain(
			"public struct ComAtprotoSyncSubscribeReposParameters",
		);
		expect(syncFile).toContain("public let blocks: Bytes");
		expect(syncFile).toContain("public let commit: CID");

		expect(graphFile).toContain(
			'public static let typeIdentifier = "app.bsky.graph.list"',
		);
		expect(graphFile).toContain("public let avatar: Blob?");
		expect(graphFile).toContain("public enum AppBskyGraphListLabels");
		expect(graphFile).toContain(
			"case selfLabels(ComAtprotoLabelDefsSelfLabels)",
		);

		expect(identityFile).toContain(
			"public enum ComAtprotoIdentityResolveIdentityError",
		);
		expect(identityFile).toContain(
			"public struct ComAtprotoIdentityResolveIdentityParameters",
		);
		expect(identityFile).toContain("public let identifier: ATIdentifier");
		expect(identityFile).toContain(
			"public let didDoc: ATProtocolValueContainer",
		);

		expect(endpoints).toContain(
			"public func uploadBlob(input: ComAtprotoRepoUploadBlobInput) async throws -> ComAtprotoRepoUploadBlobOutput",
		);
		expect(endpoints).toContain('headers: ["Content-Type": input.contentType]');
		expect(endpoints).toContain(
			"public func subscribeRepos(input: ComAtprotoSyncSubscribeReposParameters) -> AsyncThrowingStream<ComAtprotoSyncSubscribeReposMessage, Error>",
		);
	});

	(hasSwiftCompiler() ? test : test.skip)(
		"generates compilable Swift output from real lexicons",
		async () => {
			const docs = await Promise.all([
				loadLexicon("lexicons/com/atproto/repo/applyWrites.json"),
				loadLexicon("lexicons/com/atproto/repo/defs.json"),
				loadLexicon("lexicons/com/atproto/repo/uploadBlob.json"),
				loadLexicon("lexicons/com/atproto/sync/subscribeRepos.json"),
				loadLexicon("lexicons/com/atproto/identity/resolveIdentity.json"),
				loadLexicon("lexicons/com/atproto/identity/defs.json"),
				loadLexicon("lexicons/app/bsky/graph/list.json"),
				loadLexicon("lexicons/app/bsky/graph/defs.json"),
				loadLexicon("lexicons/com/atproto/label/defs.json"),
				loadLexicon("lexicons/app/bsky/richtext/facet.json"),
			]);

			const ir = buildLexiconIR(docs, {
				allowPrefixes: [],
				denyPrefixes: [],
				denyUnspecced: false,
				denyDeprecated: false,
			});

			const outputDir = await fs.mkdtemp(
				path.join(os.tmpdir(), "lexicodegen-swift-compile-"),
			);
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
