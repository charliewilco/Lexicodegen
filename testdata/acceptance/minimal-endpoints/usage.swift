import Foundation

func smokeMinimalEndpoints(client: ATProtoClient) async throws {
	let post = AppBskyFeedDefsPostView(
		cid: CID(rawValue: "bafyreihash"),
		createdAt: ATProtocolDate(rawValue: "2026-05-24T00:00:00Z"),
		text: "hello",
		uri: ATURI(rawValue: "at://did:plc:example/app.bsky.feed.post/3k")
	)
	let output = AppBskyFeedGetTimelineOutput(feed: [post])
	let params = AppBskyFeedGetTimelineParameters(
		actor: ATIdentifier(rawValue: "did:plc:example"),
		limit: 10
	)
	let input = AppBskyFeedCreatePostInput(text: "hello")

	_ = output
	_ = params.asQueryItems()
	_ = input
	_ = AppBskyFeedGetTimelineError.notFound
	_ = AppBskyFeedCreatePostError.invalidRequest
	_ = try await client.app.bsky.feed.getTimeline(input: params)
	_ = try await client.app.bsky.feed.createPost(input: input)
}
