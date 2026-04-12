import Foundation

public extension ATProtoClient {
	var app: AppNamespace {
		AppNamespace(client: self)
	}
	var chat: ChatNamespace {
		ChatNamespace(client: self)
	}
	var com: ComNamespace {
		ComNamespace(client: self)
	}
	var tools: ToolsNamespace {
		ToolsNamespace(client: self)
	}
}

public struct AppNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public var bsky: AppBskyNamespace {
		AppBskyNamespace(client: client)
	}
}

public struct AppBskyNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public var actor: AppBskyActorNamespace {
		AppBskyActorNamespace(client: client)
	}

	public var ageassurance: AppBskyAgeassuranceNamespace {
		AppBskyAgeassuranceNamespace(client: client)
	}

	public var bookmark: AppBskyBookmarkNamespace {
		AppBskyBookmarkNamespace(client: client)
	}

	public var contact: AppBskyContactNamespace {
		AppBskyContactNamespace(client: client)
	}

	public var draft: AppBskyDraftNamespace {
		AppBskyDraftNamespace(client: client)
	}

	public var feed: AppBskyFeedNamespace {
		AppBskyFeedNamespace(client: client)
	}

	public var graph: AppBskyGraphNamespace {
		AppBskyGraphNamespace(client: client)
	}

	public var labeler: AppBskyLabelerNamespace {
		AppBskyLabelerNamespace(client: client)
	}

	public var notification: AppBskyNotificationNamespace {
		AppBskyNotificationNamespace(client: client)
	}

	public var unspecced: AppBskyUnspeccedNamespace {
		AppBskyUnspeccedNamespace(client: client)
	}

	public var video: AppBskyVideoNamespace {
		AppBskyVideoNamespace(client: client)
	}
}

public struct AppBskyActorNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getPreferences(input: AppBskyActorGetPreferencesParameters) async throws -> AppBskyActorGetPreferencesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.actor.getPreferences", queryItems: input.asQueryItems(), responseType: AppBskyActorGetPreferencesOutput.self)
	}

	public func getProfile(input: AppBskyActorGetProfileParameters) async throws -> AppBskyActorGetProfileOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.actor.getProfile", queryItems: input.asQueryItems(), responseType: AppBskyActorGetProfileOutput.self)
	}

	public func getProfiles(input: AppBskyActorGetProfilesParameters) async throws -> AppBskyActorGetProfilesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.actor.getProfiles", queryItems: input.asQueryItems(), responseType: AppBskyActorGetProfilesOutput.self)
	}

	public func getSuggestions(input: AppBskyActorGetSuggestionsParameters) async throws -> AppBskyActorGetSuggestionsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.actor.getSuggestions", queryItems: input.asQueryItems(), responseType: AppBskyActorGetSuggestionsOutput.self)
	}

	public func putPreferences(input: AppBskyActorPutPreferencesInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.actor.putPreferences", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func searchActors(input: AppBskyActorSearchActorsParameters) async throws -> AppBskyActorSearchActorsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.actor.searchActors", queryItems: input.asQueryItems(), responseType: AppBskyActorSearchActorsOutput.self)
	}

	public func searchActorsTypeahead(input: AppBskyActorSearchActorsTypeaheadParameters) async throws -> AppBskyActorSearchActorsTypeaheadOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.actor.searchActorsTypeahead", queryItems: input.asQueryItems(), responseType: AppBskyActorSearchActorsTypeaheadOutput.self)
	}
}

public struct AppBskyAgeassuranceNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func begin(input: AppBskyAgeassuranceBeginInput) async throws -> AppBskyAgeassuranceBeginOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.ageassurance.begin", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyAgeassuranceBeginOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyAgeassuranceBeginError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getConfig() async throws -> AppBskyAgeassuranceGetConfigOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.ageassurance.getConfig", queryItems: [], responseType: AppBskyAgeassuranceGetConfigOutput.self)
	}

	public func getState(input: AppBskyAgeassuranceGetStateParameters) async throws -> AppBskyAgeassuranceGetStateOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.ageassurance.getState", queryItems: input.asQueryItems(), responseType: AppBskyAgeassuranceGetStateOutput.self)
	}
}

public struct AppBskyBookmarkNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func createBookmark(input: AppBskyBookmarkCreateBookmarkInput) async throws -> EmptyResponse {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.bookmark.createBookmark", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyBookmarkCreateBookmarkError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func deleteBookmark(input: AppBskyBookmarkDeleteBookmarkInput) async throws -> EmptyResponse {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.bookmark.deleteBookmark", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyBookmarkDeleteBookmarkError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getBookmarks(input: AppBskyBookmarkGetBookmarksParameters) async throws -> AppBskyBookmarkGetBookmarksOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.bookmark.getBookmarks", queryItems: input.asQueryItems(), responseType: AppBskyBookmarkGetBookmarksOutput.self)
	}
}

public struct AppBskyContactNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func dismissMatch(input: AppBskyContactDismissMatchInput) async throws -> AppBskyContactDismissMatchOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.contact.dismissMatch", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyContactDismissMatchOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyContactDismissMatchError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getMatches(input: AppBskyContactGetMatchesParameters) async throws -> AppBskyContactGetMatchesOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.contact.getMatches", queryItems: input.asQueryItems(), responseType: AppBskyContactGetMatchesOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyContactGetMatchesError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getSyncStatus(input: AppBskyContactGetSyncStatusParameters) async throws -> AppBskyContactGetSyncStatusOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.contact.getSyncStatus", queryItems: input.asQueryItems(), responseType: AppBskyContactGetSyncStatusOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyContactGetSyncStatusError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func importContacts(input: AppBskyContactImportContactsInput) async throws -> AppBskyContactImportContactsOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.contact.importContacts", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyContactImportContactsOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyContactImportContactsError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func removeData(input: AppBskyContactRemoveDataInput) async throws -> AppBskyContactRemoveDataOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.contact.removeData", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyContactRemoveDataOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyContactRemoveDataError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func sendNotification(input: AppBskyContactSendNotificationInput) async throws -> AppBskyContactSendNotificationOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.contact.sendNotification", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyContactSendNotificationOutput.self)
	}

	public func startPhoneVerification(input: AppBskyContactStartPhoneVerificationInput) async throws -> AppBskyContactStartPhoneVerificationOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.contact.startPhoneVerification", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyContactStartPhoneVerificationOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyContactStartPhoneVerificationError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func verifyPhone(input: AppBskyContactVerifyPhoneInput) async throws -> AppBskyContactVerifyPhoneOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.contact.verifyPhone", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyContactVerifyPhoneOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyContactVerifyPhoneError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}
}

public struct AppBskyDraftNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func createDraft(input: AppBskyDraftCreateDraftInput) async throws -> AppBskyDraftCreateDraftOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.draft.createDraft", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyDraftCreateDraftOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyDraftCreateDraftError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func deleteDraft(input: AppBskyDraftDeleteDraftInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.draft.deleteDraft", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func getDrafts(input: AppBskyDraftGetDraftsParameters) async throws -> AppBskyDraftGetDraftsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.draft.getDrafts", queryItems: input.asQueryItems(), responseType: AppBskyDraftGetDraftsOutput.self)
	}

	public func updateDraft(input: AppBskyDraftUpdateDraftInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.draft.updateDraft", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}
}

