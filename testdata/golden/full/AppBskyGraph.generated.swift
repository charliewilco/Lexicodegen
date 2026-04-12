import Foundation


public struct AppBskyGraphBlock: Codable, Sendable, Equatable {
	public static let typeIdentifier = "app.bsky.graph.block"

	public let createdAt: ATProtocolDate
	public let subject: DID

	public init(
		createdAt: ATProtocolDate,
		subject: DID
	) {
		self.createdAt = createdAt
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		subject = try container.decode(DID.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.typeIdentifier, forKey: .typeIdentifier)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case createdAt = "createdAt"
		case subject = "subject"
	}
}


public typealias AppBskyGraphDefsCuratelist = String


public struct AppBskyGraphDefsListItemView: Codable, Sendable, Equatable {
	public let subject: AppBskyActorDefsProfileView
	public let uri: ATURI

	public init(
		subject: AppBskyActorDefsProfileView,
		uri: ATURI
	) {
		self.subject = subject
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		subject = try container.decode(AppBskyActorDefsProfileView.self, forKey: .subject)
		uri = try container.decode(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(subject, forKey: .subject)
		try container.encode(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case subject = "subject"
		case uri = "uri"
	}
}


public enum AppBskyGraphDefsListPurpose: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case appBskyGraphDefsModlist = "app.bsky.graph.defs#modlist"
	case appBskyGraphDefsCuratelist = "app.bsky.graph.defs#curatelist"
	case appBskyGraphDefsReferencelist = "app.bsky.graph.defs#referencelist"
}


public struct AppBskyGraphDefsListView: Codable, Sendable, Equatable {
	public let avatar: String?
	public let cid: CID
	public let creator: AppBskyActorDefsProfileView
	public let description: String?
	public let descriptionFacets: [AppBskyRichtextFacet]?
	public let indexedAt: ATProtocolDate
	public let labels: [ComAtprotoLabelDefsLabel]?
	public let listItemCount: Int?
	public let name: String
	public let purpose: AppBskyGraphDefsListPurpose
	public let uri: ATURI
	public let viewer: AppBskyGraphDefsListViewerState?

	public init(
		avatar: String? = nil,
		cid: CID,
		creator: AppBskyActorDefsProfileView,
		description: String? = nil,
		descriptionFacets: [AppBskyRichtextFacet]? = nil,
		indexedAt: ATProtocolDate,
		labels: [ComAtprotoLabelDefsLabel]? = nil,
		listItemCount: Int? = nil,
		name: String,
		purpose: AppBskyGraphDefsListPurpose,
		uri: ATURI,
		viewer: AppBskyGraphDefsListViewerState? = nil
	) {
		self.avatar = avatar
		self.cid = cid
		self.creator = creator
		self.description = description
		self.descriptionFacets = descriptionFacets
		self.indexedAt = indexedAt
		self.labels = labels
		self.listItemCount = listItemCount
		self.name = name
		self.purpose = purpose
		self.uri = uri
		self.viewer = viewer
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
		cid = try container.decode(CID.self, forKey: .cid)
		creator = try container.decode(AppBskyActorDefsProfileView.self, forKey: .creator)
		description = try container.decodeIfPresent(String.self, forKey: .description)
		descriptionFacets = try container.decodeIfPresent([AppBskyRichtextFacet].self, forKey: .descriptionFacets)
		indexedAt = try container.decode(ATProtocolDate.self, forKey: .indexedAt)
		labels = try container.decodeIfPresent([ComAtprotoLabelDefsLabel].self, forKey: .labels)
		listItemCount = try container.decodeIfPresent(Int.self, forKey: .listItemCount)
		name = try container.decode(String.self, forKey: .name)
		purpose = try container.decode(AppBskyGraphDefsListPurpose.self, forKey: .purpose)
		uri = try container.decode(ATURI.self, forKey: .uri)
		viewer = try container.decodeIfPresent(AppBskyGraphDefsListViewerState.self, forKey: .viewer)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(avatar, forKey: .avatar)
		try container.encode(cid, forKey: .cid)
		try container.encode(creator, forKey: .creator)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encodeIfPresent(descriptionFacets, forKey: .descriptionFacets)
		try container.encode(indexedAt, forKey: .indexedAt)
		try container.encodeIfPresent(labels, forKey: .labels)
		try container.encodeIfPresent(listItemCount, forKey: .listItemCount)
		try container.encode(name, forKey: .name)
		try container.encode(purpose, forKey: .purpose)
		try container.encode(uri, forKey: .uri)
		try container.encodeIfPresent(viewer, forKey: .viewer)
	}

	private enum CodingKeys: String, CodingKey {
		case avatar = "avatar"
		case cid = "cid"
		case creator = "creator"
		case description = "description"
		case descriptionFacets = "descriptionFacets"
		case indexedAt = "indexedAt"
		case labels = "labels"
		case listItemCount = "listItemCount"
		case name = "name"
		case purpose = "purpose"
		case uri = "uri"
		case viewer = "viewer"
	}
}


public struct AppBskyGraphDefsListViewBasic: Codable, Sendable, Equatable {
	public let avatar: String?
	public let cid: CID
	public let indexedAt: ATProtocolDate?
	public let labels: [ComAtprotoLabelDefsLabel]?
	public let listItemCount: Int?
	public let name: String
	public let purpose: AppBskyGraphDefsListPurpose
	public let uri: ATURI
	public let viewer: AppBskyGraphDefsListViewerState?

