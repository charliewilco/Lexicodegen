import Foundation


public struct AppBskyAuthFullApp: Codable, Sendable, Equatable {
	public static let title: String? = "Full Bluesky Social App Permissions"
	public static let detail: String? = "Manage all public content and interactions, private preferences and subscriptions, and other Bluesky-specific app features and data."
	public static let knownMethods: [AppBskyAuthFullAppMethod] = [.appBskyActorGetPreferences, .appBskyActorGetProfile, .appBskyActorGetProfiles, .appBskyActorGetSuggestions, .appBskyActorPutPreferences, .appBskyActorSearchActors, .appBskyActorSearchActorsTypeahead, .appBskyBookmarkCreateBookmark, .appBskyBookmarkDeleteBookmark, .appBskyBookmarkGetBookmarks, .appBskyContactDismissMatch, .appBskyContactGetMatches, .appBskyContactGetSyncStatus, .appBskyContactImportContacts, .appBskyContactRemoveData, .appBskyContactStartPhoneVerification, .appBskyContactVerifyPhone, .appBskyFeedDescribeFeedGenerator, .appBskyFeedGetActorFeeds, .appBskyFeedGetActorLikes, .appBskyFeedGetAuthorFeed, .appBskyFeedGetFeed, .appBskyFeedGetFeedGenerator, .appBskyFeedGetFeedGenerators, .appBskyFeedGetFeedSkeleton, .appBskyFeedGetLikes, .appBskyFeedGetListFeed, .appBskyFeedGetPostThread, .appBskyFeedGetPosts, .appBskyFeedGetQuotes, .appBskyFeedGetRepostedBy, .appBskyFeedGetSuggestedFeeds, .appBskyFeedGetTimeline, .appBskyFeedSearchPosts, .appBskyFeedSendInteractions, .appBskyGraphGetActorStarterPacks, .appBskyGraphGetBlocks, .appBskyGraphGetFollowers, .appBskyGraphGetFollows, .appBskyGraphGetKnownFollowers, .appBskyGraphGetList, .appBskyGraphGetListBlocks, .appBskyGraphGetListMutes, .appBskyGraphGetLists, .appBskyGraphGetListsWithMembership, .appBskyGraphGetMutes, .appBskyGraphGetRelationships, .appBskyGraphGetStarterPack, .appBskyGraphGetStarterPacks, .appBskyGraphGetStarterPacksWithMembership, .appBskyGraphGetSuggestedFollowsByActor, .appBskyGraphMuteActor, .appBskyGraphMuteActorList, .appBskyGraphMuteThread, .appBskyGraphSearchStarterPacks, .appBskyGraphUnmuteActor, .appBskyGraphUnmuteActorList, .appBskyGraphUnmuteThread, .appBskyLabelerGetServices, .appBskyNotificationGetPreferences, .appBskyNotificationGetUnreadCount, .appBskyNotificationListActivitySubscriptions, .appBskyNotificationListNotifications, .appBskyNotificationPutActivitySubscription, .appBskyNotificationPutPreferences, .appBskyNotificationPutPreferencesV2, .appBskyNotificationRegisterPush, .appBskyNotificationUnregisterPush, .appBskyNotificationUpdateSeen, .appBskyUnspeccedGetAgeAssuranceState, .appBskyUnspeccedGetConfig, .appBskyUnspeccedGetOnboardingSuggestedStarterPacks, .appBskyUnspeccedGetPopularFeedGenerators, .appBskyUnspeccedGetPostThreadOtherV2, .appBskyUnspeccedGetPostThreadV2, .appBskyUnspeccedGetSuggestedFeeds, .appBskyUnspeccedGetSuggestedFeedsSkeleton, .appBskyUnspeccedGetSuggestedStarterPacks, .appBskyUnspeccedGetSuggestedStarterPacksSkeleton, .appBskyUnspeccedGetSuggestedUsers, .appBskyUnspeccedGetSuggestedUsersSkeleton, .appBskyUnspeccedGetSuggestionsSkeleton, .appBskyUnspeccedGetTaggedSuggestions, .appBskyUnspeccedGetTrendingTopics, .appBskyUnspeccedGetTrends, .appBskyUnspeccedGetTrendsSkeleton, .appBskyUnspeccedInitAgeAssurance, .appBskyUnspeccedSearchActorsSkeleton, .appBskyUnspeccedSearchPostsSkeleton, .appBskyUnspeccedSearchStarterPacksSkeleton, .appBskyVideoGetJobStatus, .appBskyVideoGetUploadLimits, .appBskyVideoUploadVideo]

	public let grantedMethods: [AppBskyAuthFullAppMethod]

