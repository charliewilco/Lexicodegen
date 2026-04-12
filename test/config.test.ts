import { describe, expect, test } from "bun:test";
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { loadGeneratorConfig } from "../lib/config";

describe("loadGeneratorConfig", () => {
	test("loads JSON config file", async () => {
		const configDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-json-config-"),
		);
		const configPath = path.join(configDir, "config.json");
		const localSource = path.join(configDir, "lexicons");
		await fs.mkdir(localSource, { recursive: true });

		await fs.writeFile(
			configPath,
			JSON.stringify({
				sources: [
					{
						kind: "local",
						path: localSource,
						recursive: true,
					},
				],
				filters: {
					allowPrefixes: ["app.bsky"],
					denyPrefixes: ["com.atproto.lexicon.resolveLexicon"],
					denyUnspecced: true,
					denyDeprecated: true,
				},
				targets: ["swift"],
				output: {
					swiftOutDir: "./output/custom",
					swiftFilePrefix: "ATProto_",
				},
			}),
			"utf8",
		);

		const config = await loadGeneratorConfig(["--config", configPath]);

		expect(config.sources).toEqual([
			{
				kind: "local",
				path: localSource,
				recursive: true,
			},
		]);

		expect(config.filters.allowPrefixes).toEqual(["app.bsky"]);
		expect(config.filters.denyPrefixes).toEqual([
			"com.atproto.lexicon.resolveLexicon",
		]);
		expect(config.filters.denyUnspecced).toBeTrue();
		expect(config.filters.denyDeprecated).toBeTrue();
		expect(config.targets).toEqual(["swift"]);
		expect(config.output.swiftOutDir).toBe(
			path.resolve(process.cwd(), "./output/custom"),
		);
		expect(config.output.swiftFilePrefix).toBe("ATProto_");
	});

	test("loads TOML config and applies CLI overrides", async () => {
		const configDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-toml-config-"),
		);
		const configPath = path.join(configDir, "config.toml");
		const localSource = path.join(configDir, "lexicons");
		await fs.mkdir(localSource, { recursive: true });

		const toml = [
			"[[sources]]",
			`kind = "local"`,
			`path = "${localSource}"`,
			"recursive = true",
			"",
			"[filters]",
			'allowPrefixes = ["app.bsky", "frontpage"]',
			"denyPrefixes = []",
			"denyUnspecced = false",
			"denyDeprecated = false",
			"",
			'targets = ["swift"]',
			"",
			"[output]",
			'swiftOutDir = "./output/toml"',
			'swiftFilePrefix = "Generated_"',
		].join("\n");

		await fs.writeFile(configPath, toml, "utf8");

		const config = await loadGeneratorConfig([
			"--config",
			configPath,
			"--output",
			"./cli-output",
		]);

		expect(config.filters.allowPrefixes).toEqual(["app.bsky", "frontpage"]);
		expect(config.output.swiftOutDir).toBe(
			path.resolve(process.cwd(), "./cli-output"),
		);
		expect(config.output.swiftFilePrefix).toBe("Generated_");
		expect(config.sources).toEqual([
			{
				kind: "local",
				path: localSource,
				recursive: true,
			},
		]);
	});

	test("uses positional args and explicit --source together", async () => {
		const repoRoot = process.cwd();
		const config = await loadGeneratorConfig([
			"./lexicons",
			"https://example.com/some/collection",
			"--source",
			"./frontpage-lexicons",
			"--output",
			"./output/merged",
			"--targets",
			"swift",
			"--deny-prefix",
			"com.atproto.lexicon.resolveLexicon",
			"--deny-unspecced",
		]);

		expect(config.sources).toEqual([
			{ kind: "local", path: path.join(repoRoot, "frontpage-lexicons") },
			{ kind: "local", path: path.join(repoRoot, "lexicons") },
			{ kind: "http", url: "https://example.com/some/collection" },
		]);
		expect(config.output.swiftOutDir).toBe(
			path.resolve(repoRoot, "./output/merged"),
		);
		expect(config.output.swiftFilePrefix).toBe("");
		expect(config.filters.denyPrefixes).toEqual([
			"com.atproto.lexicon.resolveLexicon",
		]);
		expect(config.filters.denyUnspecced).toBeTrue();
		expect(config.targets).toEqual(["swift"]);
	});

	test("rejects swift file prefixes that contain path separators", async () => {
		const configDir = await fs.mkdtemp(
			path.join(os.tmpdir(), "lexicodegen-invalid-prefix-config-"),
		);
		const configPath = path.join(configDir, "config.json");

		await fs.writeFile(
			configPath,
			JSON.stringify({
				output: {
					swiftFilePrefix: "../generated-",
				},
			}),
			"utf8",
		);

		await expect(loadGeneratorConfig(["--config", configPath])).rejects.toThrow(
			"output.swiftFilePrefix cannot contain path separators",
		);
	});
});