	public init(
		avatar: String? = nil,
		cid: CID,
		indexedAt: ATProtocolDate? = nil,
		labels: [ComAtprotoLabelDefsLabel]? = nil,
		listItemCount: Int? = nil,
		name: String,
		purpose: AppBskyGraphDefsListPurpose,
		uri: ATURI,
		viewer: AppBskyGraphDefsListViewerState? = nil
	) {
		self.avatar = avatar
		self.cid = cid
		self.indexedAt = indexedAt
		self.labels = labels
		self.listItemCount = listItemCount
		self.name = name
		self.purpose = purpose
		self.uri = uri
		self.viewer = viewer
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
		cid = try container.decode(CID.self, forKey: .cid)
		indexedAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .indexedAt)
		labels = try container.decodeIfPresent([ComAtprotoLabelDefsLabel].self, forKey: .labels)
		listItemCount = try container.decodeIfPresent(Int.self, forKey: .listItemCount)
		name = try container.decode(String.self, forKey: .name)
		purpose = try container.decode(AppBskyGraphDefsListPurpose.self, forKey: .purpose)
		uri = try container.decode(ATURI.self, forKey: .uri)
		viewer = try container.decodeIfPresent(AppBskyGraphDefsListViewerState.self, forKey: .viewer)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(avatar, forKey: .avatar)
		try container.encode(cid, forKey: .cid)
		try container.encodeIfPresent(indexedAt, forKey: .indexedAt)
		try container.encodeIfPresent(labels, forKey: .labels)
		try container.encodeIfPresent(listItemCount, forKey: .listItemCount)
		try container.encode(name, forKey: .name)
		try container.encode(purpose, forKey: .purpose)
		try container.encode(uri, forKey: .uri)
		try container.encodeIfPresent(viewer, forKey: .viewer)
	}

	private enum CodingKeys: String, CodingKey {
		case avatar = "avatar"
		case cid = "cid"
		case indexedAt = "indexedAt"
		case labels = "labels"
		case listItemCount = "listItemCount"
		case name = "name"
		case purpose = "purpose"
		case uri = "uri"
		case viewer = "viewer"
	}
}


public struct AppBskyGraphDefsListViewerState: Codable, Sendable, Equatable {
	public let blocked: ATURI?
	public let muted: Bool?

	public init(
		blocked: ATURI? = nil,
		muted: Bool? = nil
	) {
		self.blocked = blocked
		self.muted = muted
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		blocked = try container.decodeIfPresent(ATURI.self, forKey: .blocked)
		muted = try container.decodeIfPresent(Bool.self, forKey: .muted)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(blocked, forKey: .blocked)
		try container.encodeIfPresent(muted, forKey: .muted)
	}

	private enum CodingKeys: String, CodingKey {
		case blocked = "blocked"
		case muted = "muted"
	}
}


public typealias AppBskyGraphDefsModlist = String


public struct AppBskyGraphDefsNotFoundActor: Codable, Sendable, Equatable {
	public let actor: ATIdentifier
	public let notFound: Bool

	public init(
		actor: ATIdentifier,
		notFound: Bool
	) {
		self.actor = actor
		self.notFound = notFound
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(ATIdentifier.self, forKey: .actor)
		notFound = try container.decode(Bool.self, forKey: .notFound)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
		try container.encode(notFound, forKey: .notFound)
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case notFound = "notFound"
	}
}


public typealias AppBskyGraphDefsReferencelist = String


public struct AppBskyGraphDefsRelationship: Codable, Sendable, Equatable {
	public let blockedBy: ATURI?
	public let blockedByList: ATURI?
	public let blocking: ATURI?
	public let blockingByList: ATURI?
	public let did: DID
	public let followedBy: ATURI?
	public let following: ATURI?

	public init(
		blockedBy: ATURI? = nil,
		blockedByList: ATURI? = nil,
		blocking: ATURI? = nil,
		blockingByList: ATURI? = nil,
		did: DID,
		followedBy: ATURI? = nil,
		following: ATURI? = nil
	) {
		self.blockedBy = blockedBy
		self.blockedByList = blockedByList
		self.blocking = blocking
		self.blockingByList = blockingByList
		self.did = did
		self.followedBy = followedBy
		self.following = following
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		blockedBy = try container.decodeIfPresent(ATURI.self, forKey: .blockedBy)
		blockedByList = try container.decodeIfPresent(ATURI.self, forKey: .blockedByList)
		blocking = try container.decodeIfPresent(ATURI.self, forKey: .blocking)
		blockingByList = try container.decodeIfPresent(ATURI.self, forKey: .blockingByList)
		did = try container.decode(DID.self, forKey: .did)
		followedBy = try container.decodeIfPresent(ATURI.self, forKey: .followedBy)
		following = try container.decodeIfPresent(ATURI.self, forKey: .following)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(blockedBy, forKey: .blockedBy)
		try container.encodeIfPresent(blockedByList, forKey: .blockedByList)
		try container.encodeIfPresent(blocking, forKey: .blocking)
		try container.encodeIfPresent(blockingByList, forKey: .blockingByList)
		try container.encode(did, forKey: .did)
		try container.encodeIfPresent(followedBy, forKey: .followedBy)
		try container.encodeIfPresent(following, forKey: .following)
	}

	private enum CodingKeys: String, CodingKey {
		case blockedBy = "blockedBy"
		case blockedByList = "blockedByList"
		case blocking = "blocking"
		case blockingByList = "blockingByList"
		case did = "did"
		case followedBy = "followedBy"
		case following = "following"
	}
}


public struct AppBskyGraphDefsStarterPackView: Codable, Sendable, Equatable {
	public let cid: CID
	public let creator: AppBskyActorDefsProfileViewBasic
	public let feeds: [AppBskyFeedDefsGeneratorView]?
	public let indexedAt: ATProtocolDate
	public let joinedAllTimeCount: Int?
	public let joinedWeekCount: Int?
	public let labels: [ComAtprotoLabelDefsLabel]?
	public let list: AppBskyGraphDefsListViewBasic?
	public let listItemsSample: [AppBskyGraphDefsListItemView]?
	public let record: ATProtocolValueContainer
	public let uri: ATURI