	public init(grantedMethods: [AppBskyAuthFullAppMethod] = []) {
		self.grantedMethods = grantedMethods
	}

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		var grantedMethods: [AppBskyAuthFullAppMethod] = []
		while !container.isAtEnd {
			grantedMethods.append(AppBskyAuthFullAppMethod(rawValue: try container.decode(String.self)))
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


public struct AppBskyAuthFullAppMethod: RawRepresentable, Codable, Hashable, Sendable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public static let appBskyActorGetPreferences = Self(rawValue: "app.bsky.actor.getPreferences")
	public static let appBskyActorGetProfile = Self(rawValue: "app.bsky.actor.getProfile")
	public static let appBskyActorGetProfiles = Self(rawValue: "app.bsky.actor.getProfiles")
	public static let appBskyActorGetSuggestions = Self(rawValue: "app.bsky.actor.getSuggestions")
	public static let appBskyActorPutPreferences = Self(rawValue: "app.bsky.actor.putPreferences")
	public static let appBskyActorSearchActors = Self(rawValue: "app.bsky.actor.searchActors")
	public static let appBskyActorSearchActorsTypeahead = Self(rawValue: "app.bsky.actor.searchActorsTypeahead")
	public static let appBskyBookmarkCreateBookmark = Self(rawValue: "app.bsky.bookmark.createBookmark")
	public static let appBskyBookmarkDeleteBookmark = Self(rawValue: "app.bsky.bookmark.deleteBookmark")
	public static let appBskyBookmarkGetBookmarks = Self(rawValue: "app.bsky.bookmark.getBookmarks")
	public static let appBskyContactDismissMatch = Self(rawValue: "app.bsky.contact.dismissMatch")
	public static let appBskyContactGetMatches = Self(rawValue: "app.bsky.contact.getMatches")
	public static let appBskyContactGetSyncStatus = Self(rawValue: "app.bsky.contact.getSyncStatus")
	public static let appBskyContactImportContacts = Self(rawValue: "app.bsky.contact.importContacts")
	public static let appBskyContactRemoveData = Self(rawValue: "app.bsky.contact.removeData")
	public static let appBskyContactStartPhoneVerification = Self(rawValue: "app.bsky.contact.startPhoneVerification")
	public static let appBskyContactVerifyPhone = Self(rawValue: "app.bsky.contact.verifyPhone")
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
	public static let appBskyFeedSendInteractions = Self(rawValue: "app.bsky.feed.sendInteractions")
	public static let appBskyGraphGetActorStarterPacks = Self(rawValue: "app.bsky.graph.getActorStarterPacks")
	public static let appBskyGraphGetBlocks = Self(rawValue: "app.bsky.graph.getBlocks")
	public static let appBskyGraphGetFollowers = Self(rawValue: "app.bsky.graph.getFollowers")
	public static let appBskyGraphGetFollows = Self(rawValue: "app.bsky.graph.getFollows")
	public static let appBskyGraphGetKnownFollowers = Self(rawValue: "app.bsky.graph.getKnownFollowers")
	public static let appBskyGraphGetList = Self(rawValue: "app.bsky.graph.getList")
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
	public static let appBskyGraphMuteActor = Self(rawValue: "app.bsky.graph.muteActor")
	public static let appBskyGraphMuteActorList = Self(rawValue: "app.bsky.graph.muteActorList")
	public static let appBskyGraphMuteThread = Self(rawValue: "app.bsky.graph.muteThread")
	public static let appBskyGraphSearchStarterPacks = Self(rawValue: "app.bsky.graph.searchStarterPacks")
	public static let appBskyGraphUnmuteActor = Self(rawValue: "app.bsky.graph.unmuteActor")
	public static let appBskyGraphUnmuteActorList = Self(rawValue: "app.bsky.graph.unmuteActorList")
	public static let appBskyGraphUnmuteThread = Self(rawValue: "app.bsky.graph.unmuteThread")
	public static let appBskyLabelerGetServices = Self(rawValue: "app.bsky.labeler.getServices")
	public static let appBskyNotificationGetPreferences = Self(rawValue: "app.bsky.notification.getPreferences")
	public static let appBskyNotificationGetUnreadCount = Self(rawValue: "app.bsky.notification.getUnreadCount")
	public static let appBskyNotificationListActivitySubscriptions = Self(rawValue: "app.bsky.notification.listActivitySubscriptions")
	public static let appBskyNotificationListNotifications = Self(rawValue: "app.bsky.notification.listNotifications")
	public static let appBskyNotificationPutActivitySubscription = Self(rawValue: "app.bsky.notification.putActivitySubscription")
	public static let appBskyNotificationPutPreferences = Self(rawValue: "app.bsky.notification.putPreferences")
	public static let appBskyNotificationPutPreferencesV2 = Self(rawValue: "app.bsky.notification.putPreferencesV2")
	public static let appBskyNotificationRegisterPush = Self(rawValue: "app.bsky.notification.registerPush")
	public static let appBskyNotificationUnregisterPush = Self(rawValue: "app.bsky.notification.unregisterPush")
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
	public static let appBskyUnspeccedInitAgeAssurance = Self(rawValue: "app.bsky.unspecced.initAgeAssurance")
	public static let appBskyUnspeccedSearchActorsSkeleton = Self(rawValue: "app.bsky.unspecced.searchActorsSkeleton")
	public static let appBskyUnspeccedSearchPostsSkeleton = Self(rawValue: "app.bsky.unspecced.searchPostsSkeleton")
	public static let appBskyUnspeccedSearchStarterPacksSkeleton = Self(rawValue: "app.bsky.unspecced.searchStarterPacksSkeleton")
	public static let appBskyVideoGetJobStatus = Self(rawValue: "app.bsky.video.getJobStatus")
	public static let appBskyVideoGetUploadLimits = Self(rawValue: "app.bsky.video.getUploadLimits")
	public static let appBskyVideoUploadVideo = Self(rawValue: "app.bsky.video.uploadVideo")
}


