import Foundation


public struct AppBskyAuthViewAll: Codable, Sendable, Equatable {
	public static let title: String? = "Read-only access to all content"
	public static let detail: String? = "View Bluesky network content from account perspective, and read all notifications and preferences."
	public static let knownMethods: [AppBskyAuthViewAllMethod] = [.appBskyActorGetProfile, .appBskyActorGetProfiles, .appBskyActorGetSuggestions, .appBskyActorSearchActors, .appBskyActorSearchActorsTypeahead, .appBskyBookmarkGetBookmarks, .appBskyFeedDescribeFeedGenerator, .appBskyFeedGetActorFeeds, .appBskyFeedGetActorLikes, .appBskyFeedGetAuthorFeed, .appBskyFeedGetFeed, .appBskyFeedGetFeedGenerator, .appBskyFeedGetFeedGenerators, .appBskyFeedGetFeedSkeleton, .appBskyFeedGetLikes, .appBskyFeedGetListFeed, .appBskyFeedGetPostThread, .appBskyFeedGetPosts, .appBskyFeedGetQuotes, .appBskyFeedGetRepostedBy, .appBskyFeedGetSuggestedFeeds, .appBskyFeedGetTimeline, .appBskyFeedSearchPosts, .appBskyGraphGetActorStarterPacks, .appBskyGraphGetBlocks, .appBskyGraphGetFollowers, .appBskyGraphGetFollows, .appBskyGraphGetKnownFollowers, .appBskyGraphGetListBlocks, .appBskyGraphGetListMutes, .appBskyGraphGetLists, .appBskyGraphGetListsWithMembership, .appBskyGraphGetMutes, .appBskyGraphGetRelationships, .appBskyGraphGetStarterPack, .appBskyGraphGetStarterPacks, .appBskyGraphGetStarterPacksWithMembership, .appBskyGraphGetSuggestedFollowsByActor, .appBskyGraphSearchStarterPacks, .appBskyLabelerGetServices, .appBskyNotificationGetPreferences, .appBskyNotificationGetUnreadCount, .appBskyNotificationListActivitySubscriptions, .appBskyNotificationListNotifications, .appBskyNotificationUpdateSeen, .appBskyUnspeccedGetAgeAssuranceState, .appBskyUnspeccedGetConfig, .appBskyUnspeccedGetOnboardingSuggestedStarterPacks, .appBskyUnspeccedGetPopularFeedGenerators, .appBskyUnspeccedGetPostThreadOtherV2, .appBskyUnspeccedGetPostThreadV2, .appBskyUnspeccedGetSuggestedFeeds, .appBskyUnspeccedGetSuggestedFeedsSkeleton, .appBskyUnspeccedGetSuggestedStarterPacks, .appBskyUnspeccedGetSuggestedStarterPacksSkeleton, .appBskyUnspeccedGetSuggestedUsers, .appBskyUnspeccedGetSuggestedUsersSkeleton, .appBskyUnspeccedGetSuggestionsSkeleton, .appBskyUnspeccedGetTaggedSuggestions, .appBskyUnspeccedGetTrendingTopics, .appBskyUnspeccedGetTrends, .appBskyUnspeccedGetTrendsSkeleton, .appBskyUnspeccedSearchActorsSkeleton, .appBskyUnspeccedSearchPostsSkeleton, .appBskyUnspeccedSearchStarterPacksSkeleton, .appBskyVideoGetUploadLimits]

	public let grantedMethods: [AppBskyAuthViewAllMethod]

	public init(grantedMethods: [AppBskyAuthViewAllMethod] = []) {
		self.grantedMethods = grantedMethods
	}

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		var grantedMethods: [AppBskyAuthViewAllMethod] = []
		while !container.isAtEnd {
			grantedMethods.append(AppBskyAuthViewAllMethod(rawValue: try container.decode(String.self)))
		}
		self.grantedMethods = grantedMethods
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		for method in grantedMethods {
			try container.encode(method.rawValue)
		}
	}
}