	public init(
		cid: CID,
		creator: AppBskyActorDefsProfileViewBasic,
		feeds: [AppBskyFeedDefsGeneratorView]? = nil,
		indexedAt: ATProtocolDate,
		joinedAllTimeCount: Int? = nil,
		joinedWeekCount: Int? = nil,
		labels: [ComAtprotoLabelDefsLabel]? = nil,
		list: AppBskyGraphDefsListViewBasic? = nil,
		listItemsSample: [AppBskyGraphDefsListItemView]? = nil,
		record: ATProtocolValueContainer,
		uri: ATURI
	) {
		self.cid = cid
		self.creator = creator
		self.feeds = feeds
		self.indexedAt = indexedAt
		self.joinedAllTimeCount = joinedAllTimeCount
		self.joinedWeekCount = joinedWeekCount
		self.labels = labels
		self.list = list
		self.listItemsSample = listItemsSample
		self.record = record
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		creator = try container.decode(AppBskyActorDefsProfileViewBasic.self, forKey: .creator)
		feeds = try container.decodeIfPresent([AppBskyFeedDefsGeneratorView].self, forKey: .feeds)
		indexedAt = try container.decode(ATProtocolDate.self, forKey: .indexedAt)
		joinedAllTimeCount = try container.decodeIfPresent(Int.self, forKey: .joinedAllTimeCount)
		joinedWeekCount = try container.decodeIfPresent(Int.self, forKey: .joinedWeekCount)
		labels = try container.decodeIfPresent([ComAtprotoLabelDefsLabel].self, forKey: .labels)
		list = try container.decodeIfPresent(AppBskyGraphDefsListViewBasic.self, forKey: .list)
		listItemsSample = try container.decodeIfPresent([AppBskyGraphDefsListItemView].self, forKey: .listItemsSample)
		record = try container.decode(ATProtocolValueContainer.self, forKey: .record)
		uri = try container.decode(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encode(creator, forKey: .creator)
		try container.encodeIfPresent(feeds, forKey: .feeds)
		try container.encode(indexedAt, forKey: .indexedAt)
		try container.encodeIfPresent(joinedAllTimeCount, forKey: .joinedAllTimeCount)
		try container.encodeIfPresent(joinedWeekCount, forKey: .joinedWeekCount)
		try container.encodeIfPresent(labels, forKey: .labels)
		try container.encodeIfPresent(list, forKey: .list)
		try container.encodeIfPresent(listItemsSample, forKey: .listItemsSample)
		try container.encode(record, forKey: .record)
		try container.encode(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case creator = "creator"
		case feeds = "feeds"
		case indexedAt = "indexedAt"
		case joinedAllTimeCount = "joinedAllTimeCount"
		case joinedWeekCount = "joinedWeekCount"
		case labels = "labels"
		case list = "list"
		case listItemsSample = "listItemsSample"
		case record = "record"
		case uri = "uri"
	}
}


public struct AppBskyGraphDefsStarterPackViewBasic: Codable, Sendable, Equatable {
	public let cid: CID
	public let creator: AppBskyActorDefsProfileViewBasic
	public let indexedAt: ATProtocolDate
	public let joinedAllTimeCount: Int?
	public let joinedWeekCount: Int?
	public let labels: [ComAtprotoLabelDefsLabel]?
	public let listItemCount: Int?
	public let record: ATProtocolValueContainer
	public let uri: ATURI

	public init(
		cid: CID,
		creator: AppBskyActorDefsProfileViewBasic,
		indexedAt: ATProtocolDate,
		joinedAllTimeCount: Int? = nil,
		joinedWeekCount: Int? = nil,
		labels: [ComAtprotoLabelDefsLabel]? = nil,
		listItemCount: Int? = nil,
		record: ATProtocolValueContainer,
		uri: ATURI
	) {
		self.cid = cid
		self.creator = creator
		self.indexedAt = indexedAt
		self.joinedAllTimeCount = joinedAllTimeCount
		self.joinedWeekCount = joinedWeekCount
		self.labels = labels
		self.listItemCount = listItemCount
		self.record = record
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		creator = try container.decode(AppBskyActorDefsProfileViewBasic.self, forKey: .creator)
		indexedAt = try container.decode(ATProtocolDate.self, forKey: .indexedAt)
		joinedAllTimeCount = try container.decodeIfPresent(Int.self, forKey: .joinedAllTimeCount)
		joinedWeekCount = try container.decodeIfPresent(Int.self, forKey: .joinedWeekCount)
		labels = try container.decodeIfPresent([ComAtprotoLabelDefsLabel].self, forKey: .labels)
		listItemCount = try container.decodeIfPresent(Int.self, forKey: .listItemCount)
		record = try container.decode(ATProtocolValueContainer.self, forKey: .record)
		uri = try container.decode(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encode(creator, forKey: .creator)
		try container.encode(indexedAt, forKey: .indexedAt)
		try container.encodeIfPresent(joinedAllTimeCount, forKey: .joinedAllTimeCount)
		try container.encodeIfPresent(joinedWeekCount, forKey: .joinedWeekCount)
		try container.encodeIfPresent(labels, forKey: .labels)
		try container.encodeIfPresent(listItemCount, forKey: .listItemCount)
		try container.encode(record, forKey: .record)
		try container.encode(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case creator = "creator"
		case indexedAt = "indexedAt"
		case joinedAllTimeCount = "joinedAllTimeCount"
		case joinedWeekCount = "joinedWeekCount"
		case labels = "labels"
		case listItemCount = "listItemCount"
		case record = "record"
		case uri = "uri"
	}
}


public struct AppBskyGraphFollow: Codable, Sendable, Equatable {
	public static let typeIdentifier = "app.bsky.graph.follow"

	public let createdAt: ATProtocolDate
	public let subject: DID
	public let via: ComAtprotoRepoStrongRef?

	public init(
		createdAt: ATProtocolDate,
		subject: DID,
		via: ComAtprotoRepoStrongRef? = nil
	) {
		self.createdAt = createdAt
		self.subject = subject
		self.via = via
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		subject = try container.decode(DID.self, forKey: .subject)
		via = try container.decodeIfPresent(ComAtprotoRepoStrongRef.self, forKey: .via)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.typeIdentifier, forKey: .typeIdentifier)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encode(subject, forKey: .subject)
		try container.encodeIfPresent(via, forKey: .via)
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case createdAt = "createdAt"
		case subject = "subject"
		case via = "via"
	}
}


public struct AppBskyGraphGetActorStarterPacksOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let starterPacks: [AppBskyGraphDefsStarterPackViewBasic]

	public init(
		cursor: String? = nil,
		starterPacks: [AppBskyGraphDefsStarterPackViewBasic]
	) {
		self.cursor = cursor
		self.starterPacks = starterPacks
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		starterPacks = try container.decode([AppBskyGraphDefsStarterPackViewBasic].self, forKey: .starterPacks)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(starterPacks, forKey: .starterPacks)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case starterPacks = "starterPacks"
	}
}


public struct AppBskyGraphGetActorStarterPacksParameters: Codable, Sendable, Equatable {
	public let actor: ATIdentifier
	public let cursor: String?
	public let limit: Int?

	public init(
		actor: ATIdentifier,
		cursor: String? = nil,
		limit: Int? = nil
	) {
		self.actor = actor
		self.cursor = cursor
		self.limit = limit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(ATIdentifier.self, forKey: .actor)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		actor.appendQueryItems(named: "actor", to: &items)
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case cursor = "cursor"
		case limit = "limit"
	}
}


public struct AppBskyGraphGetBlocksOutput: Codable, Sendable, Equatable {
	public let blocks: [AppBskyActorDefsProfileView]
	public let cursor: String?

	public init(
		blocks: [AppBskyActorDefsProfileView],
		cursor: String? = nil
	) {
		self.blocks = blocks
		self.cursor = cursor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		blocks = try container.decode([AppBskyActorDefsProfileView].self, forKey: .blocks)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(blocks, forKey: .blocks)
		try container.encodeIfPresent(cursor, forKey: .cursor)
	}

	private enum CodingKeys: String, CodingKey {
		case blocks = "blocks"
		case cursor = "cursor"
	}
}


public struct AppBskyGraphGetBlocksParameters: Codable, Sendable, Equatable {
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


public struct AppBskyGraphGetFollowersOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let followers: [AppBskyActorDefsProfileView]
	public let subject: AppBskyActorDefsProfileView

	public init(
		cursor: String? = nil,
		followers: [AppBskyActorDefsProfileView],
		subject: AppBskyActorDefsProfileView
	) {
		self.cursor = cursor
		self.followers = followers
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		followers = try container.decode([AppBskyActorDefsProfileView].self, forKey: .followers)
		subject = try container.decode(AppBskyActorDefsProfileView.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(followers, forKey: .followers)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case followers = "followers"
		case subject = "subject"
	}
}


public struct AppBskyGraphGetFollowersParameters: Codable, Sendable, Equatable {
	public let actor: ATIdentifier
	public let cursor: String?
	public let limit: Int?

	public init(
		actor: ATIdentifier,
		cursor: String? = nil,
		limit: Int? = nil
	) {
		self.actor = actor
		self.cursor = cursor
		self.limit = limit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(ATIdentifier.self, forKey: .actor)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		actor.appendQueryItems(named: "actor", to: &items)
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case cursor = "cursor"
		case limit = "limit"
	}
}


public struct AppBskyGraphGetFollowsOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let follows: [AppBskyActorDefsProfileView]
	public let subject: AppBskyActorDefsProfileView

	public init(
		cursor: String? = nil,
		follows: [AppBskyActorDefsProfileView],
		subject: AppBskyActorDefsProfileView
	) {
		self.cursor = cursor
		self.follows = follows
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		follows = try container.decode([AppBskyActorDefsProfileView].self, forKey: .follows)
		subject = try container.decode(AppBskyActorDefsProfileView.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(follows, forKey: .follows)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case follows = "follows"
		case subject = "subject"
	}
}


public struct AppBskyGraphGetFollowsParameters: Codable, Sendable, Equatable {
	public let actor: ATIdentifier
	public let cursor: String?
	public let limit: Int?

	public init(
		actor: ATIdentifier,
		cursor: String? = nil,
		limit: Int? = nil
	) {
		self.actor = actor
		self.cursor = cursor
		self.limit = limit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(ATIdentifier.self, forKey: .actor)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		actor.appendQueryItems(named: "actor", to: &items)
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case cursor = "cursor"
		case limit = "limit"
	}
}


public struct AppBskyGraphGetKnownFollowersOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let followers: [AppBskyActorDefsProfileView]
	public let subject: AppBskyActorDefsProfileView

	public init(
		cursor: String? = nil,
		followers: [AppBskyActorDefsProfileView],
		subject: AppBskyActorDefsProfileView
	) {
		self.cursor = cursor
		self.followers = followers
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		followers = try container.decode([AppBskyActorDefsProfileView].self, forKey: .followers)
		subject = try container.decode(AppBskyActorDefsProfileView.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(followers, forKey: .followers)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case followers = "followers"
		case subject = "subject"
	}
}


public struct AppBskyGraphGetKnownFollowersParameters: Codable, Sendable, Equatable {
	public let actor: ATIdentifier
	public let cursor: String?
	public let limit: Int?

	public init(
		actor: ATIdentifier,
		cursor: String? = nil,
		limit: Int? = nil
	) {
		self.actor = actor
		self.cursor = cursor
		self.limit = limit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(ATIdentifier.self, forKey: .actor)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		actor.appendQueryItems(named: "actor", to: &items)
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case cursor = "cursor"
		case limit = "limit"
	}
}


public struct AppBskyGraphGetListBlocksOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let lists: [AppBskyGraphDefsListView]

	public init(
		cursor: String? = nil,
		lists: [AppBskyGraphDefsListView]
	) {
		self.cursor = cursor
		self.lists = lists
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		lists = try container.decode([AppBskyGraphDefsListView].self, forKey: .lists)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(lists, forKey: .lists)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case lists = "lists"
	}
}


public struct AppBskyGraphGetListBlocksParameters: Codable, Sendable, Equatable {
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


public struct AppBskyGraphGetListMutesOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let lists: [AppBskyGraphDefsListView]

	public init(
		cursor: String? = nil,
		lists: [AppBskyGraphDefsListView]
	) {
		self.cursor = cursor
		self.lists = lists
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		lists = try container.decode([AppBskyGraphDefsListView].self, forKey: .lists)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(lists, forKey: .lists)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case lists = "lists"
	}
}


public struct AppBskyGraphGetListMutesParameters: Codable, Sendable, Equatable {
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


public struct AppBskyGraphGetListOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let items: [AppBskyGraphDefsListItemView]
	public let list: AppBskyGraphDefsListView

	public init(
		cursor: String? = nil,
		items: [AppBskyGraphDefsListItemView],
		list: AppBskyGraphDefsListView
	) {
		self.cursor = cursor
		self.items = items
		self.list = list
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		items = try container.decode([AppBskyGraphDefsListItemView].self, forKey: .items)
		list = try container.decode(AppBskyGraphDefsListView.self, forKey: .list)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(items, forKey: .items)
		try container.encode(list, forKey: .list)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case items = "items"
		case list = "list"
	}
}


public struct AppBskyGraphGetListParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?
	public let list: ATURI

	public init(
		cursor: String? = nil,
		limit: Int? = nil,
		list: ATURI
	) {
		self.cursor = cursor
		self.limit = limit
		self.list = list
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		list = try container.decode(ATURI.self, forKey: .list)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encode(list, forKey: .list)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		list.appendQueryItems(named: "list", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
		case list = "list"
	}
}


public struct AppBskyGraphGetListsOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let lists: [AppBskyGraphDefsListView]

	public init(
		cursor: String? = nil,
		lists: [AppBskyGraphDefsListView]
	) {
		self.cursor = cursor
		self.lists = lists
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		lists = try container.decode([AppBskyGraphDefsListView].self, forKey: .lists)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(lists, forKey: .lists)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case lists = "lists"
	}
}


public struct AppBskyGraphGetListsParameters: Codable, Sendable, Equatable {
	public let actor: ATIdentifier
	public let cursor: String?
	public let limit: Int?
	public let purposes: [AppBskyGraphGetListsParametersPurposesItem]?

