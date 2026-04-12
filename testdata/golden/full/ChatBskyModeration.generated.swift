import Foundation


public struct ChatBskyModerationGetActorMetadataMetadata: Codable, Sendable, Equatable {
	public let convos: Int
	public let convosStarted: Int
	public let messagesReceived: Int
	public let messagesSent: Int

	public init(
		convos: Int,
		convosStarted: Int,
		messagesReceived: Int,
		messagesSent: Int
	) {
		self.convos = convos
		self.convosStarted = convosStarted
		self.messagesReceived = messagesReceived
		self.messagesSent = messagesSent
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convos = try container.decode(Int.self, forKey: .convos)
		convosStarted = try container.decode(Int.self, forKey: .convosStarted)
		messagesReceived = try container.decode(Int.self, forKey: .messagesReceived)
		messagesSent = try container.decode(Int.self, forKey: .messagesSent)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convos, forKey: .convos)
		try container.encode(convosStarted, forKey: .convosStarted)
		try container.encode(messagesReceived, forKey: .messagesReceived)
		try container.encode(messagesSent, forKey: .messagesSent)
	}

	private enum CodingKeys: String, CodingKey {
		case convos = "convos"
		case convosStarted = "convosStarted"
		case messagesReceived = "messagesReceived"
		case messagesSent = "messagesSent"
	}
}


public struct ChatBskyModerationGetActorMetadataOutput: Codable, Sendable, Equatable {
	public let all: ChatBskyModerationGetActorMetadataMetadata
	public let day: ChatBskyModerationGetActorMetadataMetadata
	public let month: ChatBskyModerationGetActorMetadataMetadata

	public init(
		all: ChatBskyModerationGetActorMetadataMetadata,
		day: ChatBskyModerationGetActorMetadataMetadata,
		month: ChatBskyModerationGetActorMetadataMetadata
	) {
		self.all = all
		self.day = day
		self.month = month
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		all = try container.decode(ChatBskyModerationGetActorMetadataMetadata.self, forKey: .all)
		day = try container.decode(ChatBskyModerationGetActorMetadataMetadata.self, forKey: .day)
		month = try container.decode(ChatBskyModerationGetActorMetadataMetadata.self, forKey: .month)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(all, forKey: .all)
		try container.encode(day, forKey: .day)
		try container.encode(month, forKey: .month)
	}

	private enum CodingKeys: String, CodingKey {
		case all = "all"
		case day = "day"
		case month = "month"
	}
}


public struct ChatBskyModerationGetActorMetadataParameters: Codable, Sendable, Equatable {
	public let actor: DID

	public init(
		actor: DID
	) {
		self.actor = actor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(DID.self, forKey: .actor)
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


public struct ChatBskyModerationGetMessageContextOutput: Codable, Sendable, Equatable {
	public let messages: [ChatBskyModerationGetMessageContextOutputMessagesItem]

	public init(
		messages: [ChatBskyModerationGetMessageContextOutputMessagesItem]
	) {
		self.messages = messages
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		messages = try container.decode([ChatBskyModerationGetMessageContextOutputMessagesItem].self, forKey: .messages)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(messages, forKey: .messages)
	}

	private enum CodingKeys: String, CodingKey {
		case messages = "messages"
	}
}


public indirect enum ChatBskyModerationGetMessageContextOutputMessagesItem: Codable, Sendable, Equatable {
	case messageView(ChatBskyConvoDefsMessageView)
	case deletedMessageView(ChatBskyConvoDefsDeletedMessageView)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "chat.bsky.convo.defs#messageView": self = .messageView(try ChatBskyConvoDefsMessageView(from: decoder))
		case "chat.bsky.convo.defs#deletedMessageView": self = .deletedMessageView(try ChatBskyConvoDefsDeletedMessageView(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .messageView(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#messageView", to: encoder)
		case .deletedMessageView(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#deletedMessageView", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct ChatBskyModerationGetMessageContextParameters: Codable, Sendable, Equatable {
	public let after: Int?
	public let before: Int?
	public let convoId: String?
	public let messageId: String

	public init(
		after: Int? = nil,
		before: Int? = nil,
		convoId: String? = nil,
		messageId: String
	) {
		self.after = after
		self.before = before
		self.convoId = convoId
		self.messageId = messageId
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		after = try container.decodeIfPresent(Int.self, forKey: .after)
		before = try container.decodeIfPresent(Int.self, forKey: .before)
		convoId = try container.decodeIfPresent(String.self, forKey: .convoId)
		messageId = try container.decode(String.self, forKey: .messageId)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(after, forKey: .after)
		try container.encodeIfPresent(before, forKey: .before)
		try container.encodeIfPresent(convoId, forKey: .convoId)
		try container.encode(messageId, forKey: .messageId)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = after {
			value.appendQueryItems(named: "after", to: &items)
		}
		if let value = before {
			value.appendQueryItems(named: "before", to: &items)
		}
		if let value = convoId {
			value.appendQueryItems(named: "convoId", to: &items)
		}
		messageId.appendQueryItems(named: "messageId", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case after = "after"
		case before = "before"
		case convoId = "convoId"
		case messageId = "messageId"
	}
}


public struct ChatBskyModerationUpdateActorAccessInput: Codable, Sendable, Equatable {
	public let actor: DID
	public let allowAccess: Bool
	public let ref: String?

	public init(
		actor: DID,
		allowAccess: Bool,
		ref: String? = nil
	) {
		self.actor = actor
		self.allowAccess = allowAccess
		self.ref = ref
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		actor = try container.decode(DID.self, forKey: .actor)
		allowAccess = try container.decode(Bool.self, forKey: .allowAccess)
		ref = try container.decodeIfPresent(String.self, forKey: .ref)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(actor, forKey: .actor)
		try container.encode(allowAccess, forKey: .allowAccess)
		try container.encodeIfPresent(ref, forKey: .ref)
	}

	private enum CodingKeys: String, CodingKey {
		case actor = "actor"
		case allowAccess = "allowAccess"
		case ref = "ref"
	}
}


