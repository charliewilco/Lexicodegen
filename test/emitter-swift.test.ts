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

async function loadPhase3RegressionDocs() {
	return Promise.all([
		loadLexicon("lexicons/com/atproto/repo/applyWrites.json"),
		loadLexicon("lexicons/com/atproto/repo/defs.json"),
		loadLexicon("lexicons/com/atproto/repo/uploadBlob.json"),
		loadLexicon("lexicons/com/atproto/repo/importRepo.json"),
		loadLexicon("lexicons/com/atproto/sync/subscribeRepos.json"),
		loadLexicon("lexicons/com/atproto/sync/getRepo.json"),
		loadLexicon("lexicons/com/atproto/sync/getRecord.json"),
		loadLexicon("lexicons/com/atproto/sync/getBlocks.json"),
		loadLexicon("lexicons/com/atproto/sync/getCheckout.json"),
		loadLexicon("lexicons/com/atproto/sync/getBlob.json"),
		loadLexicon("lexicons/com/atproto/identity/resolveIdentity.json"),
		loadLexicon("lexicons/com/atproto/identity/defs.json"),
		loadLexicon("lexicons/app/bsky/graph/list.json"),
		loadLexicon("lexicons/app/bsky/graph/defs.json"),
		loadLexicon("lexicons/app/bsky/authViewAll.json"),
		loadLexicon("lexicons/app/bsky/video/uploadVideo.json"),
		loadLexicon("lexicons/app/bsky/embed/record.json"),
		loadLexicon("lexicons/app/bsky/notification/listNotifications.json"),
		loadLexicon("lexicons/com/atproto/label/defs.json"),
		loadLexicon("lexicons/app/bsky/richtext/facet.json"),
		loadLexicon("lexicons/chat/bsky/actor/exportAccountData.json"),
		loadLexicon("lexicons/tools/ozone/moderation/defs.json"),
		loadLexicon("lexicons/tools/ozone/setting/defs.json"),
		loadLexicon("lexicons/tools/ozone/setting/upsertOption.json"),
	]);
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
		expect(runtime).toContain("public struct XRPCResponse");
		expect(runtime).toContain("public struct EmptyResponse");
		expect(runtime).toContain("public enum XRPCSubscriptionEvent");
		expect(runtime).toContain("public func requestJSON<T: Decodable>(");
		expect(runtime).toContain("public func requestData(");
		expect(runtime).toContain("public final class ATProtoClient");

		expect(grouped).toContain("public struct AppBskyFeedDefsPostView");
		expect(grouped).not.toContain(
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
		expect(endpoints).toContain('client.requestJSON(method: "GET"');
		expect(endpoints).toContain(
			'headers: ["Content-Type": "application/json"]',
		);
	});

	test("handles real lexicon regressions for unions, records, subscriptions, binary input, and errors", async () => {
		const docs = await loadPhase3RegressionDocs();

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
		const appFile = await fs.readFile(
			path.join(outputDir, "AppBskyAuthViewAll.generated.swift"),
			"utf8",
		);
		const embedFile = await fs.readFile(
			path.join(outputDir, "AppBskyEmbed.generated.swift"),
			"utf8",
		);
		const notificationFile = await fs.readFile(
			path.join(outputDir, "AppBskyNotification.generated.swift"),
			"utf8",
		);
		const identityFile = await fs.readFile(
			path.join(outputDir, "ComAtprotoIdentity.generated.swift"),
			"utf8",
		);
		const ozoneModerationFile = await fs.readFile(
			path.join(outputDir, "ToolsOzoneModeration.generated.swift"),
			"utf8",
		);
		const ozoneSettingFile = await fs.readFile(
			path.join(outputDir, "ToolsOzoneSetting.generated.swift"),
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
			'public init(data: Data, contentType: String = "*/*")',
		);
		expect(repoFile).toContain(
			'public init(data: Data, contentType: String = "application/vnd.ipld.car")',
		);
		expect(repoFile).toContain("public enum ComAtprotoRepoApplyWritesError");
		expect(repoFile).toContain(
			"public enum ComAtprotoRepoApplyWritesCreateResultValidationStatus",
		);
		expect(repoFile).not.toContain(
			"public enum ComAtprotoRepoApplyWritesUpdateResultValidationStatus",
		);
		expect(repoFile).toContain(
			"public let validationStatus: ComAtprotoRepoApplyWritesCreateResultValidationStatus?",
		);
		expect(repoFile).toContain(
			"public struct ComAtprotoRepoApplyWritesDeleteResult",
		);

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
		expect(syncFile).toContain("public enum ComAtprotoSyncGetRepoError");
		expect(syncFile).toContain("public enum ComAtprotoSyncGetBlobError");
		expect(syncFile).toContain("public enum ComAtprotoSyncGetRecordError");
		expect(syncFile).toContain("public enum ComAtprotoSyncGetBlocksError");

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
		expect(identityFile).toContain(
			"public init?(transportError: XRPCTransportError)",
		);

		expect(appFile).toContain("public struct AppBskyAuthViewAllMethod");
		expect(appFile).toContain("public struct AppBskyAuthViewAll");
		expect(appFile).toContain(
			'public static let title: String? = "Read-only access to all content"',
		);
		expect(appFile).toContain("public static let appBskyActorGetProfile");
		expect(appFile).toContain(
			"public static let knownMethods: [AppBskyAuthViewAllMethod] = [",
		);
		expect(appFile).toContain(
			"public let grantedMethods: [AppBskyAuthViewAllMethod]",
		);
		expect(appFile).not.toContain(
			"public typealias AppBskyAuthViewAll = [String]",
		);
		expect(appFile).not.toContain(
			"public let grantedMethods: [ATProtocolValueContainer]",
		);

		expect(embedFile).toContain("public let record: ATProtocolValueContainer");
		expect(notificationFile).toContain(
			"public let record: ATProtocolValueContainer",
		);
		expect(ozoneModerationFile).toContain(
			"public let value: ATProtocolValueContainer",
		);
		expect(ozoneModerationFile).toContain(
			"public let meta: ATProtocolValueContainer?",
		);
		expect(ozoneSettingFile).toContain(
			"public let value: ATProtocolValueContainer",
		);

		expect(endpoints).toContain(
			"public func uploadBlob(input: ComAtprotoRepoUploadBlobInput) async throws -> ComAtprotoRepoUploadBlobOutput",
		);
		expect(endpoints).toContain('headers: ["Content-Type": input.contentType]');
		expect(endpoints).toContain(
			"public func importRepo(input: ComAtprotoRepoImportRepoInput) async throws -> EmptyResponse",
		);
		expect(endpoints).toContain(
			"public func uploadVideo(input: AppBskyVideoUploadVideoInput) async throws -> AppBskyVideoUploadVideoOutput",
		);
		expect(endpoints).toContain(
			"public func subscribeRepos(input: ComAtprotoSyncSubscribeReposParameters) -> AsyncThrowingStream<XRPCSubscriptionEvent<ComAtprotoSyncSubscribeReposMessage>, Error>",
		);
		expect(endpoints).toContain(
			"public func getRepo(input: ComAtprotoSyncGetRepoParameters) async throws -> Data",
		);
		expect(endpoints).toContain(
			"public func getRecord(input: ComAtprotoSyncGetRecordParameters) async throws -> Data",
		);
		expect(endpoints).toContain(
			"public func getBlocks(input: ComAtprotoSyncGetBlocksParameters) async throws -> Data",
		);
		expect(endpoints).toContain(
			"public func getCheckout(input: ComAtprotoSyncGetCheckoutParameters) async throws -> Data",
		);
		expect(endpoints).toContain(
			"public func getBlob(input: ComAtprotoSyncGetBlobParameters) async throws -> Data",
		);
		expect(endpoints).toContain(
			'client.requestData(method: "GET", path: "/xrpc/com.atproto.sync.getRepo", queryItems: input.asQueryItems(), responseKind: .car)',
		);
		expect(endpoints).toContain(
			'client.requestData(method: "GET", path: "/xrpc/com.atproto.sync.getRecord", queryItems: input.asQueryItems(), responseKind: .car)',
		);
		expect(endpoints).toContain(
			'client.requestData(method: "GET", path: "/xrpc/com.atproto.sync.getBlocks", queryItems: input.asQueryItems(), responseKind: .car)',
		);
		expect(endpoints).toContain(
			'client.requestData(method: "GET", path: "/xrpc/com.atproto.sync.getCheckout", queryItems: input.asQueryItems(), responseKind: .car)',
		);
		expect(endpoints).toContain(
			'client.requestData(method: "GET", path: "/xrpc/com.atproto.sync.getBlob", queryItems: input.asQueryItems(), responseKind: .binary)',
		);
		expect(endpoints).toContain(
			"public func exportAccountData() async throws -> Data",
		);
		expect(endpoints).toContain(
			'client.requestData(method: "GET", path: "/xrpc/chat.bsky.actor.exportAccountData", queryItems: [], responseKind: .jsonl)',
		);
		expect(endpoints).toContain(
			"if let typedError = ComAtprotoIdentityResolveIdentityError(transportError: error)",
		);
	});

	test("emits stable Swift output for the same lexicon set", async () => {
		const docs = await loadPhase3RegressionDocs();
		const ir = buildLexiconIR(docs, {
			allowPrefixes: [],
			denyPrefixes: [],
			denyUnspecced: false,
			denyDeprecated: false,
		});

		const leftDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-swift-stable-left-"),
		);
		const rightDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-swift-stable-right-"),
		);

		await emitSwiftFromIR(ir, leftDir);
		await emitSwiftFromIR(ir, rightDir);

		const leftFiles = (await fs.readdir(leftDir)).filter((file) =>
			file.endsWith(".swift"),
		);
		const rightFiles = (await fs.readdir(rightDir)).filter((file) =>
			file.endsWith(".swift"),
		);

		expect(leftFiles.sort()).toEqual(rightFiles.sort());

		for (const file of leftFiles) {
			expect(await fs.readFile(path.join(leftDir, file), "utf8")).toBe(
				await fs.readFile(path.join(rightDir, file), "utf8"),
			);
		}
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
		expect(safelinkModels).not.toContain(
			"public let action: ATProtocolValueContainer",
		);
	});

	test("emits params models and empty objects without widening to ATProtocolValueContainer", async () => {
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
					parametersSchema: {
						type: "params",
						required: ["subject"],
						properties: {
							subject: { type: "ref", ref: "com.example.defs#target" },
						},
					},
					errors: [],
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
			"public struct ComExampleDefsEmpty: Codable, Sendable, Equatable {",
		);
		expect(exampleDefs).not.toContain(
			"typealias ComExampleDefsEmpty = ATProtocolValueContainer",
		);

		const endpoints = await fs.readFile(
			path.join(outputDir, "Endpoints.swift"),
			"utf8",
		);
		expect(endpoints).toContain(
			"public func query(input: ComExampleQueryParameters) async throws -> EmptyResponse",
		);

		const queryModels = await fs.readFile(
			path.join(outputDir, "ComExampleQuery.generated.swift"),
			"utf8",
		);
		expect(queryModels).toContain("public let subject: ComExampleDefsTarget");
	});

	(hasSwiftCompiler() ? test : test.skip)(
		"generates compilable Swift output from real lexicons",
		async () => {
			const docs = await loadPhase3RegressionDocs();

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
