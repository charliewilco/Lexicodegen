import { afterEach, describe, expect, test } from "bun:test";
import {
	calculateTag,
	checkEndpoint,
	Endpoint,
	isDeprecatedDefinition,
	isEmptyObject,
	isGlobPattern,
} from "../lib/utils";

describe("utility helpers", () => {
	test("calculates a tag from lexicon identifier", () => {
		expect(calculateTag("app.bsky.feed.post")).toBe("app.bsky.feed");
		expect(calculateTag("com.atproto.admin.reputation")).toBe(
			"com.atproto.admin",
		);
		expect(calculateTag("single")).toBe("single");
	});

	test("detects glob patterns and empty objects", () => {
		expect(isGlobPattern("path/*.json")).toBeTrue();
		expect(isGlobPattern("path/[a-z].json")).toBeTrue();
		expect(isGlobPattern("path/plain.json")).toBeFalse();

		expect(isEmptyObject({})).toBeTrue();
		expect(isEmptyObject({ a: 1 })).toBeFalse();
	});

	test("detects deprecated definitions", () => {
		expect(isDeprecatedDefinition("Deprecated: this is old")).toBeTrue();
		expect(isDeprecatedDefinition("deprecated - do not use")).toBeTrue();
		expect(isDeprecatedDefinition("  DEPRECATED now")).toBeTrue();
		expect(isDeprecatedDefinition("valid description")).toBeFalse();
		expect(isDeprecatedDefinition(undefined)).toBeFalse();
	});
});

describe("checkEndpoint", () => {
	const originalFetch = globalThis.fetch;

	const mocked = (_path: string, status: number) =>
		new Response(null, {
			status,
		});

	afterEach(() => {
		globalThis.fetch = originalFetch;
	});

	test("maps status codes to Endpoint enum values", async () => {
		globalThis.fetch = (async (input) => {
			const request =
				input instanceof Request ? input : new Request(String(input));
			if (request.url.endsWith("/xrpc/exists")) {
				return mocked(request.url, 200);
			}
			if (request.url.endsWith("/xrpc/unauthorized")) {
				return mocked(request.url, 401);
			}
			return mocked(request.url, 404);
		}) as typeof fetch;

		expect(await checkEndpoint("exists")).toBe(Endpoint.Public);
		expect(await checkEndpoint("unauthorized")).toBe(
			Endpoint.NeedsAuthentication,
		);
		expect(await checkEndpoint("missing")).toBe(Endpoint.DoesNotExist);
	});
});