public struct AppBskyFeedNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func describeFeedGenerator() async throws -> AppBskyFeedDescribeFeedGeneratorOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.describeFeedGenerator", queryItems: [], responseType: AppBskyFeedDescribeFeedGeneratorOutput.self)
	}

	public func getActorFeeds(input: AppBskyFeedGetActorFeedsParameters) async throws -> AppBskyFeedGetActorFeedsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getActorFeeds", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetActorFeedsOutput.self)
	}

	public func getActorLikes(input: AppBskyFeedGetActorLikesParameters) async throws -> AppBskyFeedGetActorLikesOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getActorLikes", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetActorLikesOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyFeedGetActorLikesError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getAuthorFeed(input: AppBskyFeedGetAuthorFeedParameters) async throws -> AppBskyFeedGetAuthorFeedOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getAuthorFeed", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetAuthorFeedOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyFeedGetAuthorFeedError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getFeed(input: AppBskyFeedGetFeedParameters) async throws -> AppBskyFeedGetFeedOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getFeed", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetFeedOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyFeedGetFeedError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getFeedGenerator(input: AppBskyFeedGetFeedGeneratorParameters) async throws -> AppBskyFeedGetFeedGeneratorOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getFeedGenerator", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetFeedGeneratorOutput.self)
	}

	public func getFeedGenerators(input: AppBskyFeedGetFeedGeneratorsParameters) async throws -> AppBskyFeedGetFeedGeneratorsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getFeedGenerators", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetFeedGeneratorsOutput.self)
	}

	public func getFeedSkeleton(input: AppBskyFeedGetFeedSkeletonParameters) async throws -> AppBskyFeedGetFeedSkeletonOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getFeedSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetFeedSkeletonOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyFeedGetFeedSkeletonError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getLikes(input: AppBskyFeedGetLikesParameters) async throws -> AppBskyFeedGetLikesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getLikes", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetLikesOutput.self)
	}

	public func getListFeed(input: AppBskyFeedGetListFeedParameters) async throws -> AppBskyFeedGetListFeedOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getListFeed", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetListFeedOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyFeedGetListFeedError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getPosts(input: AppBskyFeedGetPostsParameters) async throws -> AppBskyFeedGetPostsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getPosts", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetPostsOutput.self)
	}

	public func getPostThread(input: AppBskyFeedGetPostThreadParameters) async throws -> AppBskyFeedGetPostThreadOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getPostThread", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetPostThreadOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyFeedGetPostThreadError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getQuotes(input: AppBskyFeedGetQuotesParameters) async throws -> AppBskyFeedGetQuotesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getQuotes", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetQuotesOutput.self)
	}

	public func getRepostedBy(input: AppBskyFeedGetRepostedByParameters) async throws -> AppBskyFeedGetRepostedByOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getRepostedBy", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetRepostedByOutput.self)
	}

	public func getSuggestedFeeds(input: AppBskyFeedGetSuggestedFeedsParameters) async throws -> AppBskyFeedGetSuggestedFeedsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getSuggestedFeeds", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetSuggestedFeedsOutput.self)
	}

	public func getTimeline(input: AppBskyFeedGetTimelineParameters) async throws -> AppBskyFeedGetTimelineOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.getTimeline", queryItems: input.asQueryItems(), responseType: AppBskyFeedGetTimelineOutput.self)
	}

	public func searchPosts(input: AppBskyFeedSearchPostsParameters) async throws -> AppBskyFeedSearchPostsOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.feed.searchPosts", queryItems: input.asQueryItems(), responseType: AppBskyFeedSearchPostsOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyFeedSearchPostsError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func sendInteractions(input: AppBskyFeedSendInteractionsInput) async throws -> AppBskyFeedSendInteractionsOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.feed.sendInteractions", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyFeedSendInteractionsOutput.self)
	}
}

public struct AppBskyGraphNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getActorStarterPacks(input: AppBskyGraphGetActorStarterPacksParameters) async throws -> AppBskyGraphGetActorStarterPacksOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getActorStarterPacks", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetActorStarterPacksOutput.self)
	}

	public func getBlocks(input: AppBskyGraphGetBlocksParameters) async throws -> AppBskyGraphGetBlocksOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getBlocks", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetBlocksOutput.self)
	}

	public func getFollowers(input: AppBskyGraphGetFollowersParameters) async throws -> AppBskyGraphGetFollowersOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getFollowers", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetFollowersOutput.self)
	}

	public func getFollows(input: AppBskyGraphGetFollowsParameters) async throws -> AppBskyGraphGetFollowsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getFollows", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetFollowsOutput.self)
	}

	public func getKnownFollowers(input: AppBskyGraphGetKnownFollowersParameters) async throws -> AppBskyGraphGetKnownFollowersOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getKnownFollowers", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetKnownFollowersOutput.self)
	}

	public func getList(input: AppBskyGraphGetListParameters) async throws -> AppBskyGraphGetListOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getList", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetListOutput.self)
	}

	public func getListBlocks(input: AppBskyGraphGetListBlocksParameters) async throws -> AppBskyGraphGetListBlocksOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getListBlocks", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetListBlocksOutput.self)
	}

	public func getListMutes(input: AppBskyGraphGetListMutesParameters) async throws -> AppBskyGraphGetListMutesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getListMutes", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetListMutesOutput.self)
	}

	public func getLists(input: AppBskyGraphGetListsParameters) async throws -> AppBskyGraphGetListsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getLists", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetListsOutput.self)
	}

	public func getListsWithMembership(input: AppBskyGraphGetListsWithMembershipParameters) async throws -> AppBskyGraphGetListsWithMembershipOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getListsWithMembership", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetListsWithMembershipOutput.self)
	}

	public func getMutes(input: AppBskyGraphGetMutesParameters) async throws -> AppBskyGraphGetMutesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getMutes", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetMutesOutput.self)
	}

	public func getRelationships(input: AppBskyGraphGetRelationshipsParameters) async throws -> AppBskyGraphGetRelationshipsOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getRelationships", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetRelationshipsOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyGraphGetRelationshipsError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getStarterPack(input: AppBskyGraphGetStarterPackParameters) async throws -> AppBskyGraphGetStarterPackOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getStarterPack", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetStarterPackOutput.self)
	}

	public func getStarterPacks(input: AppBskyGraphGetStarterPacksParameters) async throws -> AppBskyGraphGetStarterPacksOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getStarterPacks", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetStarterPacksOutput.self)
	}

	public func getStarterPacksWithMembership(input: AppBskyGraphGetStarterPacksWithMembershipParameters) async throws -> AppBskyGraphGetStarterPacksWithMembershipOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getStarterPacksWithMembership", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetStarterPacksWithMembershipOutput.self)
	}

	public func getSuggestedFollowsByActor(input: AppBskyGraphGetSuggestedFollowsByActorParameters) async throws -> AppBskyGraphGetSuggestedFollowsByActorOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.getSuggestedFollowsByActor", queryItems: input.asQueryItems(), responseType: AppBskyGraphGetSuggestedFollowsByActorOutput.self)
	}

	public func muteActor(input: AppBskyGraphMuteActorInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.graph.muteActor", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func muteActorList(input: AppBskyGraphMuteActorListInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.graph.muteActorList", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func muteThread(input: AppBskyGraphMuteThreadInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.graph.muteThread", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func searchStarterPacks(input: AppBskyGraphSearchStarterPacksParameters) async throws -> AppBskyGraphSearchStarterPacksOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.graph.searchStarterPacks", queryItems: input.asQueryItems(), responseType: AppBskyGraphSearchStarterPacksOutput.self)
	}

	public func unmuteActor(input: AppBskyGraphUnmuteActorInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.graph.unmuteActor", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func unmuteActorList(input: AppBskyGraphUnmuteActorListInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.graph.unmuteActorList", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func unmuteThread(input: AppBskyGraphUnmuteThreadInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.graph.unmuteThread", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}
}

public struct AppBskyLabelerNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getServices(input: AppBskyLabelerGetServicesParameters) async throws -> AppBskyLabelerGetServicesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.labeler.getServices", queryItems: input.asQueryItems(), responseType: AppBskyLabelerGetServicesOutput.self)
	}
}

