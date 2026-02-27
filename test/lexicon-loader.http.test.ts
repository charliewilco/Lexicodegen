import { expect, test } from "bun:test";
import { loadLexiconsFromSources } from "../lib/lexicon-loader";

function withMockedFetch(
	handler: (_input: RequestInfo | URL, _init?: RequestInit) => Response,
) {
	const original = globalThis.fetch;

	beforeEach(() => {
		globalThis.fetch = ((
			input: RequestInfo | URL,
			init?: RequestInit,
		) => Promise.resolve(handler(input, init))) as typeof fetch;
	});

	afterEach(() => {
		globalThis.fetch = original;
	});
}

withMockedFetch((input) => {
	const url = String(input);
	if (url === "https://example.com/lexicons-array.json") {
		return new Response(
			JSON.stringify([
				{ id: "app.bsky.feed.post", lexicon: 1 },
				{ id: "app.bsky.actor.profile", lexicon: 1 },
			]),
			{
				status: 200,
				headers: {
					"content-type": "application/json",
				},
			},
		);
	}

	if (url === "https://example.com/not-found.json") {
		return new Response("missing", { status: 404 });
	}

	if (url === "https://example.com/non-json") {
		return new Response("not-json", {
			status: 200,
			headers: {
				"content-type": "",
			},
		});
	}

	throw new Error(`unexpected URL: ${url}`);
});

test("loads lexicons from HTTP source and parses array payloads", async () => {
	const docs = await loadLexiconsFromSources([
		{ kind: "http", url: "https://example.com/lexicons-array.json" },
	]);

	expect(docs).toHaveLength(2);
	expect(docs.map((doc) => doc.id)).toEqual([
		"app.bsky.feed.post",
		"app.bsky.actor.profile",
	]);
});

test("throws with a wrapped error for failed HTTP source responses", async () => {
	await expect(async () => {
		await loadLexiconsFromSources([
			{ kind: "http", url: "https://example.com/not-found.json" },
		]);
	}).rejects.toThrow(
		"Failed to load source http: Failed to load https://example.com/not-found.json",
	);
});

test("throws with a wrapped error for non-json payloads", async () => {
	await expect(async () => {
		await loadLexiconsFromSources([
			{ kind: "http", url: "https://example.com/non-json" },
		]);
	}).rejects.toThrow(
		"Failed to load source http: Expected JSON response from https://example.com/non-json but got ",
	);
});
