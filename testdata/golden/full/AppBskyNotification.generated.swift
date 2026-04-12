import Foundation


public struct AppBskyNotificationDeclaration: Codable, Sendable, Equatable {
	public static let typeIdentifier = "app.bsky.notification.declaration"

	public let allowSubscriptions: AppBskyNotificationDeclarationAllowSubscriptions

	public init(
		allowSubscriptions: AppBskyNotificationDeclarationAllowSubscriptions
	) {
		self.allowSubscriptions = allowSubscriptions
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		allowSubscriptions = try container.decode(AppBskyNotificationDeclarationAllowSubscriptions.self, forKey: .allowSubscriptions)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.typeIdentifier, forKey: .typeIdentifier)
		try container.encode(allowSubscriptions, forKey: .allowSubscriptions)
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case allowSubscriptions = "allowSubscriptions"
	}
}


public enum AppBskyNotificationDeclarationAllowSubscriptions: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case followers = "followers"
	case mutuals = "mutuals"
	case none = "none"
}


public struct AppBskyNotificationDefsActivitySubscription: Codable, Sendable, Equatable {
	public let post: Bool
	public let reply: Bool

	public init(
		post: Bool,
		reply: Bool
	) {
		self.post = post
		self.reply = reply
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		post = try container.decode(Bool.self, forKey: .post)
		reply = try container.decode(Bool.self, forKey: .reply)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(post, forKey: .post)
		try container.encode(reply, forKey: .reply)
	}

	private enum CodingKeys: String, CodingKey {
		case post = "post"
		case reply = "reply"
	}
}


public struct AppBskyNotificationDefsChatPreference: Codable, Sendable, Equatable {
	public let include: AppBskyNotificationDefsChatPreferenceInclude
	public let push: Bool

	public init(
		include: AppBskyNotificationDefsChatPreferenceInclude,
		push: Bool
	) {
		self.include = include
		self.push = push
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		include = try container.decode(AppBskyNotificationDefsChatPreferenceInclude.self, forKey: .include)
		push = try container.decode(Bool.self, forKey: .push)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(include, forKey: .include)
		try container.encode(push, forKey: .push)
	}

	private enum CodingKeys: String, CodingKey {
		case include = "include"
		case push = "push"
	}
}


public enum AppBskyNotificationDefsChatPreferenceInclude: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case all = "all"
	case accepted = "accepted"
}


public struct AppBskyNotificationDefsFilterablePreference: Codable, Sendable, Equatable {
	public let include: AppBskyNotificationDefsFilterablePreferenceInclude
	public let list: Bool
	public let push: Bool

	public init(
		include: AppBskyNotificationDefsFilterablePreferenceInclude,
		list: Bool,
		push: Bool
	) {
		self.include = include
		self.list = list
		self.push = push
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		include = try container.decode(AppBskyNotificationDefsFilterablePreferenceInclude.self, forKey: .include)
		list = try container.decode(Bool.self, forKey: .list)
		push = try container.decode(Bool.self, forKey: .push)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(include, forKey: .include)
		try container.encode(list, forKey: .list)
		try container.encode(push, forKey: .push)
	}

	private enum CodingKeys: String, CodingKey {
		case include = "include"
		case list = "list"
		case push = "push"
	}
}


public enum AppBskyNotificationDefsFilterablePreferenceInclude: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case all = "all"
	case follows = "follows"
}


public struct AppBskyNotificationDefsPreference: Codable, Sendable, Equatable {
	public let list: Bool
	public let push: Bool

	public init(
		list: Bool,
		push: Bool
	) {
		self.list = list
		self.push = push
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		list = try container.decode(Bool.self, forKey: .list)
		push = try container.decode(Bool.self, forKey: .push)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(list, forKey: .list)
		try container.encode(push, forKey: .push)
	}

	private enum CodingKeys: String, CodingKey {
		case list = "list"
		case push = "push"
	}
}


