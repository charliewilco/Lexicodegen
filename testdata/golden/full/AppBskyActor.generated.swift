import Foundation


public struct AppBskyActorDefsAdultContentPref: Codable, Sendable, Equatable {
	public let enabled: Bool

	public init(
		enabled: Bool
	) {
		self.enabled = enabled
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		enabled = try container.decode(Bool.self, forKey: .enabled)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(enabled, forKey: .enabled)
	}

	private enum CodingKeys: String, CodingKey {
		case enabled = "enabled"
	}
}


public struct AppBskyActorDefsBskyAppProgressGuide: Codable, Sendable, Equatable {
	public let guide: String

	public init(
		guide: String
	) {
		self.guide = guide
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		guide = try container.decode(String.self, forKey: .guide)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(guide, forKey: .guide)
	}

	private enum CodingKeys: String, CodingKey {
		case guide = "guide"
	}
}


public struct AppBskyActorDefsBskyAppStatePref: Codable, Sendable, Equatable {
	public let activeProgressGuide: AppBskyActorDefsBskyAppProgressGuide?
	public let nuxs: [AppBskyActorDefsNux]?
	public let queuedNudges: [String]?

	public init(
		activeProgressGuide: AppBskyActorDefsBskyAppProgressGuide? = nil,
		nuxs: [AppBskyActorDefsNux]? = nil,
		queuedNudges: [String]? = nil
	) {
		self.activeProgressGuide = activeProgressGuide
		self.nuxs = nuxs
		self.queuedNudges = queuedNudges
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		activeProgressGuide = try container.decodeIfPresent(AppBskyActorDefsBskyAppProgressGuide.self, forKey: .activeProgressGuide)
		nuxs = try container.decodeIfPresent([AppBskyActorDefsNux].self, forKey: .nuxs)
		queuedNudges = try container.decodeIfPresent([String].self, forKey: .queuedNudges)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(activeProgressGuide, forKey: .activeProgressGuide)
		try container.encodeIfPresent(nuxs, forKey: .nuxs)
		try container.encodeIfPresent(queuedNudges, forKey: .queuedNudges)
	}

	private enum CodingKeys: String, CodingKey {
		case activeProgressGuide = "activeProgressGuide"
		case nuxs = "nuxs"
		case queuedNudges = "queuedNudges"
	}
}


public struct AppBskyActorDefsContentLabelPref: Codable, Sendable, Equatable {
	public let label: String
	public let labelerDid: DID?
	public let visibility: AppBskyActorDefsContentLabelPrefVisibility

	public init(
		label: String,
		labelerDid: DID? = nil,
		visibility: AppBskyActorDefsContentLabelPrefVisibility
	) {
		self.label = label
		self.labelerDid = labelerDid
		self.visibility = visibility
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		label = try container.decode(String.self, forKey: .label)
		labelerDid = try container.decodeIfPresent(DID.self, forKey: .labelerDid)
		visibility = try container.decode(AppBskyActorDefsContentLabelPrefVisibility.self, forKey: .visibility)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(label, forKey: .label)
		try container.encodeIfPresent(labelerDid, forKey: .labelerDid)
		try container.encode(visibility, forKey: .visibility)
	}

	private enum CodingKeys: String, CodingKey {
		case label = "label"
		case labelerDid = "labelerDid"
		case visibility = "visibility"
	}
}


public enum AppBskyActorDefsContentLabelPrefVisibility: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case ignore = "ignore"
	case show = "show"
	case warn = "warn"
	case hide = "hide"
}


public struct AppBskyActorDefsDeclaredAgePref: Codable, Sendable, Equatable {
	public let isOverAge13: Bool?
	public let isOverAge16: Bool?
	public let isOverAge18: Bool?

	public init(
		isOverAge13: Bool? = nil,
		isOverAge16: Bool? = nil,
		isOverAge18: Bool? = nil
	) {
		self.isOverAge13 = isOverAge13
		self.isOverAge16 = isOverAge16
		self.isOverAge18 = isOverAge18
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		isOverAge13 = try container.decodeIfPresent(Bool.self, forKey: .isOverAge13)
		isOverAge16 = try container.decodeIfPresent(Bool.self, forKey: .isOverAge16)
		isOverAge18 = try container.decodeIfPresent(Bool.self, forKey: .isOverAge18)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(isOverAge13, forKey: .isOverAge13)
		try container.encodeIfPresent(isOverAge16, forKey: .isOverAge16)
		try container.encodeIfPresent(isOverAge18, forKey: .isOverAge18)
	}

	private enum CodingKeys: String, CodingKey {
		case isOverAge13 = "isOverAge13"
		case isOverAge16 = "isOverAge16"
		case isOverAge18 = "isOverAge18"
	}
}


public struct AppBskyActorDefsFeedViewPref: Codable, Sendable, Equatable {
	public let feed: String
	public let hideQuotePosts: Bool?
	public let hideReplies: Bool?
	public let hideRepliesByLikeCount: Int?
	public let hideRepliesByUnfollowed: Bool?
	public let hideReposts: Bool?

	public init(
		feed: String,
		hideQuotePosts: Bool? = nil,
		hideReplies: Bool? = nil,
		hideRepliesByLikeCount: Int? = nil,
		hideRepliesByUnfollowed: Bool? = nil,
		hideReposts: Bool? = nil
	) {
		self.feed = feed
		self.hideQuotePosts = hideQuotePosts
		self.hideReplies = hideReplies
		self.hideRepliesByLikeCount = hideRepliesByLikeCount
		self.hideRepliesByUnfollowed = hideRepliesByUnfollowed
		self.hideReposts = hideReposts
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		feed = try container.decode(String.self, forKey: .feed)
		hideQuotePosts = try container.decodeIfPresent(Bool.self, forKey: .hideQuotePosts)
		hideReplies = try container.decodeIfPresent(Bool.self, forKey: .hideReplies)
		hideRepliesByLikeCount = try container.decodeIfPresent(Int.self, forKey: .hideRepliesByLikeCount)
		hideRepliesByUnfollowed = try container.decodeIfPresent(Bool.self, forKey: .hideRepliesByUnfollowed)
		hideReposts = try container.decodeIfPresent(Bool.self, forKey: .hideReposts)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(feed, forKey: .feed)
		try container.encodeIfPresent(hideQuotePosts, forKey: .hideQuotePosts)
		try container.encodeIfPresent(hideReplies, forKey: .hideReplies)
		try container.encodeIfPresent(hideRepliesByLikeCount, forKey: .hideRepliesByLikeCount)
		try container.encodeIfPresent(hideRepliesByUnfollowed, forKey: .hideRepliesByUnfollowed)
		try container.encodeIfPresent(hideReposts, forKey: .hideReposts)
	}

	private enum CodingKeys: String, CodingKey {
		case feed = "feed"
		case hideQuotePosts = "hideQuotePosts"
		case hideReplies = "hideReplies"
		case hideRepliesByLikeCount = "hideRepliesByLikeCount"
		case hideRepliesByUnfollowed = "hideRepliesByUnfollowed"
		case hideReposts = "hideReposts"
	}
}


public struct AppBskyActorDefsHiddenPostsPref: Codable, Sendable, Equatable {
	public let items: [ATURI]

	public init(
		items: [ATURI]
	) {
		self.items = items
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		items = try container.decode([ATURI].self, forKey: .items)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(items, forKey: .items)
	}

	private enum CodingKeys: String, CodingKey {
		case items = "items"
	}
}


public struct AppBskyActorDefsInterestsPref: Codable, Sendable, Equatable {
	public let tags: [String]

	public init(
		tags: [String]
	) {
		self.tags = tags
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		tags = try container.decode([String].self, forKey: .tags)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(tags, forKey: .tags)
	}

	private enum CodingKeys: String, CodingKey {
		case tags = "tags"
	}
}


public struct AppBskyActorDefsKnownFollowers: Codable, Sendable, Equatable {
	public let count: Int
	public let followers: [AppBskyActorDefsProfileViewBasic]