public struct AppBskyNotificationNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getPreferences(input: AppBskyNotificationGetPreferencesParameters) async throws -> AppBskyNotificationGetPreferencesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.notification.getPreferences", queryItems: input.asQueryItems(), responseType: AppBskyNotificationGetPreferencesOutput.self)
	}

	public func getUnreadCount(input: AppBskyNotificationGetUnreadCountParameters) async throws -> AppBskyNotificationGetUnreadCountOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.notification.getUnreadCount", queryItems: input.asQueryItems(), responseType: AppBskyNotificationGetUnreadCountOutput.self)
	}

	public func listActivitySubscriptions(input: AppBskyNotificationListActivitySubscriptionsParameters) async throws -> AppBskyNotificationListActivitySubscriptionsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.notification.listActivitySubscriptions", queryItems: input.asQueryItems(), responseType: AppBskyNotificationListActivitySubscriptionsOutput.self)
	}

	public func listNotifications(input: AppBskyNotificationListNotificationsParameters) async throws -> AppBskyNotificationListNotificationsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.notification.listNotifications", queryItems: input.asQueryItems(), responseType: AppBskyNotificationListNotificationsOutput.self)
	}

	public func putActivitySubscription(input: AppBskyNotificationPutActivitySubscriptionInput) async throws -> AppBskyNotificationPutActivitySubscriptionOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.notification.putActivitySubscription", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyNotificationPutActivitySubscriptionOutput.self)
	}

	public func putPreferences(input: AppBskyNotificationPutPreferencesInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.notification.putPreferences", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func putPreferencesV2(input: AppBskyNotificationPutPreferencesV2Input) async throws -> AppBskyNotificationPutPreferencesV2Output {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.notification.putPreferencesV2", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyNotificationPutPreferencesV2Output.self)
	}

	public func registerPush(input: AppBskyNotificationRegisterPushInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.notification.registerPush", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func unregisterPush(input: AppBskyNotificationUnregisterPushInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.notification.unregisterPush", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func updateSeen(input: AppBskyNotificationUpdateSeenInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.notification.updateSeen", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}
}

public struct AppBskyUnspeccedNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getAgeAssuranceState() async throws -> AppBskyUnspeccedGetAgeAssuranceStateOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getAgeAssuranceState", queryItems: [], responseType: AppBskyUnspeccedGetAgeAssuranceStateOutput.self)
	}

	public func getConfig() async throws -> AppBskyUnspeccedGetConfigOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getConfig", queryItems: [], responseType: AppBskyUnspeccedGetConfigOutput.self)
	}

	public func getOnboardingSuggestedStarterPacks(input: AppBskyUnspeccedGetOnboardingSuggestedStarterPacksParameters) async throws -> AppBskyUnspeccedGetOnboardingSuggestedStarterPacksOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getOnboardingSuggestedStarterPacks", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetOnboardingSuggestedStarterPacksOutput.self)
	}

	public func getOnboardingSuggestedStarterPacksSkeleton(input: AppBskyUnspeccedGetOnboardingSuggestedStarterPacksSkeletonParameters) async throws -> AppBskyUnspeccedGetOnboardingSuggestedStarterPacksSkeletonOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getOnboardingSuggestedStarterPacksSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetOnboardingSuggestedStarterPacksSkeletonOutput.self)
	}

	public func getOnboardingSuggestedUsersSkeleton(input: AppBskyUnspeccedGetOnboardingSuggestedUsersSkeletonParameters) async throws -> AppBskyUnspeccedGetOnboardingSuggestedUsersSkeletonOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getOnboardingSuggestedUsersSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetOnboardingSuggestedUsersSkeletonOutput.self)
	}

	public func getPopularFeedGenerators(input: AppBskyUnspeccedGetPopularFeedGeneratorsParameters) async throws -> AppBskyUnspeccedGetPopularFeedGeneratorsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getPopularFeedGenerators", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetPopularFeedGeneratorsOutput.self)
	}

	public func getPostThreadOtherV2(input: AppBskyUnspeccedGetPostThreadOtherV2Parameters) async throws -> AppBskyUnspeccedGetPostThreadOtherV2Output {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getPostThreadOtherV2", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetPostThreadOtherV2Output.self)
	}

	public func getPostThreadV2(input: AppBskyUnspeccedGetPostThreadV2Parameters) async throws -> AppBskyUnspeccedGetPostThreadV2Output {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getPostThreadV2", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetPostThreadV2Output.self)
	}

	public func getSuggestedFeeds(input: AppBskyUnspeccedGetSuggestedFeedsParameters) async throws -> AppBskyUnspeccedGetSuggestedFeedsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getSuggestedFeeds", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetSuggestedFeedsOutput.self)
	}

	public func getSuggestedFeedsSkeleton(input: AppBskyUnspeccedGetSuggestedFeedsSkeletonParameters) async throws -> AppBskyUnspeccedGetSuggestedFeedsSkeletonOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getSuggestedFeedsSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetSuggestedFeedsSkeletonOutput.self)
	}

	public func getSuggestedOnboardingUsers(input: AppBskyUnspeccedGetSuggestedOnboardingUsersParameters) async throws -> AppBskyUnspeccedGetSuggestedOnboardingUsersOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getSuggestedOnboardingUsers", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetSuggestedOnboardingUsersOutput.self)
	}

	public func getSuggestedStarterPacks(input: AppBskyUnspeccedGetSuggestedStarterPacksParameters) async throws -> AppBskyUnspeccedGetSuggestedStarterPacksOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getSuggestedStarterPacks", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetSuggestedStarterPacksOutput.self)
	}

	public func getSuggestedStarterPacksSkeleton(input: AppBskyUnspeccedGetSuggestedStarterPacksSkeletonParameters) async throws -> AppBskyUnspeccedGetSuggestedStarterPacksSkeletonOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getSuggestedStarterPacksSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetSuggestedStarterPacksSkeletonOutput.self)
	}

	public func getSuggestedUsers(input: AppBskyUnspeccedGetSuggestedUsersParameters) async throws -> AppBskyUnspeccedGetSuggestedUsersOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getSuggestedUsers", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetSuggestedUsersOutput.self)
	}

	public func getSuggestedUsersSkeleton(input: AppBskyUnspeccedGetSuggestedUsersSkeletonParameters) async throws -> AppBskyUnspeccedGetSuggestedUsersSkeletonOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getSuggestedUsersSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetSuggestedUsersSkeletonOutput.self)
	}

	public func getSuggestionsSkeleton(input: AppBskyUnspeccedGetSuggestionsSkeletonParameters) async throws -> AppBskyUnspeccedGetSuggestionsSkeletonOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getSuggestionsSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetSuggestionsSkeletonOutput.self)
	}

	public func getTaggedSuggestions(input: AppBskyUnspeccedGetTaggedSuggestionsParameters) async throws -> AppBskyUnspeccedGetTaggedSuggestionsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getTaggedSuggestions", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetTaggedSuggestionsOutput.self)
	}

	public func getTrendingTopics(input: AppBskyUnspeccedGetTrendingTopicsParameters) async throws -> AppBskyUnspeccedGetTrendingTopicsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getTrendingTopics", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetTrendingTopicsOutput.self)
	}

	public func getTrends(input: AppBskyUnspeccedGetTrendsParameters) async throws -> AppBskyUnspeccedGetTrendsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getTrends", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetTrendsOutput.self)
	}

	public func getTrendsSkeleton(input: AppBskyUnspeccedGetTrendsSkeletonParameters) async throws -> AppBskyUnspeccedGetTrendsSkeletonOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.getTrendsSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedGetTrendsSkeletonOutput.self)
	}

	public func initAgeAssurance(input: AppBskyUnspeccedInitAgeAssuranceInput) async throws -> AppBskyUnspeccedInitAgeAssuranceOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.unspecced.initAgeAssurance", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: AppBskyUnspeccedInitAgeAssuranceOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyUnspeccedInitAgeAssuranceError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func searchActorsSkeleton(input: AppBskyUnspeccedSearchActorsSkeletonParameters) async throws -> AppBskyUnspeccedSearchActorsSkeletonOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.searchActorsSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedSearchActorsSkeletonOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyUnspeccedSearchActorsSkeletonError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func searchPostsSkeleton(input: AppBskyUnspeccedSearchPostsSkeletonParameters) async throws -> AppBskyUnspeccedSearchPostsSkeletonOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.searchPostsSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedSearchPostsSkeletonOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyUnspeccedSearchPostsSkeletonError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func searchStarterPacksSkeleton(input: AppBskyUnspeccedSearchStarterPacksSkeletonParameters) async throws -> AppBskyUnspeccedSearchStarterPacksSkeletonOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.unspecced.searchStarterPacksSkeleton", queryItems: input.asQueryItems(), responseType: AppBskyUnspeccedSearchStarterPacksSkeletonOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = AppBskyUnspeccedSearchStarterPacksSkeletonError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}
}