	public init(
		actor: ATIdentifier,
		cursor: String? = nil,
		limit: Int? = nil,
		purposes: [AppBskyGraphGetListsParametersPurposesItem]? = nil
	) {
		self.actor = actor
		self.cursor = cursor
		self.limit = limit
		self.purposes = purposes
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(ATIdentifier.self, forKey: .actor)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		purposes = try container.decodeIfPresent([AppBskyGraphGetListsParametersPurposesItem].self, forKey: .purposes)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encodeIfPresent(purposes, forKey: .purposes)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		actor.appendQueryItems(named: "actor", to: &items)
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		if let value = purposes {
			value.appendQueryItems(named: "purposes", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case cursor = "cursor"
		case limit = "limit"
		case purposes = "purposes"
	}
}


public enum AppBskyGraphGetListsParametersPurposesItem: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case modlist = "modlist"
	case curatelist = "curatelist"
}


public struct AppBskyGraphGetListsWithMembershipListWithMembership: Codable, Sendable, Equatable {
	public let list: AppBskyGraphDefsListView
	public let listItem: AppBskyGraphDefsListItemView?

	public init(
		list: AppBskyGraphDefsListView,
		listItem: AppBskyGraphDefsListItemView? = nil
	) {
		self.list = list
		self.listItem = listItem
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		list = try container.decode(AppBskyGraphDefsListView.self, forKey: .list)
		listItem = try container.decodeIfPresent(AppBskyGraphDefsListItemView.self, forKey: .listItem)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(list, forKey: .list)
		try container.encodeIfPresent(listItem, forKey: .listItem)
	}

