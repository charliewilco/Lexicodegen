import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import type { LexiconDoc } from "@atproto/lexicon";
import { Glob } from "bun";
import type { LexiconSource } from "./config";
import { loadLexicon } from "./utils";

function collectLocalPath(
	sourcePath: string,
	options?: { recursive?: boolean },
): string[] {
	const pattern =
		options?.recursive === false
			? `${sourcePath}/*.json`
			: `${sourcePath}/**/*.json`;

	return [...new Glob(pattern).scanSync()];
}

async function collectFromDirectory(
	sourcePath: string,
	recursive = true,
): Promise<LexiconDoc[]> {
	const entries = collectLocalPath(sourcePath, { recursive });
	if (entries.length === 0) {
		return [];
	}

	const docs = await Promise.all(entries.map((entry) => loadLexicon(entry)));
	return docs;
}

async function collectFromHttp(url: string): Promise<LexiconDoc[]> {
	const response = await fetch(url);

	if (!response.ok) {
		throw new Error(`Failed to load ${url}: ${response.status}`);
	}

	const contentType = response.headers.get("content-type") ?? "";
	const body = await response.text();

	if (!contentType.includes("json") && contentType === "") {
		throw new Error(
			`Expected JSON response from ${url} but got ${contentType}`,
		);
	}

	const parsed = JSON.parse(body) as LexiconDoc | LexiconDoc[];
	return Array.isArray(parsed) ? parsed : [parsed];
}

async function collectFromGitArchive(source: {
	kind: "git-archive";
	url: string;
	stripPath?: string;
	branch?: string;
}): Promise<LexiconDoc[]> {
	const archive = await fs.mkdtemp(path.join(os.tmpdir(), "lexicon-src-"));
	const archivePath = path.join(archive, "archive.tar.gz");

	try {
		const response = await fetch(source.url);
		if (!response.ok) {
			throw new Error(`Failed to load git archive ${source.url}`);
		}

		const bytes = Buffer.from(await response.arrayBuffer());
		await fs.writeFile(archivePath, bytes);

		const extractionRoot = path.join(archive, "extracted");
		await fs.mkdir(extractionRoot, { recursive: true });
		const { $ } = await import("bun");
		await $`tar -xzf ${archivePath} -C ${extractionRoot}`;

		const scanRoot = source.stripPath
			? path.join(extractionRoot, source.stripPath)
			: extractionRoot;
		const entries = collectLocalPath(scanRoot);
		if (entries.length === 0) {
			return [];
		}

		return await Promise.all(entries.map((entry) => loadLexicon(entry)));
	} finally {
		await fs.rm(archive, { recursive: true, force: true });
	}
}

function collectFromUnknownSource(
	source: LexiconSource,
): Promise<LexiconDoc[]> {
	if (source.kind === "local") {
		return collectFromDirectory(source.path, source.recursive !== false);
	}

	if (source.kind === "http") {
		return collectFromHttp(source.url);
	}

	return collectFromGitArchive(source);
}

export async function loadLexiconsFromSources(
	sources: LexiconSource[],
): Promise<LexiconDoc[]> {
	const docs = await Promise.all(
		sources.map(async (source) => {
			try {
				return await collectFromUnknownSource(source);
			} catch (error) {
				if (error instanceof Error) {
					throw new Error(
						`Failed to load source ${source.kind}: ${error.message}`,
					);
				}

				throw new Error(`Failed to load source ${source.kind}`);
			}
		}),
	);

	return docs.flat();
}