public struct AppBskyVideoNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getJobStatus(input: AppBskyVideoGetJobStatusParameters) async throws -> AppBskyVideoGetJobStatusOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.video.getJobStatus", queryItems: input.asQueryItems(), responseType: AppBskyVideoGetJobStatusOutput.self)
	}

	public func getUploadLimits() async throws -> AppBskyVideoGetUploadLimitsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/app.bsky.video.getUploadLimits", queryItems: [], responseType: AppBskyVideoGetUploadLimitsOutput.self)
	}

	public func uploadVideo(input: AppBskyVideoUploadVideoInput) async throws -> AppBskyVideoUploadVideoOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/app.bsky.video.uploadVideo", body: input.data, queryItems: [], headers: ["Content-Type": input.contentType], responseType: AppBskyVideoUploadVideoOutput.self)
	}
}

public struct ChatNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public var bsky: ChatBskyNamespace {
		ChatBskyNamespace(client: client)
	}
}

public struct ChatBskyNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public var actor: ChatBskyActorNamespace {
		ChatBskyActorNamespace(client: client)
	}

	public var convo: ChatBskyConvoNamespace {
		ChatBskyConvoNamespace(client: client)
	}

	public var moderation: ChatBskyModerationNamespace {
		ChatBskyModerationNamespace(client: client)
	}
}

public struct ChatBskyActorNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func deleteAccount() async throws -> ChatBskyActorDeleteAccountOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.actor.deleteAccount", body: nil, queryItems: [], headers: [:], responseType: ChatBskyActorDeleteAccountOutput.self)
	}

	public func exportAccountData() async throws -> Data {
		return try await client.requestData(method: "GET", path: "/xrpc/chat.bsky.actor.exportAccountData", queryItems: [], responseKind: .jsonl)
	}
}

public struct ChatBskyConvoNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func acceptConvo(input: ChatBskyConvoAcceptConvoInput) async throws -> ChatBskyConvoAcceptConvoOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.acceptConvo", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoAcceptConvoOutput.self)
	}

	public func addReaction(input: ChatBskyConvoAddReactionInput) async throws -> ChatBskyConvoAddReactionOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.addReaction", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoAddReactionOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ChatBskyConvoAddReactionError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func deleteMessageForSelf(input: ChatBskyConvoDeleteMessageForSelfInput) async throws -> ChatBskyConvoDeleteMessageForSelfOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.deleteMessageForSelf", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoDeleteMessageForSelfOutput.self)
	}

	public func getConvo(input: ChatBskyConvoGetConvoParameters) async throws -> ChatBskyConvoGetConvoOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/chat.bsky.convo.getConvo", queryItems: input.asQueryItems(), responseType: ChatBskyConvoGetConvoOutput.self)
	}

	public func getConvoAvailability(input: ChatBskyConvoGetConvoAvailabilityParameters) async throws -> ChatBskyConvoGetConvoAvailabilityOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/chat.bsky.convo.getConvoAvailability", queryItems: input.asQueryItems(), responseType: ChatBskyConvoGetConvoAvailabilityOutput.self)
	}

	public func getConvoForMembers(input: ChatBskyConvoGetConvoForMembersParameters) async throws -> ChatBskyConvoGetConvoForMembersOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/chat.bsky.convo.getConvoForMembers", queryItems: input.asQueryItems(), responseType: ChatBskyConvoGetConvoForMembersOutput.self)
	}

	public func getLog(input: ChatBskyConvoGetLogParameters) async throws -> ChatBskyConvoGetLogOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/chat.bsky.convo.getLog", queryItems: input.asQueryItems(), responseType: ChatBskyConvoGetLogOutput.self)
	}

	public func getMessages(input: ChatBskyConvoGetMessagesParameters) async throws -> ChatBskyConvoGetMessagesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/chat.bsky.convo.getMessages", queryItems: input.asQueryItems(), responseType: ChatBskyConvoGetMessagesOutput.self)
	}

	public func leaveConvo(input: ChatBskyConvoLeaveConvoInput) async throws -> ChatBskyConvoLeaveConvoOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.leaveConvo", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoLeaveConvoOutput.self)
	}

	public func listConvos(input: ChatBskyConvoListConvosParameters) async throws -> ChatBskyConvoListConvosOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/chat.bsky.convo.listConvos", queryItems: input.asQueryItems(), responseType: ChatBskyConvoListConvosOutput.self)
	}

	public func muteConvo(input: ChatBskyConvoMuteConvoInput) async throws -> ChatBskyConvoMuteConvoOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.muteConvo", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoMuteConvoOutput.self)
	}

	public func removeReaction(input: ChatBskyConvoRemoveReactionInput) async throws -> ChatBskyConvoRemoveReactionOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.removeReaction", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoRemoveReactionOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ChatBskyConvoRemoveReactionError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func sendMessage(input: ChatBskyConvoSendMessageInput) async throws -> ChatBskyConvoSendMessageOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.sendMessage", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoSendMessageOutput.self)
	}

	public func sendMessageBatch(input: ChatBskyConvoSendMessageBatchInput) async throws -> ChatBskyConvoSendMessageBatchOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.sendMessageBatch", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoSendMessageBatchOutput.self)
	}

	public func unmuteConvo(input: ChatBskyConvoUnmuteConvoInput) async throws -> ChatBskyConvoUnmuteConvoOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.unmuteConvo", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoUnmuteConvoOutput.self)
	}

	public func updateAllRead(input: ChatBskyConvoUpdateAllReadInput) async throws -> ChatBskyConvoUpdateAllReadOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.updateAllRead", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoUpdateAllReadOutput.self)
	}

	public func updateRead(input: ChatBskyConvoUpdateReadInput) async throws -> ChatBskyConvoUpdateReadOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.convo.updateRead", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ChatBskyConvoUpdateReadOutput.self)
	}
}

public struct ChatBskyModerationNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getActorMetadata(input: ChatBskyModerationGetActorMetadataParameters) async throws -> ChatBskyModerationGetActorMetadataOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/chat.bsky.moderation.getActorMetadata", queryItems: input.asQueryItems(), responseType: ChatBskyModerationGetActorMetadataOutput.self)
	}

	public func getMessageContext(input: ChatBskyModerationGetMessageContextParameters) async throws -> ChatBskyModerationGetMessageContextOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/chat.bsky.moderation.getMessageContext", queryItems: input.asQueryItems(), responseType: ChatBskyModerationGetMessageContextOutput.self)
	}

	public func updateActorAccess(input: ChatBskyModerationUpdateActorAccessInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/chat.bsky.moderation.updateActorAccess", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}
}

public struct ComNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public var atproto: ComAtprotoNamespace {
		ComAtprotoNamespace(client: client)
	}
}

public struct ComAtprotoNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public var admin: ComAtprotoAdminNamespace {
		ComAtprotoAdminNamespace(client: client)
	}

	public var identity: ComAtprotoIdentityNamespace {
		ComAtprotoIdentityNamespace(client: client)
	}

	public var label: ComAtprotoLabelNamespace {
		ComAtprotoLabelNamespace(client: client)
	}

	public var lexicon: ComAtprotoLexiconNamespace {
		ComAtprotoLexiconNamespace(client: client)
	}

	public var moderation: ComAtprotoModerationNamespace {
		ComAtprotoModerationNamespace(client: client)
	}

	public var repo: ComAtprotoRepoNamespace {
		ComAtprotoRepoNamespace(client: client)
	}

	public var server: ComAtprotoServerNamespace {
		ComAtprotoServerNamespace(client: client)
	}

	public var sync: ComAtprotoSyncNamespace {
		ComAtprotoSyncNamespace(client: client)
	}

	public var temp: ComAtprotoTempNamespace {
		ComAtprotoTempNamespace(client: client)
	}
}

