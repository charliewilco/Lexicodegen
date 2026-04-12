import Foundation


public enum AppBskyBookmarkCreateBookmarkError: String, Swift.Error, CaseIterable, Sendable {
	case unsupportedCollection = "UnsupportedCollection"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct AppBskyBookmarkCreateBookmarkInput: Codable, Sendable, Equatable {
	public let cid: CID
	public let uri: ATURI

	public init(
		cid: CID,
		uri: ATURI
	) {
		self.cid = cid
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		uri = try container.decode(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encode(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case uri = "uri"
	}
}


public struct AppBskyBookmarkDefsBookmark: Codable, Sendable, Equatable {
	public let subject: ComAtprotoRepoStrongRef

	public init(
		subject: ComAtprotoRepoStrongRef
	) {
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		subject = try container.decode(ComAtprotoRepoStrongRef.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case subject = "subject"
	}
}


public struct AppBskyBookmarkDefsBookmarkView: Codable, Sendable, Equatable {
	public let createdAt: ATProtocolDate?
	public let item: AppBskyBookmarkDefsBookmarkViewItem
	public let subject: ComAtprotoRepoStrongRef

	public init(
		createdAt: ATProtocolDate? = nil,
		item: AppBskyBookmarkDefsBookmarkViewItem,
		subject: ComAtprotoRepoStrongRef
	) {
		self.createdAt = createdAt
		self.item = item
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		createdAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .createdAt)
		item = try container.decode(AppBskyBookmarkDefsBookmarkViewItem.self, forKey: .item)
		subject = try container.decode(ComAtprotoRepoStrongRef.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(createdAt, forKey: .createdAt)
		try container.encode(item, forKey: .item)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case createdAt = "createdAt"
		case item = "item"
		case subject = "subject"
	}
}


public indirect enum AppBskyBookmarkDefsBookmarkViewItem: Codable, Sendable, Equatable {
	case blockedPost(AppBskyFeedDefsBlockedPost)
	case notFoundPost(AppBskyFeedDefsNotFoundPost)
	case postView(AppBskyFeedDefsPostView)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "app.bsky.feed.defs#blockedPost": self = .blockedPost(try AppBskyFeedDefsBlockedPost(from: decoder))
		case "app.bsky.feed.defs#notFoundPost": self = .notFoundPost(try AppBskyFeedDefsNotFoundPost(from: decoder))
		case "app.bsky.feed.defs#postView": self = .postView(try AppBskyFeedDefsPostView(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .blockedPost(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.feed.defs#blockedPost", to: encoder)
		case .notFoundPost(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.feed.defs#notFoundPost", to: encoder)
		case .postView(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.feed.defs#postView", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public enum AppBskyBookmarkDeleteBookmarkError: String, Swift.Error, CaseIterable, Sendable {
	case unsupportedCollection = "UnsupportedCollection"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct AppBskyBookmarkDeleteBookmarkInput: Codable, Sendable, Equatable {
	public let uri: ATURI

	public init(
		uri: ATURI
	) {
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		uri = try container.decode(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case uri = "uri"
	}
}


public struct AppBskyBookmarkGetBookmarksOutput: Codable, Sendable, Equatable {
	public let bookmarks: [AppBskyBookmarkDefsBookmarkView]
	public let cursor: String?

	public init(
		bookmarks: [AppBskyBookmarkDefsBookmarkView],
		cursor: String? = nil
	) {
		self.bookmarks = bookmarks
		self.cursor = cursor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		bookmarks = try container.decode([AppBskyBookmarkDefsBookmarkView].self, forKey: .bookmarks)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(bookmarks, forKey: .bookmarks)
		try container.encodeIfPresent(cursor, forKey: .cursor)
	}

	private enum CodingKeys: String, CodingKey {
		case bookmarks = "bookmarks"
		case cursor = "cursor"
	}
}


public struct AppBskyBookmarkGetBookmarksParameters: Codable, Sendable, Equatable {
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