	public init(
		count: Int,
		followers: [AppBskyActorDefsProfileViewBasic]
	) {
		self.count = count
		self.followers = followers
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		count = try container.decode(Int.self, forKey: .count)
		followers = try container.decode([AppBskyActorDefsProfileViewBasic].self, forKey: .followers)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(count, forKey: .count)
		try container.encode(followers, forKey: .followers)
	}

	private enum CodingKeys: String, CodingKey {
		case count = "count"
		case followers = "followers"
	}
}


public struct AppBskyActorDefsLabelerPrefItem: Codable, Sendable, Equatable {
	public let did: DID

	public init(
		did: DID
	) {
		self.did = did
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		did = try container.decode(DID.self, forKey: .did)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(did, forKey: .did)
	}

	private enum CodingKeys: String, CodingKey {
		case did = "did"
	}
}


public struct AppBskyActorDefsLabelersPref: Codable, Sendable, Equatable {
	public let labelers: [AppBskyActorDefsLabelerPrefItem]

	public init(
		labelers: [AppBskyActorDefsLabelerPrefItem]
	) {
		self.labelers = labelers
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		labelers = try container.decode([AppBskyActorDefsLabelerPrefItem].self, forKey: .labelers)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(labelers, forKey: .labelers)
	}

	private enum CodingKeys: String, CodingKey {
		case labelers = "labelers"
	}
}


public struct AppBskyActorDefsLiveEventPreferences: Codable, Sendable, Equatable {
	public let hiddenFeedIds: [String]?
	public let hideAllFeeds: Bool?

	public init(
		hiddenFeedIds: [String]? = nil,
		hideAllFeeds: Bool? = nil
	) {
		self.hiddenFeedIds = hiddenFeedIds
		self.hideAllFeeds = hideAllFeeds
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		hiddenFeedIds = try container.decodeIfPresent([String].self, forKey: .hiddenFeedIds)
		hideAllFeeds = try container.decodeIfPresent(Bool.self, forKey: .hideAllFeeds)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(hiddenFeedIds, forKey: .hiddenFeedIds)
		try container.encodeIfPresent(hideAllFeeds, forKey: .hideAllFeeds)
	}

	private enum CodingKeys: String, CodingKey {
		case hiddenFeedIds = "hiddenFeedIds"
		case hideAllFeeds = "hideAllFeeds"
	}
}


public struct AppBskyActorDefsMutedWord: Codable, Sendable, Equatable {
	public let actorTarget: AppBskyActorDefsMutedWordActorTarget?
	public let expiresAt: ATProtocolDate?
	public let id: String?
	public let targets: [AppBskyActorDefsMutedWordTarget]
	public let value: String

	public init(
		actorTarget: AppBskyActorDefsMutedWordActorTarget? = nil,
		expiresAt: ATProtocolDate? = nil,
		id: String? = nil,
		targets: [AppBskyActorDefsMutedWordTarget],
		value: String
	) {
		self.actorTarget = actorTarget
		self.expiresAt = expiresAt
		self.id = id
		self.targets = targets
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actorTarget = try container.decodeIfPresent(AppBskyActorDefsMutedWordActorTarget.self, forKey: .actorTarget)
		expiresAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .expiresAt)
		id = try container.decodeIfPresent(String.self, forKey: .id)
		targets = try container.decode([AppBskyActorDefsMutedWordTarget].self, forKey: .targets)
		value = try container.decode(String.self, forKey: .value)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(actorTarget, forKey: .actorTarget)
		try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
		try container.encodeIfPresent(id, forKey: .id)
		try container.encode(targets, forKey: .targets)
		try container.encode(value, forKey: .value)
	}

	private enum CodingKeys: String, CodingKey {
		case actorTarget = "actorTarget"
		case expiresAt = "expiresAt"
		case id = "id"
		case targets = "targets"
		case value = "value"
	}
}


public enum AppBskyActorDefsMutedWordActorTarget: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case all = "all"
	case excludeFollowing = "exclude-following"
}


public struct AppBskyActorDefsMutedWordsPref: Codable, Sendable, Equatable {
	public let items: [AppBskyActorDefsMutedWord]

	public init(
		items: [AppBskyActorDefsMutedWord]
	) {
		self.items = items
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		items = try container.decode([AppBskyActorDefsMutedWord].self, forKey: .items)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(items, forKey: .items)
	}

	private enum CodingKeys: String, CodingKey {
		case items = "items"
	}
}


public enum AppBskyActorDefsMutedWordTarget: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case content = "content"
	case tag = "tag"
}


public struct AppBskyActorDefsNux: Codable, Sendable, Equatable {
	public let completed: Bool
	public let data: String?
	public let expiresAt: ATProtocolDate?
	public let id: String

	public init(
		completed: Bool,
		data: String? = nil,
		expiresAt: ATProtocolDate? = nil,
		id: String
	) {
		self.completed = completed
		self.data = data
		self.expiresAt = expiresAt
		self.id = id
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		completed = try container.decode(Bool.self, forKey: .completed)
		data = try container.decodeIfPresent(String.self, forKey: .data)
		expiresAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .expiresAt)
		id = try container.decode(String.self, forKey: .id)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(completed, forKey: .completed)
		try container.encodeIfPresent(data, forKey: .data)
		try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
		try container.encode(id, forKey: .id)
	}

	private enum CodingKeys: String, CodingKey {
		case completed = "completed"
		case data = "data"
		case expiresAt = "expiresAt"
		case id = "id"
	}
}


public struct AppBskyActorDefsPersonalDetailsPref: Codable, Sendable, Equatable {
	public let birthDate: ATProtocolDate?

	public init(
		birthDate: ATProtocolDate? = nil
	) {
		self.birthDate = birthDate
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		birthDate = try container.decodeIfPresent(ATProtocolDate.self, forKey: .birthDate)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(birthDate, forKey: .birthDate)
	}

	private enum CodingKeys: String, CodingKey {
		case birthDate = "birthDate"
	}
}


public struct AppBskyActorDefsPostInteractionSettingsPref: Codable, Sendable, Equatable {
	public let postgateEmbeddingRules: [AppBskyActorDefsPostInteractionSettingsPrefPostgateEmbeddingRulesItem]?
	public let threadgateAllowRules: [AppBskyActorDefsPostInteractionSettingsPrefThreadgateAllowRulesItem]?

	public init(
		postgateEmbeddingRules: [AppBskyActorDefsPostInteractionSettingsPrefPostgateEmbeddingRulesItem]? = nil,
		threadgateAllowRules: [AppBskyActorDefsPostInteractionSettingsPrefThreadgateAllowRulesItem]? = nil
	) {
		self.postgateEmbeddingRules = postgateEmbeddingRules
		self.threadgateAllowRules = threadgateAllowRules
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		postgateEmbeddingRules = try container.decodeIfPresent([AppBskyActorDefsPostInteractionSettingsPrefPostgateEmbeddingRulesItem].self, forKey: .postgateEmbeddingRules)
		threadgateAllowRules = try container.decodeIfPresent([AppBskyActorDefsPostInteractionSettingsPrefThreadgateAllowRulesItem].self, forKey: .threadgateAllowRules)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(postgateEmbeddingRules, forKey: .postgateEmbeddingRules)
		try container.encodeIfPresent(threadgateAllowRules, forKey: .threadgateAllowRules)
	}

	private enum CodingKeys: String, CodingKey {
		case postgateEmbeddingRules = "postgateEmbeddingRules"
		case threadgateAllowRules = "threadgateAllowRules"
	}
}