public struct ComAtprotoAdminNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func deleteAccount(input: ComAtprotoAdminDeleteAccountInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.admin.deleteAccount", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func disableAccountInvites(input: ComAtprotoAdminDisableAccountInvitesInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.admin.disableAccountInvites", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func disableInviteCodes(input: ComAtprotoAdminDisableInviteCodesInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.admin.disableInviteCodes", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func enableAccountInvites(input: ComAtprotoAdminEnableAccountInvitesInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.admin.enableAccountInvites", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func getAccountInfo(input: ComAtprotoAdminGetAccountInfoParameters) async throws -> ComAtprotoAdminGetAccountInfoOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.admin.getAccountInfo", queryItems: input.asQueryItems(), responseType: ComAtprotoAdminGetAccountInfoOutput.self)
	}

	public func getAccountInfos(input: ComAtprotoAdminGetAccountInfosParameters) async throws -> ComAtprotoAdminGetAccountInfosOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.admin.getAccountInfos", queryItems: input.asQueryItems(), responseType: ComAtprotoAdminGetAccountInfosOutput.self)
	}

	public func getInviteCodes(input: ComAtprotoAdminGetInviteCodesParameters) async throws -> ComAtprotoAdminGetInviteCodesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.admin.getInviteCodes", queryItems: input.asQueryItems(), responseType: ComAtprotoAdminGetInviteCodesOutput.self)
	}

	public func getSubjectStatus(input: ComAtprotoAdminGetSubjectStatusParameters) async throws -> ComAtprotoAdminGetSubjectStatusOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.admin.getSubjectStatus", queryItems: input.asQueryItems(), responseType: ComAtprotoAdminGetSubjectStatusOutput.self)
	}

	public func searchAccounts(input: ComAtprotoAdminSearchAccountsParameters) async throws -> ComAtprotoAdminSearchAccountsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.admin.searchAccounts", queryItems: input.asQueryItems(), responseType: ComAtprotoAdminSearchAccountsOutput.self)
	}

	public func sendEmail(input: ComAtprotoAdminSendEmailInput) async throws -> ComAtprotoAdminSendEmailOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.admin.sendEmail", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoAdminSendEmailOutput.self)
	}

	public func updateAccountEmail(input: ComAtprotoAdminUpdateAccountEmailInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.admin.updateAccountEmail", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func updateAccountHandle(input: ComAtprotoAdminUpdateAccountHandleInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.admin.updateAccountHandle", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func updateAccountPassword(input: ComAtprotoAdminUpdateAccountPasswordInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.admin.updateAccountPassword", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func updateAccountSigningKey(input: ComAtprotoAdminUpdateAccountSigningKeyInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.admin.updateAccountSigningKey", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func updateSubjectStatus(input: ComAtprotoAdminUpdateSubjectStatusInput) async throws -> ComAtprotoAdminUpdateSubjectStatusOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.admin.updateSubjectStatus", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoAdminUpdateSubjectStatusOutput.self)
	}
}

public struct ComAtprotoIdentityNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getRecommendedDidCredentials() async throws -> ComAtprotoIdentityGetRecommendedDidCredentialsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.identity.getRecommendedDidCredentials", queryItems: [], responseType: ComAtprotoIdentityGetRecommendedDidCredentialsOutput.self)
	}

	public func refreshIdentity(input: ComAtprotoIdentityRefreshIdentityInput) async throws -> ComAtprotoIdentityRefreshIdentityOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.identity.refreshIdentity", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoIdentityRefreshIdentityOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoIdentityRefreshIdentityError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func requestPlcOperationSignature() async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.identity.requestPlcOperationSignature", body: nil, queryItems: [], headers: [:], responseType: EmptyResponse.self)
	}

	public func resolveDid(input: ComAtprotoIdentityResolveDidParameters) async throws -> ComAtprotoIdentityResolveDidOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.identity.resolveDid", queryItems: input.asQueryItems(), responseType: ComAtprotoIdentityResolveDidOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoIdentityResolveDidError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func resolveHandle(input: ComAtprotoIdentityResolveHandleParameters) async throws -> ComAtprotoIdentityResolveHandleOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.identity.resolveHandle", queryItems: input.asQueryItems(), responseType: ComAtprotoIdentityResolveHandleOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoIdentityResolveHandleError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func resolveIdentity(input: ComAtprotoIdentityResolveIdentityParameters) async throws -> ComAtprotoIdentityResolveIdentityOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.identity.resolveIdentity", queryItems: input.asQueryItems(), responseType: ComAtprotoIdentityResolveIdentityOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoIdentityResolveIdentityError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func signPlcOperation(input: ComAtprotoIdentitySignPlcOperationInput) async throws -> ComAtprotoIdentitySignPlcOperationOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.identity.signPlcOperation", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoIdentitySignPlcOperationOutput.self)
	}

	public func submitPlcOperation(input: ComAtprotoIdentitySubmitPlcOperationInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.identity.submitPlcOperation", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func updateHandle(input: ComAtprotoIdentityUpdateHandleInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.identity.updateHandle", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}
}

public struct ComAtprotoLabelNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func queryLabels(input: ComAtprotoLabelQueryLabelsParameters) async throws -> ComAtprotoLabelQueryLabelsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.label.queryLabels", queryItems: input.asQueryItems(), responseType: ComAtprotoLabelQueryLabelsOutput.self)
	}

	public func subscribeLabels(input: ComAtprotoLabelSubscribeLabelsParameters) -> AsyncThrowingStream<XRPCSubscriptionEvent<ComAtprotoLabelSubscribeLabelsMessage>, Error> {
		client.subscribe(path: "/xrpc/com.atproto.label.subscribeLabels", queryItems: input.asQueryItems(), responseType: ComAtprotoLabelSubscribeLabelsMessage.self)
	}
}

public struct ComAtprotoLexiconNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func resolveLexicon(input: ComAtprotoLexiconResolveLexiconParameters) async throws -> ComAtprotoLexiconResolveLexiconOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.lexicon.resolveLexicon", queryItems: input.asQueryItems(), responseType: ComAtprotoLexiconResolveLexiconOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoLexiconResolveLexiconError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}
}

public struct ComAtprotoModerationNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func createReport(input: ComAtprotoModerationCreateReportInput) async throws -> ComAtprotoModerationCreateReportOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.moderation.createReport", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoModerationCreateReportOutput.self)
	}
}

public struct ComAtprotoRepoNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func applyWrites(input: ComAtprotoRepoApplyWritesInput) async throws -> ComAtprotoRepoApplyWritesOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.repo.applyWrites", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoRepoApplyWritesOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoRepoApplyWritesError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func createRecord(input: ComAtprotoRepoCreateRecordInput) async throws -> ComAtprotoRepoCreateRecordOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.repo.createRecord", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoRepoCreateRecordOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoRepoCreateRecordError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func deleteRecord(input: ComAtprotoRepoDeleteRecordInput) async throws -> ComAtprotoRepoDeleteRecordOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.repo.deleteRecord", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoRepoDeleteRecordOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoRepoDeleteRecordError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func describeRepo(input: ComAtprotoRepoDescribeRepoParameters) async throws -> ComAtprotoRepoDescribeRepoOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.repo.describeRepo", queryItems: input.asQueryItems(), responseType: ComAtprotoRepoDescribeRepoOutput.self)
	}

	public func getRecord(input: ComAtprotoRepoGetRecordParameters) async throws -> ComAtprotoRepoGetRecordOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.repo.getRecord", queryItems: input.asQueryItems(), responseType: ComAtprotoRepoGetRecordOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoRepoGetRecordError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func importRepo(input: ComAtprotoRepoImportRepoInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.repo.importRepo", body: input.data, queryItems: [], headers: ["Content-Type": input.contentType], responseType: EmptyResponse.self)
	}

	public func listMissingBlobs(input: ComAtprotoRepoListMissingBlobsParameters) async throws -> ComAtprotoRepoListMissingBlobsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.repo.listMissingBlobs", queryItems: input.asQueryItems(), responseType: ComAtprotoRepoListMissingBlobsOutput.self)
	}

	public func listRecords(input: ComAtprotoRepoListRecordsParameters) async throws -> ComAtprotoRepoListRecordsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.repo.listRecords", queryItems: input.asQueryItems(), responseType: ComAtprotoRepoListRecordsOutput.self)
	}

	public func putRecord(input: ComAtprotoRepoPutRecordInput) async throws -> ComAtprotoRepoPutRecordOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.repo.putRecord", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoRepoPutRecordOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoRepoPutRecordError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func uploadBlob(input: ComAtprotoRepoUploadBlobInput) async throws -> ComAtprotoRepoUploadBlobOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.repo.uploadBlob", body: input.data, queryItems: [], headers: ["Content-Type": input.contentType], responseType: ComAtprotoRepoUploadBlobOutput.self)
	}
}