	private enum CodingKeys: String, CodingKey {
		case list = "list"
		case listItem = "listItem"
	}
}


public struct AppBskyGraphGetListsWithMembershipOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let listsWithMembership: [AppBskyGraphGetListsWithMembershipListWithMembership]

	public init(
		cursor: String? = nil,
		listsWithMembership: [AppBskyGraphGetListsWithMembershipListWithMembership]
	) {
		self.cursor = cursor
		self.listsWithMembership = listsWithMembership
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		listsWithMembership = try container.decode([AppBskyGraphGetListsWithMembershipListWithMembership].self, forKey: .listsWithMembership)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(listsWithMembership, forKey: .listsWithMembership)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case listsWithMembership = "listsWithMembership"
	}
}


public struct AppBskyGraphGetListsWithMembershipParameters: Codable, Sendable, Equatable {
	public let actor: ATIdentifier
	public let cursor: String?
	public let limit: Int?
	public let purposes: [AppBskyGraphGetListsParametersPurposesItem]?

	public init(
		actor: ATIdentifier,
		cursor: String? = nil,
		limit: Int? = nil,
		purposes: [AppBskyGraphGetListsParametersPurposesItem]? = nil
	) {
		self.actor = actor
		self.cursor = cursor
		self.limit = limit
		self.purposes = purposes
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(ATIdentifier.self, forKey: .actor)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		purposes = try container.decodeIfPresent([AppBskyGraphGetListsParametersPurposesItem].self, forKey: .purposes)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encodeIfPresent(purposes, forKey: .purposes)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		actor.appendQueryItems(named: "actor", to: &items)
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		if let value = purposes {
			value.appendQueryItems(named: "purposes", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case cursor = "cursor"
		case limit = "limit"
		case purposes = "purposes"
	}
}


public struct AppBskyGraphGetMutesOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let mutes: [AppBskyActorDefsProfileView]

	public init(
		cursor: String? = nil,
		mutes: [AppBskyActorDefsProfileView]
	) {
		self.cursor = cursor
		self.mutes = mutes
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		mutes = try container.decode([AppBskyActorDefsProfileView].self, forKey: .mutes)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(mutes, forKey: .mutes)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case mutes = "mutes"
	}
}


public struct AppBskyGraphGetMutesParameters: Codable, Sendable, Equatable {
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


public enum AppBskyGraphGetRelationshipsError: String, Swift.Error, CaseIterable, Sendable {
	case actorNotFound = "ActorNotFound"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct AppBskyGraphGetRelationshipsOutput: Codable, Sendable, Equatable {
	public let actor: DID?
	public let relationships: [AppBskyGraphGetRelationshipsOutputRelationshipsItem]

	public init(
		actor: DID? = nil,
		relationships: [AppBskyGraphGetRelationshipsOutputRelationshipsItem]
	) {
		self.actor = actor
		self.relationships = relationships
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decodeIfPresent(DID.self, forKey: .actor)
		relationships = try container.decode([AppBskyGraphGetRelationshipsOutputRelationshipsItem].self, forKey: .relationships)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(actor, forKey: .actor)
		try container.encode(relationships, forKey: .relationships)
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case relationships = "relationships"
	}
}


public indirect enum AppBskyGraphGetRelationshipsOutputRelationshipsItem: Codable, Sendable, Equatable {
	case relationship(AppBskyGraphDefsRelationship)
	case notFoundActor(AppBskyGraphDefsNotFoundActor)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "app.bsky.graph.defs#relationship": self = .relationship(try AppBskyGraphDefsRelationship(from: decoder))
		case "app.bsky.graph.defs#notFoundActor": self = .notFoundActor(try AppBskyGraphDefsNotFoundActor(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .relationship(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.graph.defs#relationship", to: encoder)
		case .notFoundActor(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.graph.defs#notFoundActor", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct AppBskyGraphGetRelationshipsParameters: Codable, Sendable, Equatable {
	public let actor: ATIdentifier
	public let others: [ATIdentifier]?

	public init(
		actor: ATIdentifier,
		others: [ATIdentifier]? = nil
	) {
		self.actor = actor
		self.others = others
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(ATIdentifier.self, forKey: .actor)
		others = try container.decodeIfPresent([ATIdentifier].self, forKey: .others)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
		try container.encodeIfPresent(others, forKey: .others)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		actor.appendQueryItems(named: "actor", to: &items)
		if let value = others {
			value.appendQueryItems(named: "others", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case others = "others"
	}
}


public struct AppBskyGraphGetStarterPackOutput: Codable, Sendable, Equatable {
	public let starterPack: AppBskyGraphDefsStarterPackView

	public init(
		starterPack: AppBskyGraphDefsStarterPackView
	) {
		self.starterPack = starterPack
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		starterPack = try container.decode(AppBskyGraphDefsStarterPackView.self, forKey: .starterPack)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(starterPack, forKey: .starterPack)
	}

	private enum CodingKeys: String, CodingKey {
		case starterPack = "starterPack"
	}
}


public struct AppBskyGraphGetStarterPackParameters: Codable, Sendable, Equatable {
	public let starterPack: ATURI

	public init(
		starterPack: ATURI
	) {
		self.starterPack = starterPack
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		starterPack = try container.decode(ATURI.self, forKey: .starterPack)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(starterPack, forKey: .starterPack)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		starterPack.appendQueryItems(named: "starterPack", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case starterPack = "starterPack"
	}
}


public struct AppBskyGraphGetStarterPacksOutput: Codable, Sendable, Equatable {
	public let starterPacks: [AppBskyGraphDefsStarterPackViewBasic]

	public init(
		starterPacks: [AppBskyGraphDefsStarterPackViewBasic]
	) {
		self.starterPacks = starterPacks
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		starterPacks = try container.decode([AppBskyGraphDefsStarterPackViewBasic].self, forKey: .starterPacks)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(starterPacks, forKey: .starterPacks)
	}

	private enum CodingKeys: String, CodingKey {
		case starterPacks = "starterPacks"
	}
}


public struct AppBskyGraphGetStarterPacksParameters: Codable, Sendable, Equatable {
	public let uris: [ATURI]

	public init(
		uris: [ATURI]
	) {
		self.uris = uris
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		uris = try container.decode([ATURI].self, forKey: .uris)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(uris, forKey: .uris)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		uris.appendQueryItems(named: "uris", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case uris = "uris"
	}
}


public struct AppBskyGraphGetStarterPacksWithMembershipOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let starterPacksWithMembership: [AppBskyGraphGetStarterPacksWithMembershipStarterPackWithMembership]

	public init(
		cursor: String? = nil,
		starterPacksWithMembership: [AppBskyGraphGetStarterPacksWithMembershipStarterPackWithMembership]
	) {
		self.cursor = cursor
		self.starterPacksWithMembership = starterPacksWithMembership
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		starterPacksWithMembership = try container.decode([AppBskyGraphGetStarterPacksWithMembershipStarterPackWithMembership].self, forKey: .starterPacksWithMembership)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(starterPacksWithMembership, forKey: .starterPacksWithMembership)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case starterPacksWithMembership = "starterPacksWithMembership"
	}
}


public struct AppBskyGraphGetStarterPacksWithMembershipParameters: Codable, Sendable, Equatable {
	public let actor: ATIdentifier
	public let cursor: String?
	public let limit: Int?

	public init(
		actor: ATIdentifier,
		cursor: String? = nil,
		limit: Int? = nil
	) {
		self.actor = actor
		self.cursor = cursor
		self.limit = limit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(ATIdentifier.self, forKey: .actor)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		actor.appendQueryItems(named: "actor", to: &items)
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case cursor = "cursor"
		case limit = "limit"
	}
}


public struct AppBskyGraphGetStarterPacksWithMembershipStarterPackWithMembership: Codable, Sendable, Equatable {
	public let listItem: AppBskyGraphDefsListItemView?
	public let starterPack: AppBskyGraphDefsStarterPackView

	public init(
		listItem: AppBskyGraphDefsListItemView? = nil,
		starterPack: AppBskyGraphDefsStarterPackView
	) {
		self.listItem = listItem
		self.starterPack = starterPack
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		listItem = try container.decodeIfPresent(AppBskyGraphDefsListItemView.self, forKey: .listItem)
		starterPack = try container.decode(AppBskyGraphDefsStarterPackView.self, forKey: .starterPack)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(listItem, forKey: .listItem)
		try container.encode(starterPack, forKey: .starterPack)
	}

	private enum CodingKeys: String, CodingKey {
		case listItem = "listItem"
		case starterPack = "starterPack"
	}
}


public struct AppBskyGraphGetSuggestedFollowsByActorOutput: Codable, Sendable, Equatable {
	public let isFallback: Bool?
	public let recId: Int?
	public let recIdStr: String?
	public let suggestions: [AppBskyActorDefsProfileView]

	public init(
		isFallback: Bool? = nil,
		recId: Int? = nil,
		recIdStr: String? = nil,
		suggestions: [AppBskyActorDefsProfileView]
	) {
		self.isFallback = isFallback
		self.recId = recId
		self.recIdStr = recIdStr
		self.suggestions = suggestions
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		isFallback = try container.decodeIfPresent(Bool.self, forKey: .isFallback)
		recId = try container.decodeIfPresent(Int.self, forKey: .recId)
		recIdStr = try container.decodeIfPresent(String.self, forKey: .recIdStr)
		suggestions = try container.decode([AppBskyActorDefsProfileView].self, forKey: .suggestions)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(isFallback, forKey: .isFallback)
		try container.encodeIfPresent(recId, forKey: .recId)
		try container.encodeIfPresent(recIdStr, forKey: .recIdStr)
		try container.encode(suggestions, forKey: .suggestions)
	}

	private enum CodingKeys: String, CodingKey {
		case isFallback = "isFallback"
		case recId = "recId"
		case recIdStr = "recIdStr"
		case suggestions = "suggestions"
	}
}


public struct AppBskyGraphGetSuggestedFollowsByActorParameters: Codable, Sendable, Equatable {
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


public struct AppBskyGraphList: Codable, Sendable, Equatable {
	public static let typeIdentifier = "app.bsky.graph.list"

	public let avatar: Blob?
	public let createdAt: ATProtocolDate
	public let description: String?
	public let descriptionFacets: [AppBskyRichtextFacet]?
	public let labels: AppBskyGraphListLabels?
	public let name: String
	public let purpose: AppBskyGraphDefsListPurpose

	public init(
		avatar: Blob? = nil,
		createdAt: ATProtocolDate,
		description: String? = nil,
		descriptionFacets: [AppBskyRichtextFacet]? = nil,
		labels: AppBskyGraphListLabels? = nil,
		name: String,
		purpose: AppBskyGraphDefsListPurpose
	) {
		self.avatar = avatar
		self.createdAt = createdAt
		self.description = description
		self.descriptionFacets = descriptionFacets
		self.labels = labels
		self.name = name
		self.purpose = purpose
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		avatar = try container.decodeIfPresent(Blob.self, forKey: .avatar)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		description = try container.decodeIfPresent(String.self, forKey: .description)
		descriptionFacets = try container.decodeIfPresent([AppBskyRichtextFacet].self, forKey: .descriptionFacets)
		labels = try container.decodeIfPresent(AppBskyGraphListLabels.self, forKey: .labels)
		name = try container.decode(String.self, forKey: .name)
		purpose = try container.decode(AppBskyGraphDefsListPurpose.self, forKey: .purpose)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.typeIdentifier, forKey: .typeIdentifier)
		try container.encodeIfPresent(avatar, forKey: .avatar)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encodeIfPresent(descriptionFacets, forKey: .descriptionFacets)
		try container.encodeIfPresent(labels, forKey: .labels)
		try container.encode(name, forKey: .name)
		try container.encode(purpose, forKey: .purpose)
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case avatar = "avatar"
		case createdAt = "createdAt"
		case description = "description"
		case descriptionFacets = "descriptionFacets"
		case labels = "labels"
		case name = "name"
		case purpose = "purpose"
	}
}


public struct AppBskyGraphListblock: Codable, Sendable, Equatable {
	public static let typeIdentifier = "app.bsky.graph.listblock"

	public let createdAt: ATProtocolDate
	public let subject: ATURI

	public init(
		createdAt: ATProtocolDate,
		subject: ATURI
	) {
		self.createdAt = createdAt
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		subject = try container.decode(ATURI.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.typeIdentifier, forKey: .typeIdentifier)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case createdAt = "createdAt"
		case subject = "subject"
	}
}


public struct AppBskyGraphListitem: Codable, Sendable, Equatable {
	public static let typeIdentifier = "app.bsky.graph.listitem"

	public let createdAt: ATProtocolDate
	public let list: ATURI
	public let subject: DID

	public init(
		createdAt: ATProtocolDate,
		list: ATURI,
		subject: DID
	) {
		self.createdAt = createdAt
		self.list = list
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		list = try container.decode(ATURI.self, forKey: .list)
		subject = try container.decode(DID.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.typeIdentifier, forKey: .typeIdentifier)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encode(list, forKey: .list)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case createdAt = "createdAt"
		case list = "list"
		case subject = "subject"
	}
}


public indirect enum AppBskyGraphListLabels: Codable, Sendable, Equatable {
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


public struct AppBskyGraphMuteActorInput: Codable, Sendable, Equatable {
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

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
	}
}


public struct AppBskyGraphMuteActorListInput: Codable, Sendable, Equatable {
	public let list: ATURI

	public init(
		list: ATURI
	) {
		self.list = list
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		list = try container.decode(ATURI.self, forKey: .list)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(list, forKey: .list)
	}

	private enum CodingKeys: String, CodingKey {
		case list = "list"
	}
}


public struct AppBskyGraphMuteThreadInput: Codable, Sendable, Equatable {
	public let root: ATURI

	public init(
		root: ATURI
	) {
		self.root = root
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		root = try container.decode(ATURI.self, forKey: .root)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(root, forKey: .root)
	}

	private enum CodingKeys: String, CodingKey {
		case root = "root"
	}
}


public struct AppBskyGraphSearchStarterPacksOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let starterPacks: [AppBskyGraphDefsStarterPackViewBasic]

	public init(
		cursor: String? = nil,
		starterPacks: [AppBskyGraphDefsStarterPackViewBasic]
	) {
		self.cursor = cursor
		self.starterPacks = starterPacks
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		starterPacks = try container.decode([AppBskyGraphDefsStarterPackViewBasic].self, forKey: .starterPacks)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(starterPacks, forKey: .starterPacks)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case starterPacks = "starterPacks"
	}
}


public struct AppBskyGraphSearchStarterPacksParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?
	public let q: String

	public init(
		cursor: String? = nil,
		limit: Int? = nil,
		q: String
	) {
		self.cursor = cursor
		self.limit = limit
		self.q = q
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		q = try container.decode(String.self, forKey: .q)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encode(q, forKey: .q)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		q.appendQueryItems(named: "q", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
		case q = "q"
	}
}


public struct AppBskyGraphStarterpack: Codable, Sendable, Equatable {
	public static let typeIdentifier = "app.bsky.graph.starterpack"

	public let createdAt: ATProtocolDate
	public let description: String?
	public let descriptionFacets: [AppBskyRichtextFacet]?
	public let feeds: [AppBskyGraphStarterpackFeedItem]?
	public let list: ATURI
	public let name: String

	public init(
		createdAt: ATProtocolDate,
		description: String? = nil,
		descriptionFacets: [AppBskyRichtextFacet]? = nil,
		feeds: [AppBskyGraphStarterpackFeedItem]? = nil,
		list: ATURI,
		name: String
	) {
		self.createdAt = createdAt
		self.description = description
		self.descriptionFacets = descriptionFacets
		self.feeds = feeds
		self.list = list
		self.name = name
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		description = try container.decodeIfPresent(String.self, forKey: .description)
		descriptionFacets = try container.decodeIfPresent([AppBskyRichtextFacet].self, forKey: .descriptionFacets)
		feeds = try container.decodeIfPresent([AppBskyGraphStarterpackFeedItem].self, forKey: .feeds)
		list = try container.decode(ATURI.self, forKey: .list)
		name = try container.decode(String.self, forKey: .name)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.typeIdentifier, forKey: .typeIdentifier)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encodeIfPresent(descriptionFacets, forKey: .descriptionFacets)
		try container.encodeIfPresent(feeds, forKey: .feeds)
		try container.encode(list, forKey: .list)
		try container.encode(name, forKey: .name)
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case createdAt = "createdAt"
		case description = "description"
		case descriptionFacets = "descriptionFacets"
		case feeds = "feeds"
		case list = "list"
		case name = "name"
	}
}


public struct AppBskyGraphStarterpackFeedItem: Codable, Sendable, Equatable {
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


public struct AppBskyGraphUnmuteActorInput: Codable, Sendable, Equatable {
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

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
	}
}


public struct AppBskyGraphUnmuteActorListInput: Codable, Sendable, Equatable {
	public let list: ATURI

	public init(
		list: ATURI
	) {
		self.list = list
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		list = try container.decode(ATURI.self, forKey: .list)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(list, forKey: .list)
	}

	private enum CodingKeys: String, CodingKey {
		case list = "list"
	}
}


public struct AppBskyGraphUnmuteThreadInput: Codable, Sendable, Equatable {
	public let root: ATURI

	public init(
		root: ATURI
	) {
		self.root = root
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		root = try container.decode(ATURI.self, forKey: .root)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(root, forKey: .root)
	}

	private enum CodingKeys: String, CodingKey {
		case root = "root"
	}
}


public struct AppBskyGraphVerification: Codable, Sendable, Equatable {
	public static let typeIdentifier = "app.bsky.graph.verification"

	public let createdAt: ATProtocolDate
	public let displayName: String
	public let handle: Handle
	public let subject: DID

	public init(
		createdAt: ATProtocolDate,
		displayName: String,
		handle: Handle,
		subject: DID
	) {
		self.createdAt = createdAt
		self.displayName = displayName
		self.handle = handle
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		displayName = try container.decode(String.self, forKey: .displayName)
		handle = try container.decode(Handle.self, forKey: .handle)
		subject = try container.decode(DID.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.typeIdentifier, forKey: .typeIdentifier)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encode(displayName, forKey: .displayName)
		try container.encode(handle, forKey: .handle)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case createdAt = "createdAt"
		case displayName = "displayName"
		case handle = "handle"
		case subject = "subject"
	}
}