public struct AppBskyAuthViewAllMethod: RawRepresentable, Codable, Hashable, Sendable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public static let appBskyActorGetProfile = Self(rawValue: "app.bsky.actor.getProfile")
	public static let appBskyActorGetProfiles = Self(rawValue: "app.bsky.actor.getProfiles")
	public static let appBskyActorGetSuggestions = Self(rawValue: "app.bsky.actor.getSuggestions")
	public static let appBskyActorSearchActors = Self(rawValue: "app.bsky.actor.searchActors")
	public static let appBskyActorSearchActorsTypeahead = Self(rawValue: "app.bsky.actor.searchActorsTypeahead")
	public static let appBskyBookmarkGetBookmarks = Self(rawValue: "app.bsky.bookmark.getBookmarks")
	public static let appBskyFeedDescribeFeedGenerator = Self(rawValue: "app.bsky.feed.describeFeedGenerator")
	public static let appBskyFeedGetActorFeeds = Self(rawValue: "app.bsky.feed.getActorFeeds")
	public static let appBskyFeedGetActorLikes = Self(rawValue: "app.bsky.feed.getActorLikes")
	public static let appBskyFeedGetAuthorFeed = Self(rawValue: "app.bsky.feed.getAuthorFeed")
	public static let appBskyFeedGetFeed = Self(rawValue: "app.bsky.feed.getFeed")
	public static let appBskyFeedGetFeedGenerator = Self(rawValue: "app.bsky.feed.getFeedGenerator")
	public static let appBskyFeedGetFeedGenerators = Self(rawValue: "app.bsky.feed.getFeedGenerators")
	public static let appBskyFeedGetFeedSkeleton = Self(rawValue: "app.bsky.feed.getFeedSkeleton")
	public static let appBskyFeedGetLikes = Self(rawValue: "app.bsky.feed.getLikes")
	public static let appBskyFeedGetListFeed = Self(rawValue: "app.bsky.feed.getListFeed")
	public static let appBskyFeedGetPostThread = Self(rawValue: "app.bsky.feed.getPostThread")
	public static let appBskyFeedGetPosts = Self(rawValue: "app.bsky.feed.getPosts")
	public static let appBskyFeedGetQuotes = Self(rawValue: "app.bsky.feed.getQuotes")
	public static let appBskyFeedGetRepostedBy = Self(rawValue: "app.bsky.feed.getRepostedBy")
	public static let appBskyFeedGetSuggestedFeeds = Self(rawValue: "app.bsky.feed.getSuggestedFeeds")
	public static let appBskyFeedGetTimeline = Self(rawValue: "app.bsky.feed.getTimeline")
	public static let appBskyFeedSearchPosts = Self(rawValue: "app.bsky.feed.searchPosts")
	public static let appBskyGraphGetActorStarterPacks = Self(rawValue: "app.bsky.graph.getActorStarterPacks")
	public static let appBskyGraphGetBlocks = Self(rawValue: "app.bsky.graph.getBlocks")
	public static let appBskyGraphGetFollowers = Self(rawValue: "app.bsky.graph.getFollowers")
	public static let appBskyGraphGetFollows = Self(rawValue: "app.bsky.graph.getFollows")
	public static let appBskyGraphGetKnownFollowers = Self(rawValue: "app.bsky.graph.getKnownFollowers")
	public static let appBskyGraphGetListBlocks = Self(rawValue: "app.bsky.graph.getListBlocks")
	public static let appBskyGraphGetListMutes = Self(rawValue: "app.bsky.graph.getListMutes")
	public static let appBskyGraphGetLists = Self(rawValue: "app.bsky.graph.getLists")
	public static let appBskyGraphGetListsWithMembership = Self(rawValue: "app.bsky.graph.getListsWithMembership")
	public static let appBskyGraphGetMutes = Self(rawValue: "app.bsky.graph.getMutes")
	public static let appBskyGraphGetRelationships = Self(rawValue: "app.bsky.graph.getRelationships")
	public static let appBskyGraphGetStarterPack = Self(rawValue: "app.bsky.graph.getStarterPack")
	public static let appBskyGraphGetStarterPacks = Self(rawValue: "app.bsky.graph.getStarterPacks")
	public static let appBskyGraphGetStarterPacksWithMembership = Self(rawValue: "app.bsky.graph.getStarterPacksWithMembership")
	public static let appBskyGraphGetSuggestedFollowsByActor = Self(rawValue: "app.bsky.graph.getSuggestedFollowsByActor")
	public static let appBskyGraphSearchStarterPacks = Self(rawValue: "app.bsky.graph.searchStarterPacks")
	public static let appBskyLabelerGetServices = Self(rawValue: "app.bsky.labeler.getServices")
	public static let appBskyNotificationGetPreferences = Self(rawValue: "app.bsky.notification.getPreferences")
	public static let appBskyNotificationGetUnreadCount = Self(rawValue: "app.bsky.notification.getUnreadCount")
	public static let appBskyNotificationListActivitySubscriptions = Self(rawValue: "app.bsky.notification.listActivitySubscriptions")
	public static let appBskyNotificationListNotifications = Self(rawValue: "app.bsky.notification.listNotifications")
	public static let appBskyNotificationUpdateSeen = Self(rawValue: "app.bsky.notification.updateSeen")
	public static let appBskyUnspeccedGetAgeAssuranceState = Self(rawValue: "app.bsky.unspecced.getAgeAssuranceState")
	public static let appBskyUnspeccedGetConfig = Self(rawValue: "app.bsky.unspecced.getConfig")
	public static let appBskyUnspeccedGetOnboardingSuggestedStarterPacks = Self(rawValue: "app.bsky.unspecced.getOnboardingSuggestedStarterPacks")
	public static let appBskyUnspeccedGetPopularFeedGenerators = Self(rawValue: "app.bsky.unspecced.getPopularFeedGenerators")
	public static let appBskyUnspeccedGetPostThreadOtherV2 = Self(rawValue: "app.bsky.unspecced.getPostThreadOtherV2")
	public static let appBskyUnspeccedGetPostThreadV2 = Self(rawValue: "app.bsky.unspecced.getPostThreadV2")
	public static let appBskyUnspeccedGetSuggestedFeeds = Self(rawValue: "app.bsky.unspecced.getSuggestedFeeds")
	public static let appBskyUnspeccedGetSuggestedFeedsSkeleton = Self(rawValue: "app.bsky.unspecced.getSuggestedFeedsSkeleton")
	public static let appBskyUnspeccedGetSuggestedStarterPacks = Self(rawValue: "app.bsky.unspecced.getSuggestedStarterPacks")
	public static let appBskyUnspeccedGetSuggestedStarterPacksSkeleton = Self(rawValue: "app.bsky.unspecced.getSuggestedStarterPacksSkeleton")
	public static let appBskyUnspeccedGetSuggestedUsers = Self(rawValue: "app.bsky.unspecced.getSuggestedUsers")
	public static let appBskyUnspeccedGetSuggestedUsersSkeleton = Self(rawValue: "app.bsky.unspecced.getSuggestedUsersSkeleton")
	public static let appBskyUnspeccedGetSuggestionsSkeleton = Self(rawValue: "app.bsky.unspecced.getSuggestionsSkeleton")
	public static let appBskyUnspeccedGetTaggedSuggestions = Self(rawValue: "app.bsky.unspecced.getTaggedSuggestions")
	public static let appBskyUnspeccedGetTrendingTopics = Self(rawValue: "app.bsky.unspecced.getTrendingTopics")
	public static let appBskyUnspeccedGetTrends = Self(rawValue: "app.bsky.unspecced.getTrends")
	public static let appBskyUnspeccedGetTrendsSkeleton = Self(rawValue: "app.bsky.unspecced.getTrendsSkeleton")
	public static let appBskyUnspeccedSearchActorsSkeleton = Self(rawValue: "app.bsky.unspecced.searchActorsSkeleton")
	public static let appBskyUnspeccedSearchPostsSkeleton = Self(rawValue: "app.bsky.unspecced.searchPostsSkeleton")
	public static let appBskyUnspeccedSearchStarterPacksSkeleton = Self(rawValue: "app.bsky.unspecced.searchStarterPacksSkeleton")
	public static let appBskyVideoGetUploadLimits = Self(rawValue: "app.bsky.video.getUploadLimits")
}