public struct ComAtprotoServerNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func activateAccount() async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.activateAccount", body: nil, queryItems: [], headers: [:], responseType: EmptyResponse.self)
	}

	public func checkAccountStatus() async throws -> ComAtprotoServerCheckAccountStatusOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.server.checkAccountStatus", queryItems: [], responseType: ComAtprotoServerCheckAccountStatusOutput.self)
	}

	public func confirmEmail(input: ComAtprotoServerConfirmEmailInput) async throws -> EmptyResponse {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.confirmEmail", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerConfirmEmailError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func createAccount(input: ComAtprotoServerCreateAccountInput) async throws -> ComAtprotoServerCreateAccountOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.createAccount", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoServerCreateAccountOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerCreateAccountError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func createAppPassword(input: ComAtprotoServerCreateAppPasswordInput) async throws -> ComAtprotoServerCreateAppPasswordOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.createAppPassword", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoServerCreateAppPasswordOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerCreateAppPasswordError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func createInviteCode(input: ComAtprotoServerCreateInviteCodeInput) async throws -> ComAtprotoServerCreateInviteCodeOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.createInviteCode", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoServerCreateInviteCodeOutput.self)
	}

	public func createInviteCodes(input: ComAtprotoServerCreateInviteCodesInput) async throws -> ComAtprotoServerCreateInviteCodesOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.createInviteCodes", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoServerCreateInviteCodesOutput.self)
	}

	public func createSession(input: ComAtprotoServerCreateSessionInput) async throws -> ComAtprotoServerCreateSessionOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.createSession", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoServerCreateSessionOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerCreateSessionError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func deactivateAccount(input: ComAtprotoServerDeactivateAccountInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.deactivateAccount", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func deleteAccount(input: ComAtprotoServerDeleteAccountInput) async throws -> EmptyResponse {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.deleteAccount", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerDeleteAccountError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func deleteSession() async throws -> EmptyResponse {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.deleteSession", body: nil, queryItems: [], headers: [:], responseType: EmptyResponse.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerDeleteSessionError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func describeServer() async throws -> ComAtprotoServerDescribeServerOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.server.describeServer", queryItems: [], responseType: ComAtprotoServerDescribeServerOutput.self)
	}

	public func getAccountInviteCodes(input: ComAtprotoServerGetAccountInviteCodesParameters) async throws -> ComAtprotoServerGetAccountInviteCodesOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.server.getAccountInviteCodes", queryItems: input.asQueryItems(), responseType: ComAtprotoServerGetAccountInviteCodesOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerGetAccountInviteCodesError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getServiceAuth(input: ComAtprotoServerGetServiceAuthParameters) async throws -> ComAtprotoServerGetServiceAuthOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.server.getServiceAuth", queryItems: input.asQueryItems(), responseType: ComAtprotoServerGetServiceAuthOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerGetServiceAuthError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getSession() async throws -> ComAtprotoServerGetSessionOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.server.getSession", queryItems: [], responseType: ComAtprotoServerGetSessionOutput.self)
	}

	public func listAppPasswords() async throws -> ComAtprotoServerListAppPasswordsOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.server.listAppPasswords", queryItems: [], responseType: ComAtprotoServerListAppPasswordsOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerListAppPasswordsError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func refreshSession() async throws -> ComAtprotoServerRefreshSessionOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.refreshSession", body: nil, queryItems: [], headers: [:], responseType: ComAtprotoServerRefreshSessionOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerRefreshSessionError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func requestAccountDelete() async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.requestAccountDelete", body: nil, queryItems: [], headers: [:], responseType: EmptyResponse.self)
	}

	public func requestEmailConfirmation() async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.requestEmailConfirmation", body: nil, queryItems: [], headers: [:], responseType: EmptyResponse.self)
	}

	public func requestEmailUpdate() async throws -> ComAtprotoServerRequestEmailUpdateOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.requestEmailUpdate", body: nil, queryItems: [], headers: [:], responseType: ComAtprotoServerRequestEmailUpdateOutput.self)
	}

	public func requestPasswordReset(input: ComAtprotoServerRequestPasswordResetInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.requestPasswordReset", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func reserveSigningKey(input: ComAtprotoServerReserveSigningKeyInput) async throws -> ComAtprotoServerReserveSigningKeyOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.reserveSigningKey", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoServerReserveSigningKeyOutput.self)
	}

	public func resetPassword(input: ComAtprotoServerResetPasswordInput) async throws -> EmptyResponse {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.resetPassword", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerResetPasswordError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func revokeAppPassword(input: ComAtprotoServerRevokeAppPasswordInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.revokeAppPassword", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func updateEmail(input: ComAtprotoServerUpdateEmailInput) async throws -> EmptyResponse {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.server.updateEmail", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoServerUpdateEmailError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}
}

public struct ComAtprotoSyncNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getBlob(input: ComAtprotoSyncGetBlobParameters) async throws -> Data {
		do {
			return try await client.requestData(method: "GET", path: "/xrpc/com.atproto.sync.getBlob", queryItems: input.asQueryItems(), responseKind: .binary)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoSyncGetBlobError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getBlocks(input: ComAtprotoSyncGetBlocksParameters) async throws -> Data {
		do {
			return try await client.requestData(method: "GET", path: "/xrpc/com.atproto.sync.getBlocks", queryItems: input.asQueryItems(), responseKind: .car)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoSyncGetBlocksError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getCheckout(input: ComAtprotoSyncGetCheckoutParameters) async throws -> Data {
		return try await client.requestData(method: "GET", path: "/xrpc/com.atproto.sync.getCheckout", queryItems: input.asQueryItems(), responseKind: .car)
	}

	public func getHead(input: ComAtprotoSyncGetHeadParameters) async throws -> ComAtprotoSyncGetHeadOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.sync.getHead", queryItems: input.asQueryItems(), responseType: ComAtprotoSyncGetHeadOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoSyncGetHeadError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getHostStatus(input: ComAtprotoSyncGetHostStatusParameters) async throws -> ComAtprotoSyncGetHostStatusOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.sync.getHostStatus", queryItems: input.asQueryItems(), responseType: ComAtprotoSyncGetHostStatusOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoSyncGetHostStatusError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getLatestCommit(input: ComAtprotoSyncGetLatestCommitParameters) async throws -> ComAtprotoSyncGetLatestCommitOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.sync.getLatestCommit", queryItems: input.asQueryItems(), responseType: ComAtprotoSyncGetLatestCommitOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoSyncGetLatestCommitError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getRecord(input: ComAtprotoSyncGetRecordParameters) async throws -> Data {
		do {
			return try await client.requestData(method: "GET", path: "/xrpc/com.atproto.sync.getRecord", queryItems: input.asQueryItems(), responseKind: .car)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoSyncGetRecordError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getRepo(input: ComAtprotoSyncGetRepoParameters) async throws -> Data {
		do {
			return try await client.requestData(method: "GET", path: "/xrpc/com.atproto.sync.getRepo", queryItems: input.asQueryItems(), responseKind: .car)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoSyncGetRepoError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getRepoStatus(input: ComAtprotoSyncGetRepoStatusParameters) async throws -> ComAtprotoSyncGetRepoStatusOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.sync.getRepoStatus", queryItems: input.asQueryItems(), responseType: ComAtprotoSyncGetRepoStatusOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoSyncGetRepoStatusError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func listBlobs(input: ComAtprotoSyncListBlobsParameters) async throws -> ComAtprotoSyncListBlobsOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.sync.listBlobs", queryItems: input.asQueryItems(), responseType: ComAtprotoSyncListBlobsOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoSyncListBlobsError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func listHosts(input: ComAtprotoSyncListHostsParameters) async throws -> ComAtprotoSyncListHostsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.sync.listHosts", queryItems: input.asQueryItems(), responseType: ComAtprotoSyncListHostsOutput.self)
	}

	public func listRepos(input: ComAtprotoSyncListReposParameters) async throws -> ComAtprotoSyncListReposOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.sync.listRepos", queryItems: input.asQueryItems(), responseType: ComAtprotoSyncListReposOutput.self)
	}

	public func listReposByCollection(input: ComAtprotoSyncListReposByCollectionParameters) async throws -> ComAtprotoSyncListReposByCollectionOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.sync.listReposByCollection", queryItems: input.asQueryItems(), responseType: ComAtprotoSyncListReposByCollectionOutput.self)
	}

	public func notifyOfUpdate(input: ComAtprotoSyncNotifyOfUpdateInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.sync.notifyOfUpdate", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func requestCrawl(input: ComAtprotoSyncRequestCrawlInput) async throws -> EmptyResponse {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.sync.requestCrawl", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoSyncRequestCrawlError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func subscribeRepos(input: ComAtprotoSyncSubscribeReposParameters) -> AsyncThrowingStream<XRPCSubscriptionEvent<ComAtprotoSyncSubscribeReposMessage>, Error> {
		client.subscribe(path: "/xrpc/com.atproto.sync.subscribeRepos", queryItems: input.asQueryItems(), responseType: ComAtprotoSyncSubscribeReposMessage.self)
	}
}

public struct ComAtprotoTempNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func addReservedHandle(input: ComAtprotoTempAddReservedHandleInput) async throws -> ComAtprotoTempAddReservedHandleOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.temp.addReservedHandle", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ComAtprotoTempAddReservedHandleOutput.self)
	}

	public func checkHandleAvailability(input: ComAtprotoTempCheckHandleAvailabilityParameters) async throws -> ComAtprotoTempCheckHandleAvailabilityOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.temp.checkHandleAvailability", queryItems: input.asQueryItems(), responseType: ComAtprotoTempCheckHandleAvailabilityOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoTempCheckHandleAvailabilityError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func checkSignupQueue() async throws -> ComAtprotoTempCheckSignupQueueOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.temp.checkSignupQueue", queryItems: [], responseType: ComAtprotoTempCheckSignupQueueOutput.self)
	}

	public func dereferenceScope(input: ComAtprotoTempDereferenceScopeParameters) async throws -> ComAtprotoTempDereferenceScopeOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.temp.dereferenceScope", queryItems: input.asQueryItems(), responseType: ComAtprotoTempDereferenceScopeOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ComAtprotoTempDereferenceScopeError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func fetchLabels(input: ComAtprotoTempFetchLabelsParameters) async throws -> ComAtprotoTempFetchLabelsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/com.atproto.temp.fetchLabels", queryItems: input.asQueryItems(), responseType: ComAtprotoTempFetchLabelsOutput.self)
	}

	public func requestPhoneVerification(input: ComAtprotoTempRequestPhoneVerificationInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.temp.requestPhoneVerification", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func revokeAccountCredentials(input: ComAtprotoTempRevokeAccountCredentialsInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/com.atproto.temp.revokeAccountCredentials", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}
}