public struct AppBskyNotificationDefsPreferences: Codable, Sendable, Equatable {
	public let chat: AppBskyNotificationDefsChatPreference
	public let follow: AppBskyNotificationDefsFilterablePreference
	public let like: AppBskyNotificationDefsFilterablePreference
	public let likeViaRepost: AppBskyNotificationDefsFilterablePreference
	public let mention: AppBskyNotificationDefsFilterablePreference
	public let quote: AppBskyNotificationDefsFilterablePreference
	public let reply: AppBskyNotificationDefsFilterablePreference
	public let repost: AppBskyNotificationDefsFilterablePreference
	public let repostViaRepost: AppBskyNotificationDefsFilterablePreference
	public let starterpackJoined: AppBskyNotificationDefsPreference
	public let subscribedPost: AppBskyNotificationDefsPreference
	public let unverified: AppBskyNotificationDefsPreference
	public let verified: AppBskyNotificationDefsPreference

	public init(
		chat: AppBskyNotificationDefsChatPreference,
		follow: AppBskyNotificationDefsFilterablePreference,
		like: AppBskyNotificationDefsFilterablePreference,
		likeViaRepost: AppBskyNotificationDefsFilterablePreference,
		mention: AppBskyNotificationDefsFilterablePreference,
		quote: AppBskyNotificationDefsFilterablePreference,
		reply: AppBskyNotificationDefsFilterablePreference,
		repost: AppBskyNotificationDefsFilterablePreference,
		repostViaRepost: AppBskyNotificationDefsFilterablePreference,
		starterpackJoined: AppBskyNotificationDefsPreference,
		subscribedPost: AppBskyNotificationDefsPreference,
		unverified: AppBskyNotificationDefsPreference,
		verified: AppBskyNotificationDefsPreference
	) {
		self.chat = chat
		self.follow = follow
		self.like = like
		self.likeViaRepost = likeViaRepost
		self.mention = mention
		self.quote = quote
		self.reply = reply
		self.repost = repost
		self.repostViaRepost = repostViaRepost
		self.starterpackJoined = starterpackJoined
		self.subscribedPost = subscribedPost
		self.unverified = unverified
		self.verified = verified
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		chat = try container.decode(AppBskyNotificationDefsChatPreference.self, forKey: .chat)
		follow = try container.decode(AppBskyNotificationDefsFilterablePreference.self, forKey: .follow)
		like = try container.decode(AppBskyNotificationDefsFilterablePreference.self, forKey: .like)
		likeViaRepost = try container.decode(AppBskyNotificationDefsFilterablePreference.self, forKey: .likeViaRepost)
		mention = try container.decode(AppBskyNotificationDefsFilterablePreference.self, forKey: .mention)
		quote = try container.decode(AppBskyNotificationDefsFilterablePreference.self, forKey: .quote)
		reply = try container.decode(AppBskyNotificationDefsFilterablePreference.self, forKey: .reply)
		repost = try container.decode(AppBskyNotificationDefsFilterablePreference.self, forKey: .repost)
		repostViaRepost = try container.decode(AppBskyNotificationDefsFilterablePreference.self, forKey: .repostViaRepost)
		starterpackJoined = try container.decode(AppBskyNotificationDefsPreference.self, forKey: .starterpackJoined)
		subscribedPost = try container.decode(AppBskyNotificationDefsPreference.self, forKey: .subscribedPost)
		unverified = try container.decode(AppBskyNotificationDefsPreference.self, forKey: .unverified)
		verified = try container.decode(AppBskyNotificationDefsPreference.self, forKey: .verified)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(chat, forKey: .chat)
		try container.encode(follow, forKey: .follow)
		try container.encode(like, forKey: .like)
		try container.encode(likeViaRepost, forKey: .likeViaRepost)
		try container.encode(mention, forKey: .mention)
		try container.encode(quote, forKey: .quote)
		try container.encode(reply, forKey: .reply)
		try container.encode(repost, forKey: .repost)
		try container.encode(repostViaRepost, forKey: .repostViaRepost)
		try container.encode(starterpackJoined, forKey: .starterpackJoined)
		try container.encode(subscribedPost, forKey: .subscribedPost)
		try container.encode(unverified, forKey: .unverified)
		try container.encode(verified, forKey: .verified)
	}