public indirect enum AppBskyActorDefsPostInteractionSettingsPrefPostgateEmbeddingRulesItem: Codable, Sendable, Equatable {
	case disableRule(AppBskyFeedPostgateDisableRule)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "app.bsky.feed.postgate#disableRule": self = .disableRule(try AppBskyFeedPostgateDisableRule(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .disableRule(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.feed.postgate#disableRule", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public indirect enum AppBskyActorDefsPostInteractionSettingsPrefThreadgateAllowRulesItem: Codable, Sendable, Equatable {
	case mentionRule(AppBskyFeedThreadgateMentionRule)
	case followerRule(AppBskyFeedThreadgateFollowerRule)
	case followingRule(AppBskyFeedThreadgateFollowingRule)
	case listRule(AppBskyFeedThreadgateListRule)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "app.bsky.feed.threadgate#mentionRule": self = .mentionRule(try AppBskyFeedThreadgateMentionRule(from: decoder))
		case "app.bsky.feed.threadgate#followerRule": self = .followerRule(try AppBskyFeedThreadgateFollowerRule(from: decoder))
		case "app.bsky.feed.threadgate#followingRule": self = .followingRule(try AppBskyFeedThreadgateFollowingRule(from: decoder))
		case "app.bsky.feed.threadgate#listRule": self = .listRule(try AppBskyFeedThreadgateListRule(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .mentionRule(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.feed.threadgate#mentionRule", to: encoder)
		case .followerRule(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.feed.threadgate#followerRule", to: encoder)
		case .followingRule(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.feed.threadgate#followingRule", to: encoder)
		case .listRule(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.feed.threadgate#listRule", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public typealias AppBskyActorDefsPreferences = [AppBskyActorDefsPreferencesItem]


public indirect enum AppBskyActorDefsPreferencesItem: Codable, Sendable, Equatable {
	case adultContentPref(AppBskyActorDefsAdultContentPref)
	case contentLabelPref(AppBskyActorDefsContentLabelPref)
	case savedFeedsPref(AppBskyActorDefsSavedFeedsPref)
	case savedFeedsPrefV2(AppBskyActorDefsSavedFeedsPrefV2)
	case personalDetailsPref(AppBskyActorDefsPersonalDetailsPref)
	case declaredAgePref(AppBskyActorDefsDeclaredAgePref)
	case feedViewPref(AppBskyActorDefsFeedViewPref)
	case threadViewPref(AppBskyActorDefsThreadViewPref)
	case interestsPref(AppBskyActorDefsInterestsPref)
	case mutedWordsPref(AppBskyActorDefsMutedWordsPref)
	case hiddenPostsPref(AppBskyActorDefsHiddenPostsPref)
	case bskyAppStatePref(AppBskyActorDefsBskyAppStatePref)
	case labelersPref(AppBskyActorDefsLabelersPref)
	case postInteractionSettingsPref(AppBskyActorDefsPostInteractionSettingsPref)
	case verificationPrefs(AppBskyActorDefsVerificationPrefs)
	case liveEventPreferences(AppBskyActorDefsLiveEventPreferences)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "app.bsky.actor.defs#adultContentPref": self = .adultContentPref(try AppBskyActorDefsAdultContentPref(from: decoder))
		case "app.bsky.actor.defs#contentLabelPref": self = .contentLabelPref(try AppBskyActorDefsContentLabelPref(from: decoder))
		case "app.bsky.actor.defs#savedFeedsPref": self = .savedFeedsPref(try AppBskyActorDefsSavedFeedsPref(from: decoder))
		case "app.bsky.actor.defs#savedFeedsPrefV2": self = .savedFeedsPrefV2(try AppBskyActorDefsSavedFeedsPrefV2(from: decoder))
		case "app.bsky.actor.defs#personalDetailsPref": self = .personalDetailsPref(try AppBskyActorDefsPersonalDetailsPref(from: decoder))
		case "app.bsky.actor.defs#declaredAgePref": self = .declaredAgePref(try AppBskyActorDefsDeclaredAgePref(from: decoder))
		case "app.bsky.actor.defs#feedViewPref": self = .feedViewPref(try AppBskyActorDefsFeedViewPref(from: decoder))
		case "app.bsky.actor.defs#threadViewPref": self = .threadViewPref(try AppBskyActorDefsThreadViewPref(from: decoder))
		case "app.bsky.actor.defs#interestsPref": self = .interestsPref(try AppBskyActorDefsInterestsPref(from: decoder))
		case "app.bsky.actor.defs#mutedWordsPref": self = .mutedWordsPref(try AppBskyActorDefsMutedWordsPref(from: decoder))
		case "app.bsky.actor.defs#hiddenPostsPref": self = .hiddenPostsPref(try AppBskyActorDefsHiddenPostsPref(from: decoder))
		case "app.bsky.actor.defs#bskyAppStatePref": self = .bskyAppStatePref(try AppBskyActorDefsBskyAppStatePref(from: decoder))
		case "app.bsky.actor.defs#labelersPref": self = .labelersPref(try AppBskyActorDefsLabelersPref(from: decoder))
		case "app.bsky.actor.defs#postInteractionSettingsPref": self = .postInteractionSettingsPref(try AppBskyActorDefsPostInteractionSettingsPref(from: decoder))
		case "app.bsky.actor.defs#verificationPrefs": self = .verificationPrefs(try AppBskyActorDefsVerificationPrefs(from: decoder))
		case "app.bsky.actor.defs#liveEventPreferences": self = .liveEventPreferences(try AppBskyActorDefsLiveEventPreferences(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .adultContentPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#adultContentPref", to: encoder)
		case .contentLabelPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#contentLabelPref", to: encoder)
		case .savedFeedsPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#savedFeedsPref", to: encoder)
		case .savedFeedsPrefV2(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#savedFeedsPrefV2", to: encoder)
		case .personalDetailsPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#personalDetailsPref", to: encoder)
		case .declaredAgePref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#declaredAgePref", to: encoder)
		case .feedViewPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#feedViewPref", to: encoder)
		case .threadViewPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#threadViewPref", to: encoder)
		case .interestsPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#interestsPref", to: encoder)
		case .mutedWordsPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#mutedWordsPref", to: encoder)
		case .hiddenPostsPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#hiddenPostsPref", to: encoder)
		case .bskyAppStatePref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#bskyAppStatePref", to: encoder)
		case .labelersPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#labelersPref", to: encoder)
		case .postInteractionSettingsPref(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#postInteractionSettingsPref", to: encoder)
		case .verificationPrefs(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#verificationPrefs", to: encoder)
		case .liveEventPreferences(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.actor.defs#liveEventPreferences", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct AppBskyActorDefsProfileAssociated: Codable, Sendable, Equatable {
	public let activitySubscription: AppBskyActorDefsProfileAssociatedActivitySubscription?
	public let chat: AppBskyActorDefsProfileAssociatedChat?
	public let feedgens: Int?
	public let germ: AppBskyActorDefsProfileAssociatedGerm?
	public let labeler: Bool?
	public let lists: Int?
	public let starterPacks: Int?

	public init(
		activitySubscription: AppBskyActorDefsProfileAssociatedActivitySubscription? = nil,
		chat: AppBskyActorDefsProfileAssociatedChat? = nil,
		feedgens: Int? = nil,
		germ: AppBskyActorDefsProfileAssociatedGerm? = nil,
		labeler: Bool? = nil,
		lists: Int? = nil,
		starterPacks: Int? = nil
	) {
		self.activitySubscription = activitySubscription
		self.chat = chat
		self.feedgens = feedgens
		self.germ = germ
		self.labeler = labeler
		self.lists = lists
		self.starterPacks = starterPacks
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		activitySubscription = try container.decodeIfPresent(AppBskyActorDefsProfileAssociatedActivitySubscription.self, forKey: .activitySubscription)
		chat = try container.decodeIfPresent(AppBskyActorDefsProfileAssociatedChat.self, forKey: .chat)
		feedgens = try container.decodeIfPresent(Int.self, forKey: .feedgens)
		germ = try container.decodeIfPresent(AppBskyActorDefsProfileAssociatedGerm.self, forKey: .germ)
		labeler = try container.decodeIfPresent(Bool.self, forKey: .labeler)
		lists = try container.decodeIfPresent(Int.self, forKey: .lists)
		starterPacks = try container.decodeIfPresent(Int.self, forKey: .starterPacks)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(activitySubscription, forKey: .activitySubscription)
		try container.encodeIfPresent(chat, forKey: .chat)
		try container.encodeIfPresent(feedgens, forKey: .feedgens)
		try container.encodeIfPresent(germ, forKey: .germ)
		try container.encodeIfPresent(labeler, forKey: .labeler)
		try container.encodeIfPresent(lists, forKey: .lists)
		try container.encodeIfPresent(starterPacks, forKey: .starterPacks)
	}

	private enum CodingKeys: String, CodingKey {
		case activitySubscription = "activitySubscription"
		case chat = "chat"
		case feedgens = "feedgens"
		case germ = "germ"
		case labeler = "labeler"
		case lists = "lists"
		case starterPacks = "starterPacks"
	}
}


public struct AppBskyActorDefsProfileAssociatedActivitySubscription: Codable, Sendable, Equatable {
	public let allowSubscriptions: AppBskyActorDefsProfileAssociatedActivitySubscriptionAllowSubscriptions

	public init(
		allowSubscriptions: AppBskyActorDefsProfileAssociatedActivitySubscriptionAllowSubscriptions
	) {
		self.allowSubscriptions = allowSubscriptions
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		allowSubscriptions = try container.decode(AppBskyActorDefsProfileAssociatedActivitySubscriptionAllowSubscriptions.self, forKey: .allowSubscriptions)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(allowSubscriptions, forKey: .allowSubscriptions)
	}

	private enum CodingKeys: String, CodingKey {
		case allowSubscriptions = "allowSubscriptions"
	}
}


public enum AppBskyActorDefsProfileAssociatedActivitySubscriptionAllowSubscriptions: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case followers = "followers"
	case mutuals = "mutuals"
	case none = "none"
}


public struct AppBskyActorDefsProfileAssociatedChat: Codable, Sendable, Equatable {
	public let allowIncoming: AppBskyActorDefsProfileAssociatedChatAllowIncoming

	public init(
		allowIncoming: AppBskyActorDefsProfileAssociatedChatAllowIncoming
	) {
		self.allowIncoming = allowIncoming
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		allowIncoming = try container.decode(AppBskyActorDefsProfileAssociatedChatAllowIncoming.self, forKey: .allowIncoming)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(allowIncoming, forKey: .allowIncoming)
	}

	private enum CodingKeys: String, CodingKey {
		case allowIncoming = "allowIncoming"
	}
}


public enum AppBskyActorDefsProfileAssociatedChatAllowIncoming: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case all = "all"
	case none = "none"
	case following = "following"
}


public struct AppBskyActorDefsProfileAssociatedGerm: Codable, Sendable, Equatable {
	public let messageMeUrl: String
	public let showButtonTo: AppBskyActorDefsProfileAssociatedGermShowButtonTo

	public init(
		messageMeUrl: String,
		showButtonTo: AppBskyActorDefsProfileAssociatedGermShowButtonTo
	) {
		self.messageMeUrl = messageMeUrl
		self.showButtonTo = showButtonTo
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		messageMeUrl = try container.decode(String.self, forKey: .messageMeUrl)
		showButtonTo = try container.decode(AppBskyActorDefsProfileAssociatedGermShowButtonTo.self, forKey: .showButtonTo)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(messageMeUrl, forKey: .messageMeUrl)
		try container.encode(showButtonTo, forKey: .showButtonTo)
	}

	private enum CodingKeys: String, CodingKey {
		case messageMeUrl = "messageMeUrl"
		case showButtonTo = "showButtonTo"
	}
}


public enum AppBskyActorDefsProfileAssociatedGermShowButtonTo: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case usersIfollow = "usersIFollow"
	case everyone = "everyone"
}


public struct AppBskyActorDefsProfileView: Codable, Sendable, Equatable {
	public let associated: AppBskyActorDefsProfileAssociated?
	public let avatar: String?
	public let createdAt: ATProtocolDate?
	public let debug: ATProtocolValueContainer?
	public let description: String?
	public let did: DID
	public let displayName: String?
	public let handle: Handle
	public let indexedAt: ATProtocolDate?
	public let labels: [ComAtprotoLabelDefsLabel]?
	public let pronouns: String?
	public let status: AppBskyActorDefsStatusView?
	public let verification: AppBskyActorDefsVerificationState?
	public let viewer: AppBskyActorDefsViewerState?

	public init(
		associated: AppBskyActorDefsProfileAssociated? = nil,
		avatar: String? = nil,
		createdAt: ATProtocolDate? = nil,
		debug: ATProtocolValueContainer? = nil,
		description: String? = nil,
		did: DID,
		displayName: String? = nil,
		handle: Handle,
		indexedAt: ATProtocolDate? = nil,
		labels: [ComAtprotoLabelDefsLabel]? = nil,
		pronouns: String? = nil,
		status: AppBskyActorDefsStatusView? = nil,
		verification: AppBskyActorDefsVerificationState? = nil,
		viewer: AppBskyActorDefsViewerState? = nil
	) {
		self.associated = associated
		self.avatar = avatar
		self.createdAt = createdAt
		self.debug = debug
		self.description = description
		self.did = did
		self.displayName = displayName
		self.handle = handle
		self.indexedAt = indexedAt
		self.labels = labels
		self.pronouns = pronouns
		self.status = status
		self.verification = verification
		self.viewer = viewer
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		associated = try container.decodeIfPresent(AppBskyActorDefsProfileAssociated.self, forKey: .associated)
		avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
		createdAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .createdAt)
		debug = try container.decodeIfPresent(ATProtocolValueContainer.self, forKey: .debug)
		description = try container.decodeIfPresent(String.self, forKey: .description)
		did = try container.decode(DID.self, forKey: .did)
		displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
		handle = try container.decode(Handle.self, forKey: .handle)
		indexedAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .indexedAt)
		labels = try container.decodeIfPresent([ComAtprotoLabelDefsLabel].self, forKey: .labels)
		pronouns = try container.decodeIfPresent(String.self, forKey: .pronouns)
		status = try container.decodeIfPresent(AppBskyActorDefsStatusView.self, forKey: .status)
		verification = try container.decodeIfPresent(AppBskyActorDefsVerificationState.self, forKey: .verification)
		viewer = try container.decodeIfPresent(AppBskyActorDefsViewerState.self, forKey: .viewer)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(associated, forKey: .associated)
		try container.encodeIfPresent(avatar, forKey: .avatar)
		try container.encodeIfPresent(createdAt, forKey: .createdAt)
		try container.encodeIfPresent(debug, forKey: .debug)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encode(did, forKey: .did)
		try container.encodeIfPresent(displayName, forKey: .displayName)
		try container.encode(handle, forKey: .handle)
		try container.encodeIfPresent(indexedAt, forKey: .indexedAt)
		try container.encodeIfPresent(labels, forKey: .labels)
		try container.encodeIfPresent(pronouns, forKey: .pronouns)
		try container.encodeIfPresent(status, forKey: .status)
		try container.encodeIfPresent(verification, forKey: .verification)
		try container.encodeIfPresent(viewer, forKey: .viewer)
	}

	private enum CodingKeys: String, CodingKey {
		case associated = "associated"
		case avatar = "avatar"
		case createdAt = "createdAt"
		case debug = "debug"
		case description = "description"
		case did = "did"
		case displayName = "displayName"
		case handle = "handle"
		case indexedAt = "indexedAt"
		case labels = "labels"
		case pronouns = "pronouns"
		case status = "status"
		case verification = "verification"
		case viewer = "viewer"
	}
}


public struct AppBskyActorDefsProfileViewBasic: Codable, Sendable, Equatable {
	public let associated: AppBskyActorDefsProfileAssociated?
	public let avatar: String?
	public let createdAt: ATProtocolDate?
	public let debug: ATProtocolValueContainer?
	public let did: DID
	public let displayName: String?
	public let handle: Handle
	public let labels: [ComAtprotoLabelDefsLabel]?
	public let pronouns: String?
	public let status: AppBskyActorDefsStatusView?
	public let verification: AppBskyActorDefsVerificationState?
	public let viewer: AppBskyActorDefsViewerState?

	public init(
		associated: AppBskyActorDefsProfileAssociated? = nil,
		avatar: String? = nil,
		createdAt: ATProtocolDate? = nil,
		debug: ATProtocolValueContainer? = nil,
		did: DID,
		displayName: String? = nil,
		handle: Handle,
		labels: [ComAtprotoLabelDefsLabel]? = nil,
		pronouns: String? = nil,
		status: AppBskyActorDefsStatusView? = nil,
		verification: AppBskyActorDefsVerificationState? = nil,
		viewer: AppBskyActorDefsViewerState? = nil
	) {
		self.associated = associated
		self.avatar = avatar
		self.createdAt = createdAt
		self.debug = debug
		self.did = did
		self.displayName = displayName
		self.handle = handle
		self.labels = labels
		self.pronouns = pronouns
		self.status = status
		self.verification = verification
		self.viewer = viewer
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		associated = try container.decodeIfPresent(AppBskyActorDefsProfileAssociated.self, forKey: .associated)
		avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
		createdAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .createdAt)
		debug = try container.decodeIfPresent(ATProtocolValueContainer.self, forKey: .debug)
		did = try container.decode(DID.self, forKey: .did)
		displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
		handle = try container.decode(Handle.self, forKey: .handle)
		labels = try container.decodeIfPresent([ComAtprotoLabelDefsLabel].self, forKey: .labels)
		pronouns = try container.decodeIfPresent(String.self, forKey: .pronouns)
		status = try container.decodeIfPresent(AppBskyActorDefsStatusView.self, forKey: .status)
		verification = try container.decodeIfPresent(AppBskyActorDefsVerificationState.self, forKey: .verification)
		viewer = try container.decodeIfPresent(AppBskyActorDefsViewerState.self, forKey: .viewer)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(associated, forKey: .associated)
		try container.encodeIfPresent(avatar, forKey: .avatar)
		try container.encodeIfPresent(createdAt, forKey: .createdAt)
		try container.encodeIfPresent(debug, forKey: .debug)
		try container.encode(did, forKey: .did)
		try container.encodeIfPresent(displayName, forKey: .displayName)
		try container.encode(handle, forKey: .handle)
		try container.encodeIfPresent(labels, forKey: .labels)
		try container.encodeIfPresent(pronouns, forKey: .pronouns)
		try container.encodeIfPresent(status, forKey: .status)
		try container.encodeIfPresent(verification, forKey: .verification)
		try container.encodeIfPresent(viewer, forKey: .viewer)
	}

	private enum CodingKeys: String, CodingKey {
		case associated = "associated"
		case avatar = "avatar"
		case createdAt = "createdAt"
		case debug = "debug"
		case did = "did"
		case displayName = "displayName"
		case handle = "handle"
		case labels = "labels"
		case pronouns = "pronouns"
		case status = "status"
		case verification = "verification"
		case viewer = "viewer"
	}
}


public struct AppBskyActorDefsProfileViewDetailed: Codable, Sendable, Equatable {
	public let associated: AppBskyActorDefsProfileAssociated?
	public let avatar: String?
	public let banner: String?
	public let createdAt: ATProtocolDate?
	public let debug: ATProtocolValueContainer?
	public let description: String?
	public let did: DID
	public let displayName: String?
	public let followersCount: Int?
	public let followsCount: Int?
	public let handle: Handle
	public let indexedAt: ATProtocolDate?
	public let joinedViaStarterPack: AppBskyGraphDefsStarterPackViewBasic?
	public let labels: [ComAtprotoLabelDefsLabel]?
	public let pinnedPost: ComAtprotoRepoStrongRef?
	public let postsCount: Int?
	public let pronouns: String?
	public let status: AppBskyActorDefsStatusView?
	public let verification: AppBskyActorDefsVerificationState?
	public let viewer: AppBskyActorDefsViewerState?
	public let website: String?

	public init(
		associated: AppBskyActorDefsProfileAssociated? = nil,
		avatar: String? = nil,
		banner: String? = nil,
		createdAt: ATProtocolDate? = nil,
		debug: ATProtocolValueContainer? = nil,
		description: String? = nil,
		did: DID,
		displayName: String? = nil,
		followersCount: Int? = nil,
		followsCount: Int? = nil,
		handle: Handle,
		indexedAt: ATProtocolDate? = nil,
		joinedViaStarterPack: AppBskyGraphDefsStarterPackViewBasic? = nil,
		labels: [ComAtprotoLabelDefsLabel]? = nil,
		pinnedPost: ComAtprotoRepoStrongRef? = nil,
		postsCount: Int? = nil,
		pronouns: String? = nil,
		status: AppBskyActorDefsStatusView? = nil,
		verification: AppBskyActorDefsVerificationState? = nil,
		viewer: AppBskyActorDefsViewerState? = nil,
		website: String? = nil
	) {
		self.associated = associated
		self.avatar = avatar
		self.banner = banner
		self.createdAt = createdAt
		self.debug = debug
		self.description = description
		self.did = did
		self.displayName = displayName
		self.followersCount = followersCount
		self.followsCount = followsCount
		self.handle = handle
		self.indexedAt = indexedAt
		self.joinedViaStarterPack = joinedViaStarterPack
		self.labels = labels
		self.pinnedPost = pinnedPost
		self.postsCount = postsCount
		self.pronouns = pronouns
		self.status = status
		self.verification = verification
		self.viewer = viewer
		self.website = website
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		associated = try container.decodeIfPresent(AppBskyActorDefsProfileAssociated.self, forKey: .associated)
		avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
		banner = try container.decodeIfPresent(String.self, forKey: .banner)
		createdAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .createdAt)
		debug = try container.decodeIfPresent(ATProtocolValueContainer.self, forKey: .debug)
		description = try container.decodeIfPresent(String.self, forKey: .description)
		did = try container.decode(DID.self, forKey: .did)
		displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
		followersCount = try container.decodeIfPresent(Int.self, forKey: .followersCount)
		followsCount = try container.decodeIfPresent(Int.self, forKey: .followsCount)
		handle = try container.decode(Handle.self, forKey: .handle)
		indexedAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .indexedAt)
		joinedViaStarterPack = try container.decodeIfPresent(AppBskyGraphDefsStarterPackViewBasic.self, forKey: .joinedViaStarterPack)
		labels = try container.decodeIfPresent([ComAtprotoLabelDefsLabel].self, forKey: .labels)
		pinnedPost = try container.decodeIfPresent(ComAtprotoRepoStrongRef.self, forKey: .pinnedPost)
		postsCount = try container.decodeIfPresent(Int.self, forKey: .postsCount)
		pronouns = try container.decodeIfPresent(String.self, forKey: .pronouns)
		status = try container.decodeIfPresent(AppBskyActorDefsStatusView.self, forKey: .status)
		verification = try container.decodeIfPresent(AppBskyActorDefsVerificationState.self, forKey: .verification)
		viewer = try container.decodeIfPresent(AppBskyActorDefsViewerState.self, forKey: .viewer)
		website = try container.decodeIfPresent(String.self, forKey: .website)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(associated, forKey: .associated)
		try container.encodeIfPresent(avatar, forKey: .avatar)
		try container.encodeIfPresent(banner, forKey: .banner)
		try container.encodeIfPresent(createdAt, forKey: .createdAt)
		try container.encodeIfPresent(debug, forKey: .debug)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encode(did, forKey: .did)
		try container.encodeIfPresent(displayName, forKey: .displayName)
		try container.encodeIfPresent(followersCount, forKey: .followersCount)
		try container.encodeIfPresent(followsCount, forKey: .followsCount)
		try container.encode(handle, forKey: .handle)
		try container.encodeIfPresent(indexedAt, forKey: .indexedAt)
		try container.encodeIfPresent(joinedViaStarterPack, forKey: .joinedViaStarterPack)
		try container.encodeIfPresent(labels, forKey: .labels)
		try container.encodeIfPresent(pinnedPost, forKey: .pinnedPost)
		try container.encodeIfPresent(postsCount, forKey: .postsCount)
		try container.encodeIfPresent(pronouns, forKey: .pronouns)
		try container.encodeIfPresent(status, forKey: .status)
		try container.encodeIfPresent(verification, forKey: .verification)
		try container.encodeIfPresent(viewer, forKey: .viewer)
		try container.encodeIfPresent(website, forKey: .website)
	}

	private enum CodingKeys: String, CodingKey {
		case associated = "associated"
		case avatar = "avatar"
		case banner = "banner"
		case createdAt = "createdAt"
		case debug = "debug"
		case description = "description"
		case did = "did"
		case displayName = "displayName"
		case followersCount = "followersCount"
		case followsCount = "followsCount"
		case handle = "handle"
		case indexedAt = "indexedAt"
		case joinedViaStarterPack = "joinedViaStarterPack"
		case labels = "labels"
		case pinnedPost = "pinnedPost"
		case postsCount = "postsCount"
		case pronouns = "pronouns"
		case status = "status"
		case verification = "verification"
		case viewer = "viewer"
		case website = "website"
	}
}


public struct AppBskyActorDefsSavedFeed: Codable, Sendable, Equatable {
	public let id: String
	public let pinned: Bool
	public let type: AppBskyActorDefsSavedFeedType
	public let value: String

	public init(
		id: String,
		pinned: Bool,
		type: AppBskyActorDefsSavedFeedType,
		value: String
	) {
		self.id = id
		self.pinned = pinned
		self.type = type
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(String.self, forKey: .id)
		pinned = try container.decode(Bool.self, forKey: .pinned)
		type = try container.decode(AppBskyActorDefsSavedFeedType.self, forKey: .type)
		value = try container.decode(String.self, forKey: .value)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(pinned, forKey: .pinned)
		try container.encode(type, forKey: .type)
		try container.encode(value, forKey: .value)
	}

	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case pinned = "pinned"
		case type = "type"
		case value = "value"
	}
}


public struct AppBskyActorDefsSavedFeedsPref: Codable, Sendable, Equatable {
	public let pinned: [ATURI]
	public let saved: [ATURI]
	public let timelineIndex: Int?

	public init(
		pinned: [ATURI],
		saved: [ATURI],
		timelineIndex: Int? = nil
	) {
		self.pinned = pinned
		self.saved = saved
		self.timelineIndex = timelineIndex
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		pinned = try container.decode([ATURI].self, forKey: .pinned)
		saved = try container.decode([ATURI].self, forKey: .saved)
		timelineIndex = try container.decodeIfPresent(Int.self, forKey: .timelineIndex)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(pinned, forKey: .pinned)
		try container.encode(saved, forKey: .saved)
		try container.encodeIfPresent(timelineIndex, forKey: .timelineIndex)
	}

	private enum CodingKeys: String, CodingKey {
		case pinned = "pinned"
		case saved = "saved"
		case timelineIndex = "timelineIndex"
	}
}


public struct AppBskyActorDefsSavedFeedsPrefV2: Codable, Sendable, Equatable {
	public let items: [AppBskyActorDefsSavedFeed]

	public init(
		items: [AppBskyActorDefsSavedFeed]
	) {
		self.items = items
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		items = try container.decode([AppBskyActorDefsSavedFeed].self, forKey: .items)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(items, forKey: .items)
	}

	private enum CodingKeys: String, CodingKey {
		case items = "items"
	}
}


public enum AppBskyActorDefsSavedFeedType: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case feed = "feed"
	case list = "list"
	case timeline = "timeline"
}


public struct AppBskyActorDefsStatusView: Codable, Sendable, Equatable {
	public let cid: CID?
	public let embed: AppBskyActorDefsStatusViewEmbed?
	public let expiresAt: ATProtocolDate?
	public let isActive: Bool?
	public let isDisabled: Bool?
	public let record: ATProtocolValueContainer
	public let status: AppBskyActorDefsStatusViewStatus
	public let uri: ATURI?

	public init(
		cid: CID? = nil,
		embed: AppBskyActorDefsStatusViewEmbed? = nil,
		expiresAt: ATProtocolDate? = nil,
		isActive: Bool? = nil,
		isDisabled: Bool? = nil,
		record: ATProtocolValueContainer,
		status: AppBskyActorDefsStatusViewStatus,
		uri: ATURI? = nil
	) {
		self.cid = cid
		self.embed = embed
		self.expiresAt = expiresAt
		self.isActive = isActive
		self.isDisabled = isDisabled
		self.record = record
		self.status = status
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decodeIfPresent(CID.self, forKey: .cid)
		embed = try container.decodeIfPresent(AppBskyActorDefsStatusViewEmbed.self, forKey: .embed)
		expiresAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .expiresAt)
		isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)
		isDisabled = try container.decodeIfPresent(Bool.self, forKey: .isDisabled)
		record = try container.decode(ATProtocolValueContainer.self, forKey: .record)
		status = try container.decode(AppBskyActorDefsStatusViewStatus.self, forKey: .status)
		uri = try container.decodeIfPresent(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cid, forKey: .cid)
		try container.encodeIfPresent(embed, forKey: .embed)
		try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
		try container.encodeIfPresent(isActive, forKey: .isActive)
		try container.encodeIfPresent(isDisabled, forKey: .isDisabled)
		try container.encode(record, forKey: .record)
		try container.encode(status, forKey: .status)
		try container.encodeIfPresent(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case embed = "embed"
		case expiresAt = "expiresAt"
		case isActive = "isActive"
		case isDisabled = "isDisabled"
		case record = "record"
		case status = "status"
		case uri = "uri"
	}
}


public indirect enum AppBskyActorDefsStatusViewEmbed: Codable, Sendable, Equatable {
	case view(AppBskyEmbedExternalView)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "app.bsky.embed.external#view": self = .view(try AppBskyEmbedExternalView(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .view(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.embed.external#view", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public enum AppBskyActorDefsStatusViewStatus: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case appBskyActorStatusLive = "app.bsky.actor.status#live"
}


public struct AppBskyActorDefsThreadViewPref: Codable, Sendable, Equatable {
	public let sort: AppBskyActorDefsThreadViewPrefSort?

	public init(
		sort: AppBskyActorDefsThreadViewPrefSort? = nil
	) {
		self.sort = sort
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		sort = try container.decodeIfPresent(AppBskyActorDefsThreadViewPrefSort.self, forKey: .sort)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(sort, forKey: .sort)
	}

	private enum CodingKeys: String, CodingKey {
		case sort = "sort"
	}
}


public enum AppBskyActorDefsThreadViewPrefSort: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case oldest = "oldest"
	case newest = "newest"
	case mostLikes = "most-likes"
	case random = "random"
	case hotness = "hotness"
}


public struct AppBskyActorDefsVerificationPrefs: Codable, Sendable, Equatable {
	public let hideBadges: Bool?

	public init(
		hideBadges: Bool? = nil
	) {
		self.hideBadges = hideBadges
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		hideBadges = try container.decodeIfPresent(Bool.self, forKey: .hideBadges)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(hideBadges, forKey: .hideBadges)
	}

	private enum CodingKeys: String, CodingKey {
		case hideBadges = "hideBadges"
	}
}


public struct AppBskyActorDefsVerificationState: Codable, Sendable, Equatable {
	public let trustedVerifierStatus: AppBskyActorDefsVerificationStateTrustedVerifierStatus
	public let verifications: [AppBskyActorDefsVerificationView]
	public let verifiedStatus: AppBskyActorDefsVerificationStateTrustedVerifierStatus

	public init(
		trustedVerifierStatus: AppBskyActorDefsVerificationStateTrustedVerifierStatus,
		verifications: [AppBskyActorDefsVerificationView],
		verifiedStatus: AppBskyActorDefsVerificationStateTrustedVerifierStatus
	) {
		self.trustedVerifierStatus = trustedVerifierStatus
		self.verifications = verifications
		self.verifiedStatus = verifiedStatus
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		trustedVerifierStatus = try container.decode(AppBskyActorDefsVerificationStateTrustedVerifierStatus.self, forKey: .trustedVerifierStatus)
		verifications = try container.decode([AppBskyActorDefsVerificationView].self, forKey: .verifications)
		verifiedStatus = try container.decode(AppBskyActorDefsVerificationStateTrustedVerifierStatus.self, forKey: .verifiedStatus)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(trustedVerifierStatus, forKey: .trustedVerifierStatus)
		try container.encode(verifications, forKey: .verifications)
		try container.encode(verifiedStatus, forKey: .verifiedStatus)
	}

	private enum CodingKeys: String, CodingKey {
		case trustedVerifierStatus = "trustedVerifierStatus"
		case verifications = "verifications"
		case verifiedStatus = "verifiedStatus"
	}
}


public enum AppBskyActorDefsVerificationStateTrustedVerifierStatus: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case valid = "valid"
	case invalid = "invalid"
	case none = "none"
}


public struct AppBskyActorDefsVerificationView: Codable, Sendable, Equatable {
	public let createdAt: ATProtocolDate
	public let isValid: Bool
	public let issuer: DID
	public let uri: ATURI

	public init(
		createdAt: ATProtocolDate,
		isValid: Bool,
		issuer: DID,
		uri: ATURI
	) {
		self.createdAt = createdAt
		self.isValid = isValid
		self.issuer = issuer
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		isValid = try container.decode(Bool.self, forKey: .isValid)
		issuer = try container.decode(DID.self, forKey: .issuer)
		uri = try container.decode(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encode(isValid, forKey: .isValid)
		try container.encode(issuer, forKey: .issuer)
		try container.encode(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case createdAt = "createdAt"
		case isValid = "isValid"
		case issuer = "issuer"
		case uri = "uri"
	}
}


public struct AppBskyActorDefsViewerState: Codable, Sendable, Equatable {
	public let activitySubscription: AppBskyNotificationDefsActivitySubscription?
	public let blockedBy: Bool?
	public let blocking: ATURI?
	public let blockingByList: AppBskyGraphDefsListViewBasic?
	public let followedBy: ATURI?
	public let following: ATURI?
	public let knownFollowers: AppBskyActorDefsKnownFollowers?
	public let muted: Bool?
	public let mutedByList: AppBskyGraphDefsListViewBasic?

	public init(
		activitySubscription: AppBskyNotificationDefsActivitySubscription? = nil,
		blockedBy: Bool? = nil,
		blocking: ATURI? = nil,
		blockingByList: AppBskyGraphDefsListViewBasic? = nil,
		followedBy: ATURI? = nil,
		following: ATURI? = nil,
		knownFollowers: AppBskyActorDefsKnownFollowers? = nil,
		muted: Bool? = nil,
		mutedByList: AppBskyGraphDefsListViewBasic? = nil
	) {
		self.activitySubscription = activitySubscription
		self.blockedBy = blockedBy
		self.blocking = blocking
		self.blockingByList = blockingByList
		self.followedBy = followedBy
		self.following = following
		self.knownFollowers = knownFollowers
		self.muted = muted
		self.mutedByList = mutedByList
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		activitySubscription = try container.decodeIfPresent(AppBskyNotificationDefsActivitySubscription.self, forKey: .activitySubscription)
		blockedBy = try container.decodeIfPresent(Bool.self, forKey: .blockedBy)
		blocking = try container.decodeIfPresent(ATURI.self, forKey: .blocking)
		blockingByList = try container.decodeIfPresent(AppBskyGraphDefsListViewBasic.self, forKey: .blockingByList)
		followedBy = try container.decodeIfPresent(ATURI.self, forKey: .followedBy)
		following = try container.decodeIfPresent(ATURI.self, forKey: .following)
		knownFollowers = try container.decodeIfPresent(AppBskyActorDefsKnownFollowers.self, forKey: .knownFollowers)
		muted = try container.decodeIfPresent(Bool.self, forKey: .muted)
		mutedByList = try container.decodeIfPresent(AppBskyGraphDefsListViewBasic.self, forKey: .mutedByList)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(activitySubscription, forKey: .activitySubscription)
		try container.encodeIfPresent(blockedBy, forKey: .blockedBy)
		try container.encodeIfPresent(blocking, forKey: .blocking)
		try container.encodeIfPresent(blockingByList, forKey: .blockingByList)
		try container.encodeIfPresent(followedBy, forKey: .followedBy)
		try container.encodeIfPresent(following, forKey: .following)
		try container.encodeIfPresent(knownFollowers, forKey: .knownFollowers)
		try container.encodeIfPresent(muted, forKey: .muted)
		try container.encodeIfPresent(mutedByList, forKey: .mutedByList)
	}

	private enum CodingKeys: String, CodingKey {
		case activitySubscription = "activitySubscription"
		case blockedBy = "blockedBy"
		case blocking = "blocking"
		case blockingByList = "blockingByList"
		case followedBy = "followedBy"
		case following = "following"
		case knownFollowers = "knownFollowers"
		case muted = "muted"
		case mutedByList = "mutedByList"
	}
}


public struct AppBskyActorGetPreferencesOutput: Codable, Sendable, Equatable {
	public let preferences: AppBskyActorDefsPreferences

	public init(
		preferences: AppBskyActorDefsPreferences
	) {
		self.preferences = preferences
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		preferences = try container.decode(AppBskyActorDefsPreferences.self, forKey: .preferences)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(preferences, forKey: .preferences)
	}

	private enum CodingKeys: String, CodingKey {
		case preferences = "preferences"
	}
}


public struct AppBskyActorGetPreferencesParameters: Codable, Sendable, Equatable {

	public init() {}

	public init(from decoder: Decoder) throws {
		_ = try decoder.container(keyedBy: CodingKeys.self)
	}

	public func encode(to encoder: Encoder) throws {
		_ = encoder.container(keyedBy: CodingKeys.self)
	}

	public func asQueryItems() -> [URLQueryItem] {
		[]
	}

	private struct CodingKeys: CodingKey {
		let stringValue = ""
		init?(stringValue: String) {
			return nil
		}

		let intValue: Int? = nil
		init?(intValue: Int) {
			return nil
		}
	}
}


public typealias AppBskyActorGetProfileOutput = AppBskyActorDefsProfileViewDetailed


public struct AppBskyActorGetProfileParameters: Codable, Sendable, Equatable {
	public let actor: ATIdentifier

	public init(
		actor: ATIdentifier
	) {
		self.actor = actor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(ATIdentifier.self, forKey: .actor)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		actor.appendQueryItems(named: "actor", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
	}
}


public struct AppBskyActorGetProfilesOutput: Codable, Sendable, Equatable {
	public let profiles: [AppBskyActorDefsProfileViewDetailed]

	public init(
		profiles: [AppBskyActorDefsProfileViewDetailed]
	) {
		self.profiles = profiles
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		profiles = try container.decode([AppBskyActorDefsProfileViewDetailed].self, forKey: .profiles)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(profiles, forKey: .profiles)
	}

	private enum CodingKeys: String, CodingKey {
		case profiles = "profiles"
	}
}


public struct AppBskyActorGetProfilesParameters: Codable, Sendable, Equatable {
	public let actors: [ATIdentifier]

	public init(
		actors: [ATIdentifier]
	) {
		self.actors = actors
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actors = try container.decode([ATIdentifier].self, forKey: .actors)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actors, forKey: .actors)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		actors.appendQueryItems(named: "actors", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case actors = "actors"
	}
}


public struct AppBskyActorGetSuggestionsOutput: Codable, Sendable, Equatable {
	public let actors: [AppBskyActorDefsProfileView]
	public let cursor: String?
	public let recId: Int?
	public let recIdStr: String?

	public init(
		actors: [AppBskyActorDefsProfileView],
		cursor: String? = nil,
		recId: Int? = nil,
		recIdStr: String? = nil
	) {
		self.actors = actors
		self.cursor = cursor
		self.recId = recId
		self.recIdStr = recIdStr
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actors = try container.decode([AppBskyActorDefsProfileView].self, forKey: .actors)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		recId = try container.decodeIfPresent(Int.self, forKey: .recId)
		recIdStr = try container.decodeIfPresent(String.self, forKey: .recIdStr)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actors, forKey: .actors)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(recId, forKey: .recId)
		try container.encodeIfPresent(recIdStr, forKey: .recIdStr)
	}

	private enum CodingKeys: String, CodingKey {
		case actors = "actors"
		case cursor = "cursor"
		case recId = "recId"
		case recIdStr = "recIdStr"
	}
}


public struct AppBskyActorGetSuggestionsParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?

	public init(
		cursor: String? = nil,
		limit: Int? = nil
	) {
		self.cursor = cursor
		self.limit = limit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
	}
}


public struct AppBskyActorProfile: Codable, Sendable, Equatable {
	public static let typeIdentifier = "app.bsky.actor.profile"

	public let avatar: Blob?
	public let banner: Blob?
	public let createdAt: ATProtocolDate?
	public let description: String?
	public let displayName: String?
	public let joinedViaStarterPack: ComAtprotoRepoStrongRef?
	public let labels: AppBskyActorProfileLabels?
	public let pinnedPost: ComAtprotoRepoStrongRef?
	public let pronouns: String?
	public let website: String?

	public init(
		avatar: Blob? = nil,
		banner: Blob? = nil,
		createdAt: ATProtocolDate? = nil,
		description: String? = nil,
		displayName: String? = nil,
		joinedViaStarterPack: ComAtprotoRepoStrongRef? = nil,
		labels: AppBskyActorProfileLabels? = nil,
		pinnedPost: ComAtprotoRepoStrongRef? = nil,
		pronouns: String? = nil,
		website: String? = nil
	) {
		self.avatar = avatar
		self.banner = banner
		self.createdAt = createdAt
		self.description = description
		self.displayName = displayName
		self.joinedViaStarterPack = joinedViaStarterPack
		self.labels = labels
		self.pinnedPost = pinnedPost
		self.pronouns = pronouns
		self.website = website
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		avatar = try container.decodeIfPresent(Blob.self, forKey: .avatar)
		banner = try container.decodeIfPresent(Blob.self, forKey: .banner)
		createdAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .createdAt)
		description = try container.decodeIfPresent(String.self, forKey: .description)
		displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
		joinedViaStarterPack = try container.decodeIfPresent(ComAtprotoRepoStrongRef.self, forKey: .joinedViaStarterPack)
		labels = try container.decodeIfPresent(AppBskyActorProfileLabels.self, forKey: .labels)
		pinnedPost = try container.decodeIfPresent(ComAtprotoRepoStrongRef.self, forKey: .pinnedPost)
		pronouns = try container.decodeIfPresent(String.self, forKey: .pronouns)
		website = try container.decodeIfPresent(String.self, forKey: .website)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.typeIdentifier, forKey: .typeIdentifier)
		try container.encodeIfPresent(avatar, forKey: .avatar)
		try container.encodeIfPresent(banner, forKey: .banner)
		try container.encodeIfPresent(createdAt, forKey: .createdAt)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encodeIfPresent(displayName, forKey: .displayName)
		try container.encodeIfPresent(joinedViaStarterPack, forKey: .joinedViaStarterPack)
		try container.encodeIfPresent(labels, forKey: .labels)
		try container.encodeIfPresent(pinnedPost, forKey: .pinnedPost)
		try container.encodeIfPresent(pronouns, forKey: .pronouns)
		try container.encodeIfPresent(website, forKey: .website)
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case avatar = "avatar"
		case banner = "banner"
		case createdAt = "createdAt"
		case description = "description"
		case displayName = "displayName"
		case joinedViaStarterPack = "joinedViaStarterPack"
		case labels = "labels"
		case pinnedPost = "pinnedPost"
		case pronouns = "pronouns"
		case website = "website"
	}
}


public indirect enum AppBskyActorProfileLabels: Codable, Sendable, Equatable {
	case selfLabels(ComAtprotoLabelDefsSelfLabels)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "com.atproto.label.defs#selfLabels": self = .selfLabels(try ComAtprotoLabelDefsSelfLabels(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .selfLabels(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "com.atproto.label.defs#selfLabels", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct AppBskyActorPutPreferencesInput: Codable, Sendable, Equatable {
	public let preferences: AppBskyActorDefsPreferences

	public init(
		preferences: AppBskyActorDefsPreferences
	) {
		self.preferences = preferences
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		preferences = try container.decode(AppBskyActorDefsPreferences.self, forKey: .preferences)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(preferences, forKey: .preferences)
	}

	private enum CodingKeys: String, CodingKey {
		case preferences = "preferences"
	}
}


public struct AppBskyActorSearchActorsOutput: Codable, Sendable, Equatable {
	public let actors: [AppBskyActorDefsProfileView]
	public let cursor: String?

	public init(
		actors: [AppBskyActorDefsProfileView],
		cursor: String? = nil
	) {
		self.actors = actors
		self.cursor = cursor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actors = try container.decode([AppBskyActorDefsProfileView].self, forKey: .actors)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actors, forKey: .actors)
		try container.encodeIfPresent(cursor, forKey: .cursor)
	}

	private enum CodingKeys: String, CodingKey {
		case actors = "actors"
		case cursor = "cursor"
	}
}


public struct AppBskyActorSearchActorsParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?
	public let q: String?
	public let term: String?

	public init(
		cursor: String? = nil,
		limit: Int? = nil,
		q: String? = nil,
		term: String? = nil
	) {
		self.cursor = cursor
		self.limit = limit
		self.q = q
		self.term = term
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		q = try container.decodeIfPresent(String.self, forKey: .q)
		term = try container.decodeIfPresent(String.self, forKey: .term)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encodeIfPresent(q, forKey: .q)
		try container.encodeIfPresent(term, forKey: .term)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		if let value = q {
			value.appendQueryItems(named: "q", to: &items)
		}
		if let value = term {
			value.appendQueryItems(named: "term", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
		case q = "q"
		case term = "term"
	}
}


public struct AppBskyActorSearchActorsTypeaheadOutput: Codable, Sendable, Equatable {
	public let actors: [AppBskyActorDefsProfileViewBasic]

	public init(
		actors: [AppBskyActorDefsProfileViewBasic]
	) {
		self.actors = actors
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actors = try container.decode([AppBskyActorDefsProfileViewBasic].self, forKey: .actors)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actors, forKey: .actors)
	}

	private enum CodingKeys: String, CodingKey {
		case actors = "actors"
	}
}


public struct AppBskyActorSearchActorsTypeaheadParameters: Codable, Sendable, Equatable {
	public let limit: Int?
	public let q: String?
	public let term: String?

	public init(
		limit: Int? = nil,
		q: String? = nil,
		term: String? = nil
	) {
		self.limit = limit
		self.q = q
		self.term = term
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		q = try container.decodeIfPresent(String.self, forKey: .q)
		term = try container.decodeIfPresent(String.self, forKey: .term)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encodeIfPresent(q, forKey: .q)
		try container.encodeIfPresent(term, forKey: .term)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		if let value = q {
			value.appendQueryItems(named: "q", to: &items)
		}
		if let value = term {
			value.appendQueryItems(named: "term", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case limit = "limit"
		case q = "q"
		case term = "term"
	}
}


public struct AppBskyActorStatus: Codable, Sendable, Equatable {
	public static let typeIdentifier = "app.bsky.actor.status"

	public let createdAt: ATProtocolDate
	public let durationMinutes: Int?
	public let embed: AppBskyActorStatusEmbed?
	public let status: AppBskyActorDefsStatusViewStatus

	public init(
		createdAt: ATProtocolDate,
		durationMinutes: Int? = nil,
		embed: AppBskyActorStatusEmbed? = nil,
		status: AppBskyActorDefsStatusViewStatus
	) {
		self.createdAt = createdAt
		self.durationMinutes = durationMinutes
		self.embed = embed
		self.status = status
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		durationMinutes = try container.decodeIfPresent(Int.self, forKey: .durationMinutes)
		embed = try container.decodeIfPresent(AppBskyActorStatusEmbed.self, forKey: .embed)
		status = try container.decode(AppBskyActorDefsStatusViewStatus.self, forKey: .status)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.typeIdentifier, forKey: .typeIdentifier)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encodeIfPresent(durationMinutes, forKey: .durationMinutes)
		try container.encodeIfPresent(embed, forKey: .embed)
		try container.encode(status, forKey: .status)
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case createdAt = "createdAt"
		case durationMinutes = "durationMinutes"
		case embed = "embed"
		case status = "status"
	}
}


public indirect enum AppBskyActorStatusEmbed: Codable, Sendable, Equatable {
	case external(AppBskyEmbedExternal)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "app.bsky.embed.external": self = .external(try AppBskyEmbedExternal(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .external(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.embed.external", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public typealias AppBskyActorStatusLive = String