public struct ToolsNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public var ozone: ToolsOzoneNamespace {
		ToolsOzoneNamespace(client: client)
	}
}

public struct ToolsOzoneNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public var communication: ToolsOzoneCommunicationNamespace {
		ToolsOzoneCommunicationNamespace(client: client)
	}

	public var hosting: ToolsOzoneHostingNamespace {
		ToolsOzoneHostingNamespace(client: client)
	}

	public var moderation: ToolsOzoneModerationNamespace {
		ToolsOzoneModerationNamespace(client: client)
	}

	public var safelink: ToolsOzoneSafelinkNamespace {
		ToolsOzoneSafelinkNamespace(client: client)
	}

	public var server: ToolsOzoneServerNamespace {
		ToolsOzoneServerNamespace(client: client)
	}

	public var set: ToolsOzoneSetNamespace {
		ToolsOzoneSetNamespace(client: client)
	}

	public var setting: ToolsOzoneSettingNamespace {
		ToolsOzoneSettingNamespace(client: client)
	}

	public var signature: ToolsOzoneSignatureNamespace {
		ToolsOzoneSignatureNamespace(client: client)
	}

	public var team: ToolsOzoneTeamNamespace {
		ToolsOzoneTeamNamespace(client: client)
	}

	public var verification: ToolsOzoneVerificationNamespace {
		ToolsOzoneVerificationNamespace(client: client)
	}
}

public struct ToolsOzoneCommunicationNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func createTemplate(input: ToolsOzoneCommunicationCreateTemplateInput) async throws -> ToolsOzoneCommunicationCreateTemplateOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.communication.createTemplate", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneCommunicationCreateTemplateOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneCommunicationCreateTemplateError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func deleteTemplate(input: ToolsOzoneCommunicationDeleteTemplateInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.communication.deleteTemplate", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func listTemplates() async throws -> ToolsOzoneCommunicationListTemplatesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.communication.listTemplates", queryItems: [], responseType: ToolsOzoneCommunicationListTemplatesOutput.self)
	}

	public func updateTemplate(input: ToolsOzoneCommunicationUpdateTemplateInput) async throws -> ToolsOzoneCommunicationUpdateTemplateOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.communication.updateTemplate", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneCommunicationUpdateTemplateOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneCommunicationUpdateTemplateError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}
}

public struct ToolsOzoneHostingNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getAccountHistory(input: ToolsOzoneHostingGetAccountHistoryParameters) async throws -> ToolsOzoneHostingGetAccountHistoryOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.hosting.getAccountHistory", queryItems: input.asQueryItems(), responseType: ToolsOzoneHostingGetAccountHistoryOutput.self)
	}
}

public struct ToolsOzoneModerationNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func cancelScheduledActions(input: ToolsOzoneModerationCancelScheduledActionsInput) async throws -> ToolsOzoneModerationCancelScheduledActionsOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.moderation.cancelScheduledActions", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneModerationCancelScheduledActionsOutput.self)
	}

	public func emitEvent(input: ToolsOzoneModerationEmitEventInput) async throws -> ToolsOzoneModerationEmitEventOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.moderation.emitEvent", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneModerationEmitEventOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneModerationEmitEventError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getAccountTimeline(input: ToolsOzoneModerationGetAccountTimelineParameters) async throws -> ToolsOzoneModerationGetAccountTimelineOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.getAccountTimeline", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationGetAccountTimelineOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneModerationGetAccountTimelineError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getEvent(input: ToolsOzoneModerationGetEventParameters) async throws -> ToolsOzoneModerationGetEventOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.getEvent", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationGetEventOutput.self)
	}

	public func getRecord(input: ToolsOzoneModerationGetRecordParameters) async throws -> ToolsOzoneModerationGetRecordOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.getRecord", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationGetRecordOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneModerationGetRecordError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getRecords(input: ToolsOzoneModerationGetRecordsParameters) async throws -> ToolsOzoneModerationGetRecordsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.getRecords", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationGetRecordsOutput.self)
	}

	public func getRepo(input: ToolsOzoneModerationGetRepoParameters) async throws -> ToolsOzoneModerationGetRepoOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.getRepo", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationGetRepoOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneModerationGetRepoError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getReporterStats(input: ToolsOzoneModerationGetReporterStatsParameters) async throws -> ToolsOzoneModerationGetReporterStatsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.getReporterStats", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationGetReporterStatsOutput.self)
	}

	public func getRepos(input: ToolsOzoneModerationGetReposParameters) async throws -> ToolsOzoneModerationGetReposOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.getRepos", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationGetReposOutput.self)
	}

	public func getSubjects(input: ToolsOzoneModerationGetSubjectsParameters) async throws -> ToolsOzoneModerationGetSubjectsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.getSubjects", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationGetSubjectsOutput.self)
	}

	public func listScheduledActions(input: ToolsOzoneModerationListScheduledActionsInput) async throws -> ToolsOzoneModerationListScheduledActionsOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.moderation.listScheduledActions", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneModerationListScheduledActionsOutput.self)
	}

	public func queryEvents(input: ToolsOzoneModerationQueryEventsParameters) async throws -> ToolsOzoneModerationQueryEventsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.queryEvents", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationQueryEventsOutput.self)
	}

	public func queryStatuses(input: ToolsOzoneModerationQueryStatusesParameters) async throws -> ToolsOzoneModerationQueryStatusesOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.queryStatuses", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationQueryStatusesOutput.self)
	}

	public func scheduleAction(input: ToolsOzoneModerationScheduleActionInput) async throws -> ToolsOzoneModerationScheduleActionOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.moderation.scheduleAction", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneModerationScheduleActionOutput.self)
	}

	public func searchRepos(input: ToolsOzoneModerationSearchReposParameters) async throws -> ToolsOzoneModerationSearchReposOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.moderation.searchRepos", queryItems: input.asQueryItems(), responseType: ToolsOzoneModerationSearchReposOutput.self)
	}
}

public struct ToolsOzoneSafelinkNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func addRule(input: ToolsOzoneSafelinkAddRuleInput) async throws -> ToolsOzoneSafelinkAddRuleOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.safelink.addRule", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneSafelinkAddRuleOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneSafelinkAddRuleError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func queryEvents(input: ToolsOzoneSafelinkQueryEventsInput) async throws -> ToolsOzoneSafelinkQueryEventsOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.safelink.queryEvents", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneSafelinkQueryEventsOutput.self)
	}

	public func queryRules(input: ToolsOzoneSafelinkQueryRulesInput) async throws -> ToolsOzoneSafelinkQueryRulesOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.safelink.queryRules", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneSafelinkQueryRulesOutput.self)
	}

	public func removeRule(input: ToolsOzoneSafelinkRemoveRuleInput) async throws -> ToolsOzoneSafelinkRemoveRuleOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.safelink.removeRule", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneSafelinkRemoveRuleOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneSafelinkRemoveRuleError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func updateRule(input: ToolsOzoneSafelinkUpdateRuleInput) async throws -> ToolsOzoneSafelinkUpdateRuleOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.safelink.updateRule", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneSafelinkUpdateRuleOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneSafelinkUpdateRuleError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}
}

public struct ToolsOzoneServerNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func getConfig() async throws -> ToolsOzoneServerGetConfigOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.server.getConfig", queryItems: [], responseType: ToolsOzoneServerGetConfigOutput.self)
	}
}

public struct ToolsOzoneSetNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func addValues(input: ToolsOzoneSetAddValuesInput) async throws -> EmptyResponse {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.set.addValues", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
	}

	public func deleteSet(input: ToolsOzoneSetDeleteSetInput) async throws -> ToolsOzoneSetDeleteSetOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.set.deleteSet", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneSetDeleteSetOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneSetDeleteSetError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func deleteValues(input: ToolsOzoneSetDeleteValuesInput) async throws -> EmptyResponse {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.set.deleteValues", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneSetDeleteValuesError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func getValues(input: ToolsOzoneSetGetValuesParameters) async throws -> ToolsOzoneSetGetValuesOutput {
		do {
			return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.set.getValues", queryItems: input.asQueryItems(), responseType: ToolsOzoneSetGetValuesOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneSetGetValuesError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func querySets(input: ToolsOzoneSetQuerySetsParameters) async throws -> ToolsOzoneSetQuerySetsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.set.querySets", queryItems: input.asQueryItems(), responseType: ToolsOzoneSetQuerySetsOutput.self)
	}

	public func upsertSet(input: ToolsOzoneSetUpsertSetInput) async throws -> ToolsOzoneSetUpsertSetOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.set.upsertSet", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneSetUpsertSetOutput.self)
	}
}

public struct ToolsOzoneSettingNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func listOptions(input: ToolsOzoneSettingListOptionsParameters) async throws -> ToolsOzoneSettingListOptionsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.setting.listOptions", queryItems: input.asQueryItems(), responseType: ToolsOzoneSettingListOptionsOutput.self)
	}

	public func removeOptions(input: ToolsOzoneSettingRemoveOptionsInput) async throws -> ToolsOzoneSettingRemoveOptionsOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.setting.removeOptions", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneSettingRemoveOptionsOutput.self)
	}

	public func upsertOption(input: ToolsOzoneSettingUpsertOptionInput) async throws -> ToolsOzoneSettingUpsertOptionOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.setting.upsertOption", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneSettingUpsertOptionOutput.self)
	}
}

public struct ToolsOzoneSignatureNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func findCorrelation(input: ToolsOzoneSignatureFindCorrelationParameters) async throws -> ToolsOzoneSignatureFindCorrelationOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.signature.findCorrelation", queryItems: input.asQueryItems(), responseType: ToolsOzoneSignatureFindCorrelationOutput.self)
	}

	public func findRelatedAccounts(input: ToolsOzoneSignatureFindRelatedAccountsParameters) async throws -> ToolsOzoneSignatureFindRelatedAccountsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.signature.findRelatedAccounts", queryItems: input.asQueryItems(), responseType: ToolsOzoneSignatureFindRelatedAccountsOutput.self)
	}

	public func searchAccounts(input: ToolsOzoneSignatureSearchAccountsParameters) async throws -> ToolsOzoneSignatureSearchAccountsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.signature.searchAccounts", queryItems: input.asQueryItems(), responseType: ToolsOzoneSignatureSearchAccountsOutput.self)
	}
}

public struct ToolsOzoneTeamNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func addMember(input: ToolsOzoneTeamAddMemberInput) async throws -> ToolsOzoneTeamAddMemberOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.team.addMember", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneTeamAddMemberOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneTeamAddMemberError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func deleteMember(input: ToolsOzoneTeamDeleteMemberInput) async throws -> EmptyResponse {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.team.deleteMember", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: EmptyResponse.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneTeamDeleteMemberError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}

	public func listMembers(input: ToolsOzoneTeamListMembersParameters) async throws -> ToolsOzoneTeamListMembersOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.team.listMembers", queryItems: input.asQueryItems(), responseType: ToolsOzoneTeamListMembersOutput.self)
	}

	public func updateMember(input: ToolsOzoneTeamUpdateMemberInput) async throws -> ToolsOzoneTeamUpdateMemberOutput {
		do {
			return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.team.updateMember", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneTeamUpdateMemberOutput.self)
		} catch let error as XRPCTransportError {
			if let typedError = ToolsOzoneTeamUpdateMemberError(transportError: error) {
				throw typedError
			}
			throw error
		}
	}
}

public struct ToolsOzoneVerificationNamespace {
	fileprivate let client: ATProtoClient

	fileprivate init(client: ATProtoClient) {
		self.client = client
	}

	public func grantVerifications(input: ToolsOzoneVerificationGrantVerificationsInput) async throws -> ToolsOzoneVerificationGrantVerificationsOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.verification.grantVerifications", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneVerificationGrantVerificationsOutput.self)
	}

	public func listVerifications(input: ToolsOzoneVerificationListVerificationsParameters) async throws -> ToolsOzoneVerificationListVerificationsOutput {
		return try await client.requestJSON(method: "GET", path: "/xrpc/tools.ozone.verification.listVerifications", queryItems: input.asQueryItems(), responseType: ToolsOzoneVerificationListVerificationsOutput.self)
	}

	public func revokeVerifications(input: ToolsOzoneVerificationRevokeVerificationsInput) async throws -> ToolsOzoneVerificationRevokeVerificationsOutput {
		return try await client.requestJSON(method: "POST", path: "/xrpc/tools.ozone.verification.revokeVerifications", body: try client.encodedBody(input), queryItems: [], headers: ["Content-Type": "application/json"], responseType: ToolsOzoneVerificationRevokeVerificationsOutput.self)
	}
}