	private enum CodingKeys: String, CodingKey {
		case chat = "chat"
		case follow = "follow"
		case like = "like"
		case likeViaRepost = "likeViaRepost"
		case mention = "mention"
		case quote = "quote"
		case reply = "reply"
		case repost = "repost"
		case repostViaRepost = "repostViaRepost"
		case starterpackJoined = "starterpackJoined"
		case subscribedPost = "subscribedPost"
		case unverified = "unverified"
		case verified = "verified"
	}
}


public struct AppBskyNotificationDefsRecordDeleted: Codable, Sendable, Equatable {

	public init() {}

	public init(from decoder: Decoder) throws {
		_ = try decoder.container(keyedBy: CodingKeys.self)
	}

	public func encode(to encoder: Encoder) throws {
		_ = encoder.container(keyedBy: CodingKeys.self)
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


public struct AppBskyNotificationDefsSubjectActivitySubscription: Codable, Sendable, Equatable {
	public let activitySubscription: AppBskyNotificationDefsActivitySubscription
	public let subject: DID

	public init(
		activitySubscription: AppBskyNotificationDefsActivitySubscription,
		subject: DID
	) {
		self.activitySubscription = activitySubscription
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		activitySubscription = try container.decode(AppBskyNotificationDefsActivitySubscription.self, forKey: .activitySubscription)
		subject = try container.decode(DID.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(activitySubscription, forKey: .activitySubscription)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case activitySubscription = "activitySubscription"
		case subject = "subject"
	}
}


public struct AppBskyNotificationGetPreferencesOutput: Codable, Sendable, Equatable {
	public let preferences: AppBskyNotificationDefsPreferences

	public init(
		preferences: AppBskyNotificationDefsPreferences
	) {
		self.preferences = preferences
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		preferences = try container.decode(AppBskyNotificationDefsPreferences.self, forKey: .preferences)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(preferences, forKey: .preferences)
	}

	private enum CodingKeys: String, CodingKey {
		case preferences = "preferences"
	}
}


public struct AppBskyNotificationGetPreferencesParameters: Codable, Sendable, Equatable {

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


public struct AppBskyNotificationGetUnreadCountOutput: Codable, Sendable, Equatable {
	public let count: Int

	public init(
		count: Int
	) {
		self.count = count
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		count = try container.decode(Int.self, forKey: .count)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(count, forKey: .count)
	}

	private enum CodingKeys: String, CodingKey {
		case count = "count"
	}
}


public struct AppBskyNotificationGetUnreadCountParameters: Codable, Sendable, Equatable {
	public let priority: Bool?
	public let seenAt: ATProtocolDate?

	public init(
		priority: Bool? = nil,
		seenAt: ATProtocolDate? = nil
	) {
		self.priority = priority
		self.seenAt = seenAt
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		priority = try container.decodeIfPresent(Bool.self, forKey: .priority)
		seenAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .seenAt)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(priority, forKey: .priority)
		try container.encodeIfPresent(seenAt, forKey: .seenAt)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = priority {
			value.appendQueryItems(named: "priority", to: &items)
		}
		if let value = seenAt {
			value.appendQueryItems(named: "seenAt", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case priority = "priority"
		case seenAt = "seenAt"
	}
}


public struct AppBskyNotificationListActivitySubscriptionsOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let subscriptions: [AppBskyActorDefsProfileView]

	public init(
		cursor: String? = nil,
		subscriptions: [AppBskyActorDefsProfileView]
	) {
		self.cursor = cursor
		self.subscriptions = subscriptions
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		subscriptions = try container.decode([AppBskyActorDefsProfileView].self, forKey: .subscriptions)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(subscriptions, forKey: .subscriptions)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case subscriptions = "subscriptions"
	}
}


public struct AppBskyNotificationListActivitySubscriptionsParameters: Codable, Sendable, Equatable {
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


public struct AppBskyNotificationListNotificationsNotification: Codable, Sendable, Equatable {
	public let author: AppBskyActorDefsProfileView
	public let cid: CID
	public let indexedAt: ATProtocolDate
	public let isRead: Bool
	public let labels: [ComAtprotoLabelDefsLabel]?
	public let reason: AppBskyNotificationListNotificationsNotificationReason
	public let reasonSubject: ATURI?
	public let record: ATProtocolValueContainer
	public let uri: ATURI

	public init(
		author: AppBskyActorDefsProfileView,
		cid: CID,
		indexedAt: ATProtocolDate,
		isRead: Bool,
		labels: [ComAtprotoLabelDefsLabel]? = nil,
		reason: AppBskyNotificationListNotificationsNotificationReason,
		reasonSubject: ATURI? = nil,
		record: ATProtocolValueContainer,
		uri: ATURI
	) {
		self.author = author
		self.cid = cid
		self.indexedAt = indexedAt
		self.isRead = isRead
		self.labels = labels
		self.reason = reason
		self.reasonSubject = reasonSubject
		self.record = record
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		author = try container.decode(AppBskyActorDefsProfileView.self, forKey: .author)
		cid = try container.decode(CID.self, forKey: .cid)
		indexedAt = try container.decode(ATProtocolDate.self, forKey: .indexedAt)
		isRead = try container.decode(Bool.self, forKey: .isRead)
		labels = try container.decodeIfPresent([ComAtprotoLabelDefsLabel].self, forKey: .labels)
		reason = try container.decode(AppBskyNotificationListNotificationsNotificationReason.self, forKey: .reason)
		reasonSubject = try container.decodeIfPresent(ATURI.self, forKey: .reasonSubject)
		record = try container.decode(ATProtocolValueContainer.self, forKey: .record)
		uri = try container.decode(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(author, forKey: .author)
		try container.encode(cid, forKey: .cid)
		try container.encode(indexedAt, forKey: .indexedAt)
		try container.encode(isRead, forKey: .isRead)
		try container.encodeIfPresent(labels, forKey: .labels)
		try container.encode(reason, forKey: .reason)
		try container.encodeIfPresent(reasonSubject, forKey: .reasonSubject)
		try container.encode(record, forKey: .record)
		try container.encode(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case author = "author"
		case cid = "cid"
		case indexedAt = "indexedAt"
		case isRead = "isRead"
		case labels = "labels"
		case reason = "reason"
		case reasonSubject = "reasonSubject"
		case record = "record"
		case uri = "uri"
	}
}


public enum AppBskyNotificationListNotificationsNotificationReason: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case like = "like"
	case repost = "repost"
	case follow = "follow"
	case mention = "mention"
	case reply = "reply"
	case quote = "quote"
	case starterpackJoined = "starterpack-joined"
	case verified = "verified"
	case unverified = "unverified"
	case likeViaRepost = "like-via-repost"
	case repostViaRepost = "repost-via-repost"
	case subscribedPost = "subscribed-post"
	case contactMatch = "contact-match"
}


public struct AppBskyNotificationListNotificationsOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let notifications: [AppBskyNotificationListNotificationsNotification]
	public let priority: Bool?
	public let seenAt: ATProtocolDate?

	public init(
		cursor: String? = nil,
		notifications: [AppBskyNotificationListNotificationsNotification],
		priority: Bool? = nil,
		seenAt: ATProtocolDate? = nil
	) {
		self.cursor = cursor
		self.notifications = notifications
		self.priority = priority
		self.seenAt = seenAt
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		notifications = try container.decode([AppBskyNotificationListNotificationsNotification].self, forKey: .notifications)
		priority = try container.decodeIfPresent(Bool.self, forKey: .priority)
		seenAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .seenAt)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(notifications, forKey: .notifications)
		try container.encodeIfPresent(priority, forKey: .priority)
		try container.encodeIfPresent(seenAt, forKey: .seenAt)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case notifications = "notifications"
		case priority = "priority"
		case seenAt = "seenAt"
	}
}


public struct AppBskyNotificationListNotificationsParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?
	public let priority: Bool?
	public let reasons: [String]?
	public let seenAt: ATProtocolDate?

	public init(
		cursor: String? = nil,
		limit: Int? = nil,
		priority: Bool? = nil,
		reasons: [String]? = nil,
		seenAt: ATProtocolDate? = nil
	) {
		self.cursor = cursor
		self.limit = limit
		self.priority = priority
		self.reasons = reasons
		self.seenAt = seenAt
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		priority = try container.decodeIfPresent(Bool.self, forKey: .priority)
		reasons = try container.decodeIfPresent([String].self, forKey: .reasons)
		seenAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .seenAt)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encodeIfPresent(priority, forKey: .priority)
		try container.encodeIfPresent(reasons, forKey: .reasons)
		try container.encodeIfPresent(seenAt, forKey: .seenAt)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		if let value = priority {
			value.appendQueryItems(named: "priority", to: &items)
		}
		if let value = reasons {
			value.appendQueryItems(named: "reasons", to: &items)
		}
		if let value = seenAt {
			value.appendQueryItems(named: "seenAt", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
		case priority = "priority"
		case reasons = "reasons"
		case seenAt = "seenAt"
	}
}


public struct AppBskyNotificationPutActivitySubscriptionInput: Codable, Sendable, Equatable {
	public let activitySubscription: AppBskyNotificationDefsActivitySubscription
	public let subject: DID

	public init(
		activitySubscription: AppBskyNotificationDefsActivitySubscription,
		subject: DID
	) {
		self.activitySubscription = activitySubscription
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		activitySubscription = try container.decode(AppBskyNotificationDefsActivitySubscription.self, forKey: .activitySubscription)
		subject = try container.decode(DID.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(activitySubscription, forKey: .activitySubscription)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case activitySubscription = "activitySubscription"
		case subject = "subject"
	}
}


public struct AppBskyNotificationPutActivitySubscriptionOutput: Codable, Sendable, Equatable {
	public let activitySubscription: AppBskyNotificationDefsActivitySubscription?
	public let subject: DID

	public init(
		activitySubscription: AppBskyNotificationDefsActivitySubscription? = nil,
		subject: DID
	) {
		self.activitySubscription = activitySubscription
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		activitySubscription = try container.decodeIfPresent(AppBskyNotificationDefsActivitySubscription.self, forKey: .activitySubscription)
		subject = try container.decode(DID.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(activitySubscription, forKey: .activitySubscription)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case activitySubscription = "activitySubscription"
		case subject = "subject"
	}
}


public struct AppBskyNotificationPutPreferencesInput: Codable, Sendable, Equatable {
	public let priority: Bool

	public init(
		priority: Bool
	) {
		self.priority = priority
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		priority = try container.decode(Bool.self, forKey: .priority)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(priority, forKey: .priority)
	}

	private enum CodingKeys: String, CodingKey {
		case priority = "priority"
	}
}


public struct AppBskyNotificationPutPreferencesV2Input: Codable, Sendable, Equatable {
	public let chat: AppBskyNotificationDefsChatPreference?
	public let follow: AppBskyNotificationDefsFilterablePreference?
	public let like: AppBskyNotificationDefsFilterablePreference?
	public let likeViaRepost: AppBskyNotificationDefsFilterablePreference?
	public let mention: AppBskyNotificationDefsFilterablePreference?
	public let quote: AppBskyNotificationDefsFilterablePreference?
	public let reply: AppBskyNotificationDefsFilterablePreference?
	public let repost: AppBskyNotificationDefsFilterablePreference?
	public let repostViaRepost: AppBskyNotificationDefsFilterablePreference?
	public let starterpackJoined: AppBskyNotificationDefsPreference?
	public let subscribedPost: AppBskyNotificationDefsPreference?
	public let unverified: AppBskyNotificationDefsPreference?
	public let verified: AppBskyNotificationDefsPreference?

	public init(
		chat: AppBskyNotificationDefsChatPreference? = nil,
		follow: AppBskyNotificationDefsFilterablePreference? = nil,
		like: AppBskyNotificationDefsFilterablePreference? = nil,
		likeViaRepost: AppBskyNotificationDefsFilterablePreference? = nil,
		mention: AppBskyNotificationDefsFilterablePreference? = nil,
		quote: AppBskyNotificationDefsFilterablePreference? = nil,
		reply: AppBskyNotificationDefsFilterablePreference? = nil,
		repost: AppBskyNotificationDefsFilterablePreference? = nil,
		repostViaRepost: AppBskyNotificationDefsFilterablePreference? = nil,
		starterpackJoined: AppBskyNotificationDefsPreference? = nil,
		subscribedPost: AppBskyNotificationDefsPreference? = nil,
		unverified: AppBskyNotificationDefsPreference? = nil,
		verified: AppBskyNotificationDefsPreference? = nil
	) {
		self.chat = chat
		self.follow = follow
		self.like = like
		self.likeViaRepost = likeViaRepost
		self.mention = mention
		self.quote = quote
		self.reply = reply
		self.repost = repost
		self.repostViaRepost = repostViaRepost
		self.starterpackJoined = starterpackJoined
		self.subscribedPost = subscribedPost
		self.unverified = unverified
		self.verified = verified
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		chat = try container.decodeIfPresent(AppBskyNotificationDefsChatPreference.self, forKey: .chat)
		follow = try container.decodeIfPresent(AppBskyNotificationDefsFilterablePreference.self, forKey: .follow)
		like = try container.decodeIfPresent(AppBskyNotificationDefsFilterablePreference.self, forKey: .like)
		likeViaRepost = try container.decodeIfPresent(AppBskyNotificationDefsFilterablePreference.self, forKey: .likeViaRepost)
		mention = try container.decodeIfPresent(AppBskyNotificationDefsFilterablePreference.self, forKey: .mention)
		quote = try container.decodeIfPresent(AppBskyNotificationDefsFilterablePreference.self, forKey: .quote)
		reply = try container.decodeIfPresent(AppBskyNotificationDefsFilterablePreference.self, forKey: .reply)
		repost = try container.decodeIfPresent(AppBskyNotificationDefsFilterablePreference.self, forKey: .repost)
		repostViaRepost = try container.decodeIfPresent(AppBskyNotificationDefsFilterablePreference.self, forKey: .repostViaRepost)
		starterpackJoined = try container.decodeIfPresent(AppBskyNotificationDefsPreference.self, forKey: .starterpackJoined)
		subscribedPost = try container.decodeIfPresent(AppBskyNotificationDefsPreference.self, forKey: .subscribedPost)
		unverified = try container.decodeIfPresent(AppBskyNotificationDefsPreference.self, forKey: .unverified)
		verified = try container.decodeIfPresent(AppBskyNotificationDefsPreference.self, forKey: .verified)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(chat, forKey: .chat)
		try container.encodeIfPresent(follow, forKey: .follow)
		try container.encodeIfPresent(like, forKey: .like)
		try container.encodeIfPresent(likeViaRepost, forKey: .likeViaRepost)
		try container.encodeIfPresent(mention, forKey: .mention)
		try container.encodeIfPresent(quote, forKey: .quote)
		try container.encodeIfPresent(reply, forKey: .reply)
		try container.encodeIfPresent(repost, forKey: .repost)
		try container.encodeIfPresent(repostViaRepost, forKey: .repostViaRepost)
		try container.encodeIfPresent(starterpackJoined, forKey: .starterpackJoined)
		try container.encodeIfPresent(subscribedPost, forKey: .subscribedPost)
		try container.encodeIfPresent(unverified, forKey: .unverified)
		try container.encodeIfPresent(verified, forKey: .verified)
	}

	private enum CodingKeys: String, CodingKey {
		case chat = "chat"
		case follow = "follow"
		case like = "like"
		case likeViaRepost = "likeViaRepost"
		case mention = "mention"
		case quote = "quote"
		case reply = "reply"
		case repost = "repost"
		case repostViaRepost = "repostViaRepost"
		case starterpackJoined = "starterpackJoined"
		case subscribedPost = "subscribedPost"
		case unverified = "unverified"
		case verified = "verified"
	}
}


public struct AppBskyNotificationPutPreferencesV2Output: Codable, Sendable, Equatable {
	public let preferences: AppBskyNotificationDefsPreferences

	public init(
		preferences: AppBskyNotificationDefsPreferences
	) {
		self.preferences = preferences
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		preferences = try container.decode(AppBskyNotificationDefsPreferences.self, forKey: .preferences)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(preferences, forKey: .preferences)
	}

	private enum CodingKeys: String, CodingKey {
		case preferences = "preferences"
	}
}


public struct AppBskyNotificationRegisterPushInput: Codable, Sendable, Equatable {
	public let ageRestricted: Bool?
	public let appId: String
	public let platform: AppBskyNotificationRegisterPushInputPlatform
	public let serviceDid: DID
	public let token: String

	public init(
		ageRestricted: Bool? = nil,
		appId: String,
		platform: AppBskyNotificationRegisterPushInputPlatform,
		serviceDid: DID,
		token: String
	) {
		self.ageRestricted = ageRestricted
		self.appId = appId
		self.platform = platform
		self.serviceDid = serviceDid
		self.token = token
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		ageRestricted = try container.decodeIfPresent(Bool.self, forKey: .ageRestricted)
		appId = try container.decode(String.self, forKey: .appId)
		platform = try container.decode(AppBskyNotificationRegisterPushInputPlatform.self, forKey: .platform)
		serviceDid = try container.decode(DID.self, forKey: .serviceDid)
		token = try container.decode(String.self, forKey: .token)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(ageRestricted, forKey: .ageRestricted)
		try container.encode(appId, forKey: .appId)
		try container.encode(platform, forKey: .platform)
		try container.encode(serviceDid, forKey: .serviceDid)
		try container.encode(token, forKey: .token)
	}

	private enum CodingKeys: String, CodingKey {
		case ageRestricted = "ageRestricted"
		case appId = "appId"
		case platform = "platform"
		case serviceDid = "serviceDid"
		case token = "token"
	}
}


public enum AppBskyNotificationRegisterPushInputPlatform: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case ios = "ios"
	case android = "android"
	case web = "web"
}


public struct AppBskyNotificationUnregisterPushInput: Codable, Sendable, Equatable {
	public let appId: String
	public let platform: AppBskyNotificationRegisterPushInputPlatform
	public let serviceDid: DID
	public let token: String

	public init(
		appId: String,
		platform: AppBskyNotificationRegisterPushInputPlatform,
		serviceDid: DID,
		token: String
	) {
		self.appId = appId
		self.platform = platform
		self.serviceDid = serviceDid
		self.token = token
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		appId = try container.decode(String.self, forKey: .appId)
		platform = try container.decode(AppBskyNotificationRegisterPushInputPlatform.self, forKey: .platform)
		serviceDid = try container.decode(DID.self, forKey: .serviceDid)
		token = try container.decode(String.self, forKey: .token)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(appId, forKey: .appId)
		try container.encode(platform, forKey: .platform)
		try container.encode(serviceDid, forKey: .serviceDid)
		try container.encode(token, forKey: .token)
	}

	private enum CodingKeys: String, CodingKey {
		case appId = "appId"
		case platform = "platform"
		case serviceDid = "serviceDid"
		case token = "token"
	}
}


public struct AppBskyNotificationUpdateSeenInput: Codable, Sendable, Equatable {
	public let seenAt: ATProtocolDate

	public init(
		seenAt: ATProtocolDate
	) {
		self.seenAt = seenAt
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		seenAt = try container.decode(ATProtocolDate.self, forKey: .seenAt)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(seenAt, forKey: .seenAt)
	}

	private enum CodingKeys: String, CodingKey {
		case seenAt = "seenAt"
	}
}


