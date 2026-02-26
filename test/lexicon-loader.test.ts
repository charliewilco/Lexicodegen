import { expect, test } from "bun:test";
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { loadLexiconsFromSources } from "../lib/lexicon-loader";

test("loads local lexicons recursively by default", async () => {
	const sourceDir = await fs.mkdtemp(
		path.join(os.tmpdir(), "lexicodegen-loader-recursive-"),
	);
	const nestedDir = path.join(sourceDir, "nested");
	await fs.mkdir(nestedDir, { recursive: true });

	await fs.writeFile(
		path.join(sourceDir, "root.json"),
		JSON.stringify({ id: "app.root", lexicon: 1 }),
		"utf8",
	);
	await fs.writeFile(
		path.join(nestedDir, "nested.json"),
		JSON.stringify({ id: "app.nested", lexicon: 1 }),
		"utf8",
	);

	const docs = await loadLexiconsFromSources([
		{ kind: "local", path: sourceDir, recursive: true },
	]);

	expect(docs).toHaveLength(2);
});

test("respects non-recursive local scanning", async () => {
	const sourceDir = await fs.mkdtemp(
		path.join(os.tmpdir(), "lexicodegen-loader-top-"),
	);
	const nestedDir = path.join(sourceDir, "nested");
	await fs.mkdir(nestedDir, { recursive: true });

	await fs.writeFile(
		path.join(sourceDir, "root.json"),
		JSON.stringify({ id: "app.root", lexicon: 1 }),
		"utf8",
	);
	await fs.writeFile(
		path.join(nestedDir, "nested.json"),
		JSON.stringify({ id: "app.nested", lexicon: 1 }),
		"utf8",
	);

	const docs = await loadLexiconsFromSources([
		{ kind: "local", path: sourceDir, recursive: false },
	]);

	expect(docs).toHaveLength(1);
});
