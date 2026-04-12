import Foundation


public struct ChatBskyConvoAcceptConvoInput: Codable, Sendable, Equatable {
	public let convoId: String

	public init(
		convoId: String
	) {
		self.convoId = convoId
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
	}
}


public struct ChatBskyConvoAcceptConvoOutput: Codable, Sendable, Equatable {
	public let rev: String?

	public init(
		rev: String? = nil
	) {
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		rev = try container.decodeIfPresent(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case rev = "rev"
	}
}


public enum ChatBskyConvoAddReactionError: String, Swift.Error, CaseIterable, Sendable {
	case reactionInvalidValue = "ReactionInvalidValue"
	case reactionLimitReached = "ReactionLimitReached"
	case reactionMessageDeleted = "ReactionMessageDeleted"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ChatBskyConvoAddReactionInput: Codable, Sendable, Equatable {
	public let convoId: String
	public let messageId: String
	public let value: String

	public init(
		convoId: String,
		messageId: String,
		value: String
	) {
		self.convoId = convoId
		self.messageId = messageId
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		messageId = try container.decode(String.self, forKey: .messageId)
		value = try container.decode(String.self, forKey: .value)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(messageId, forKey: .messageId)
		try container.encode(value, forKey: .value)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case messageId = "messageId"
		case value = "value"
	}
}


public struct ChatBskyConvoAddReactionOutput: Codable, Sendable, Equatable {
	public let message: ChatBskyConvoDefsMessageView

	public init(
		message: ChatBskyConvoDefsMessageView
	) {
		self.message = message
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		message = try container.decode(ChatBskyConvoDefsMessageView.self, forKey: .message)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(message, forKey: .message)
	}

	private enum CodingKeys: String, CodingKey {
		case message = "message"
	}
}


public struct ChatBskyConvoDefsConvoView: Codable, Sendable, Equatable {
	public let id: String
	public let lastMessage: ChatBskyConvoDefsConvoViewLastMessage?
	public let lastReaction: ChatBskyConvoDefsConvoViewLastReaction?
	public let members: [ChatBskyActorDefsProfileViewBasic]
	public let muted: Bool
	public let rev: String
	public let status: ChatBskyConvoDefsConvoViewStatus?
	public let unreadCount: Int

	public init(
		id: String,
		lastMessage: ChatBskyConvoDefsConvoViewLastMessage? = nil,
		lastReaction: ChatBskyConvoDefsConvoViewLastReaction? = nil,
		members: [ChatBskyActorDefsProfileViewBasic],
		muted: Bool,
		rev: String,
		status: ChatBskyConvoDefsConvoViewStatus? = nil,
		unreadCount: Int
	) {
		self.id = id
		self.lastMessage = lastMessage
		self.lastReaction = lastReaction
		self.members = members
		self.muted = muted
		self.rev = rev
		self.status = status
		self.unreadCount = unreadCount
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(String.self, forKey: .id)
		lastMessage = try container.decodeIfPresent(ChatBskyConvoDefsConvoViewLastMessage.self, forKey: .lastMessage)
		lastReaction = try container.decodeIfPresent(ChatBskyConvoDefsConvoViewLastReaction.self, forKey: .lastReaction)
		members = try container.decode([ChatBskyActorDefsProfileViewBasic].self, forKey: .members)
		muted = try container.decode(Bool.self, forKey: .muted)
		rev = try container.decode(String.self, forKey: .rev)
		status = try container.decodeIfPresent(ChatBskyConvoDefsConvoViewStatus.self, forKey: .status)
		unreadCount = try container.decode(Int.self, forKey: .unreadCount)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encodeIfPresent(lastMessage, forKey: .lastMessage)
		try container.encodeIfPresent(lastReaction, forKey: .lastReaction)
		try container.encode(members, forKey: .members)
		try container.encode(muted, forKey: .muted)
		try container.encode(rev, forKey: .rev)
		try container.encodeIfPresent(status, forKey: .status)
		try container.encode(unreadCount, forKey: .unreadCount)
	}

	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case lastMessage = "lastMessage"
		case lastReaction = "lastReaction"
		case members = "members"
		case muted = "muted"
		case rev = "rev"
		case status = "status"
		case unreadCount = "unreadCount"
	}
}


public indirect enum ChatBskyConvoDefsConvoViewLastMessage: Codable, Sendable, Equatable {
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


public indirect enum ChatBskyConvoDefsConvoViewLastReaction: Codable, Sendable, Equatable {
	case messageAndReactionView(ChatBskyConvoDefsMessageAndReactionView)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "chat.bsky.convo.defs#messageAndReactionView": self = .messageAndReactionView(try ChatBskyConvoDefsMessageAndReactionView(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .messageAndReactionView(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#messageAndReactionView", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public enum ChatBskyConvoDefsConvoViewStatus: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case request = "request"
	case accepted = "accepted"
}


public struct ChatBskyConvoDefsDeletedMessageView: Codable, Sendable, Equatable {
	public let id: String
	public let rev: String
	public let sender: ChatBskyConvoDefsMessageViewSender
	public let sentAt: ATProtocolDate

	public init(
		id: String,
		rev: String,
		sender: ChatBskyConvoDefsMessageViewSender,
		sentAt: ATProtocolDate
	) {
		self.id = id
		self.rev = rev
		self.sender = sender
		self.sentAt = sentAt
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(String.self, forKey: .id)
		rev = try container.decode(String.self, forKey: .rev)
		sender = try container.decode(ChatBskyConvoDefsMessageViewSender.self, forKey: .sender)
		sentAt = try container.decode(ATProtocolDate.self, forKey: .sentAt)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(rev, forKey: .rev)
		try container.encode(sender, forKey: .sender)
		try container.encode(sentAt, forKey: .sentAt)
	}

	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case rev = "rev"
		case sender = "sender"
		case sentAt = "sentAt"
	}
}


public struct ChatBskyConvoDefsLogAcceptConvo: Codable, Sendable, Equatable {
	public let convoId: String
	public let rev: String

	public init(
		convoId: String,
		rev: String
	) {
		self.convoId = convoId
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case rev = "rev"
	}
}


public struct ChatBskyConvoDefsLogAddReaction: Codable, Sendable, Equatable {
	public let convoId: String
	public let message: ChatBskyConvoDefsConvoViewLastMessage
	public let reaction: ChatBskyConvoDefsReactionView
	public let rev: String

	public init(
		convoId: String,
		message: ChatBskyConvoDefsConvoViewLastMessage,
		reaction: ChatBskyConvoDefsReactionView,
		rev: String
	) {
		self.convoId = convoId
		self.message = message
		self.reaction = reaction
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		message = try container.decode(ChatBskyConvoDefsConvoViewLastMessage.self, forKey: .message)
		reaction = try container.decode(ChatBskyConvoDefsReactionView.self, forKey: .reaction)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(message, forKey: .message)
		try container.encode(reaction, forKey: .reaction)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case message = "message"
		case reaction = "reaction"
		case rev = "rev"
	}
}


public struct ChatBskyConvoDefsLogBeginConvo: Codable, Sendable, Equatable {
	public let convoId: String
	public let rev: String

	public init(
		convoId: String,
		rev: String
	) {
		self.convoId = convoId
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case rev = "rev"
	}
}


public struct ChatBskyConvoDefsLogCreateMessage: Codable, Sendable, Equatable {
	public let convoId: String
	public let message: ChatBskyConvoDefsConvoViewLastMessage
	public let rev: String

	public init(
		convoId: String,
		message: ChatBskyConvoDefsConvoViewLastMessage,
		rev: String
	) {
		self.convoId = convoId
		self.message = message
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		message = try container.decode(ChatBskyConvoDefsConvoViewLastMessage.self, forKey: .message)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(message, forKey: .message)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case message = "message"
		case rev = "rev"
	}
}


public struct ChatBskyConvoDefsLogDeleteMessage: Codable, Sendable, Equatable {
	public let convoId: String
	public let message: ChatBskyConvoDefsConvoViewLastMessage
	public let rev: String

	public init(
		convoId: String,
		message: ChatBskyConvoDefsConvoViewLastMessage,
		rev: String
	) {
		self.convoId = convoId
		self.message = message
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		message = try container.decode(ChatBskyConvoDefsConvoViewLastMessage.self, forKey: .message)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(message, forKey: .message)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case message = "message"
		case rev = "rev"
	}
}


public struct ChatBskyConvoDefsLogLeaveConvo: Codable, Sendable, Equatable {
	public let convoId: String
	public let rev: String

	public init(
		convoId: String,
		rev: String
	) {
		self.convoId = convoId
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case rev = "rev"
	}
}


public struct ChatBskyConvoDefsLogMuteConvo: Codable, Sendable, Equatable {
	public let convoId: String
	public let rev: String

	public init(
		convoId: String,
		rev: String
	) {
		self.convoId = convoId
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case rev = "rev"
	}
}


public struct ChatBskyConvoDefsLogReadMessage: Codable, Sendable, Equatable {
	public let convoId: String
	public let message: ChatBskyConvoDefsConvoViewLastMessage
	public let rev: String

	public init(
		convoId: String,
		message: ChatBskyConvoDefsConvoViewLastMessage,
		rev: String
	) {
		self.convoId = convoId
		self.message = message
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		message = try container.decode(ChatBskyConvoDefsConvoViewLastMessage.self, forKey: .message)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(message, forKey: .message)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case message = "message"
		case rev = "rev"
	}
}


public struct ChatBskyConvoDefsLogRemoveReaction: Codable, Sendable, Equatable {
	public let convoId: String
	public let message: ChatBskyConvoDefsConvoViewLastMessage
	public let reaction: ChatBskyConvoDefsReactionView
	public let rev: String

	public init(
		convoId: String,
		message: ChatBskyConvoDefsConvoViewLastMessage,
		reaction: ChatBskyConvoDefsReactionView,
		rev: String
	) {
		self.convoId = convoId
		self.message = message
		self.reaction = reaction
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		message = try container.decode(ChatBskyConvoDefsConvoViewLastMessage.self, forKey: .message)
		reaction = try container.decode(ChatBskyConvoDefsReactionView.self, forKey: .reaction)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(message, forKey: .message)
		try container.encode(reaction, forKey: .reaction)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case message = "message"
		case reaction = "reaction"
		case rev = "rev"
	}
}


public struct ChatBskyConvoDefsLogUnmuteConvo: Codable, Sendable, Equatable {
	public let convoId: String
	public let rev: String

	public init(
		convoId: String,
		rev: String
	) {
		self.convoId = convoId
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case rev = "rev"
	}
}


public struct ChatBskyConvoDefsMessageAndReactionView: Codable, Sendable, Equatable {
	public let message: ChatBskyConvoDefsMessageView
	public let reaction: ChatBskyConvoDefsReactionView

	public init(
		message: ChatBskyConvoDefsMessageView,
		reaction: ChatBskyConvoDefsReactionView
	) {
		self.message = message
		self.reaction = reaction
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		message = try container.decode(ChatBskyConvoDefsMessageView.self, forKey: .message)
		reaction = try container.decode(ChatBskyConvoDefsReactionView.self, forKey: .reaction)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(message, forKey: .message)
		try container.encode(reaction, forKey: .reaction)
	}

	private enum CodingKeys: String, CodingKey {
		case message = "message"
		case reaction = "reaction"
	}
}


public struct ChatBskyConvoDefsMessageInput: Codable, Sendable, Equatable {
	public let embed: ChatBskyConvoDefsMessageInputEmbed?
	public let facets: [AppBskyRichtextFacet]?
	public let text: String

	public init(
		embed: ChatBskyConvoDefsMessageInputEmbed? = nil,
		facets: [AppBskyRichtextFacet]? = nil,
		text: String
	) {
		self.embed = embed
		self.facets = facets
		self.text = text
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		embed = try container.decodeIfPresent(ChatBskyConvoDefsMessageInputEmbed.self, forKey: .embed)
		facets = try container.decodeIfPresent([AppBskyRichtextFacet].self, forKey: .facets)
		text = try container.decode(String.self, forKey: .text)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(embed, forKey: .embed)
		try container.encodeIfPresent(facets, forKey: .facets)
		try container.encode(text, forKey: .text)
	}

	private enum CodingKeys: String, CodingKey {
		case embed = "embed"
		case facets = "facets"
		case text = "text"
	}
}


public indirect enum ChatBskyConvoDefsMessageInputEmbed: Codable, Sendable, Equatable {
	case record(AppBskyEmbedRecord)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "app.bsky.embed.record": self = .record(try AppBskyEmbedRecord(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .record(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.embed.record", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct ChatBskyConvoDefsMessageRef: Codable, Sendable, Equatable {
	public let convoId: String
	public let did: DID
	public let messageId: String

	public init(
		convoId: String,
		did: DID,
		messageId: String
	) {
		self.convoId = convoId
		self.did = did
		self.messageId = messageId
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		did = try container.decode(DID.self, forKey: .did)
		messageId = try container.decode(String.self, forKey: .messageId)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(did, forKey: .did)
		try container.encode(messageId, forKey: .messageId)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case did = "did"
		case messageId = "messageId"
	}
}


public struct ChatBskyConvoDefsMessageView: Codable, Sendable, Equatable {
	public let embed: ChatBskyConvoDefsMessageViewEmbed?
	public let facets: [AppBskyRichtextFacet]?
	public let id: String
	public let reactions: [ChatBskyConvoDefsReactionView]?
	public let rev: String
	public let sender: ChatBskyConvoDefsMessageViewSender
	public let sentAt: ATProtocolDate
	public let text: String

	public init(
		embed: ChatBskyConvoDefsMessageViewEmbed? = nil,
		facets: [AppBskyRichtextFacet]? = nil,
		id: String,
		reactions: [ChatBskyConvoDefsReactionView]? = nil,
		rev: String,
		sender: ChatBskyConvoDefsMessageViewSender,
		sentAt: ATProtocolDate,
		text: String
	) {
		self.embed = embed
		self.facets = facets
		self.id = id
		self.reactions = reactions
		self.rev = rev
		self.sender = sender
		self.sentAt = sentAt
		self.text = text
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		embed = try container.decodeIfPresent(ChatBskyConvoDefsMessageViewEmbed.self, forKey: .embed)
		facets = try container.decodeIfPresent([AppBskyRichtextFacet].self, forKey: .facets)
		id = try container.decode(String.self, forKey: .id)
		reactions = try container.decodeIfPresent([ChatBskyConvoDefsReactionView].self, forKey: .reactions)
		rev = try container.decode(String.self, forKey: .rev)
		sender = try container.decode(ChatBskyConvoDefsMessageViewSender.self, forKey: .sender)
		sentAt = try container.decode(ATProtocolDate.self, forKey: .sentAt)
		text = try container.decode(String.self, forKey: .text)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(embed, forKey: .embed)
		try container.encodeIfPresent(facets, forKey: .facets)
		try container.encode(id, forKey: .id)
		try container.encodeIfPresent(reactions, forKey: .reactions)
		try container.encode(rev, forKey: .rev)
		try container.encode(sender, forKey: .sender)
		try container.encode(sentAt, forKey: .sentAt)
		try container.encode(text, forKey: .text)
	}

	private enum CodingKeys: String, CodingKey {
		case embed = "embed"
		case facets = "facets"
		case id = "id"
		case reactions = "reactions"
		case rev = "rev"
		case sender = "sender"
		case sentAt = "sentAt"
		case text = "text"
	}
}


public indirect enum ChatBskyConvoDefsMessageViewEmbed: Codable, Sendable, Equatable {
	case view(AppBskyEmbedRecordView)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "app.bsky.embed.record#view": self = .view(try AppBskyEmbedRecordView(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .view(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.embed.record#view", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct ChatBskyConvoDefsMessageViewSender: Codable, Sendable, Equatable {
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


public struct ChatBskyConvoDefsReactionView: Codable, Sendable, Equatable {
	public let createdAt: ATProtocolDate
	public let sender: ChatBskyConvoDefsReactionViewSender
	public let value: String

	public init(
		createdAt: ATProtocolDate,
		sender: ChatBskyConvoDefsReactionViewSender,
		value: String
	) {
		self.createdAt = createdAt
		self.sender = sender
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		sender = try container.decode(ChatBskyConvoDefsReactionViewSender.self, forKey: .sender)
		value = try container.decode(String.self, forKey: .value)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encode(sender, forKey: .sender)
		try container.encode(value, forKey: .value)
	}

	private enum CodingKeys: String, CodingKey {
		case createdAt = "createdAt"
		case sender = "sender"
		case value = "value"
	}
}


public struct ChatBskyConvoDefsReactionViewSender: Codable, Sendable, Equatable {
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


public struct ChatBskyConvoDeleteMessageForSelfInput: Codable, Sendable, Equatable {
	public let convoId: String
	public let messageId: String

	public init(
		convoId: String,
		messageId: String
	) {
		self.convoId = convoId
		self.messageId = messageId
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		messageId = try container.decode(String.self, forKey: .messageId)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(messageId, forKey: .messageId)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case messageId = "messageId"
	}
}


public typealias ChatBskyConvoDeleteMessageForSelfOutput = ChatBskyConvoDefsDeletedMessageView


public struct ChatBskyConvoGetConvoAvailabilityOutput: Codable, Sendable, Equatable {
	public let canChat: Bool
	public let convo: ChatBskyConvoDefsConvoView?

	public init(
		canChat: Bool,
		convo: ChatBskyConvoDefsConvoView? = nil
	) {
		self.canChat = canChat
		self.convo = convo
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		canChat = try container.decode(Bool.self, forKey: .canChat)
		convo = try container.decodeIfPresent(ChatBskyConvoDefsConvoView.self, forKey: .convo)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(canChat, forKey: .canChat)
		try container.encodeIfPresent(convo, forKey: .convo)
	}

	private enum CodingKeys: String, CodingKey {
		case canChat = "canChat"
		case convo = "convo"
	}
}


public struct ChatBskyConvoGetConvoAvailabilityParameters: Codable, Sendable, Equatable {
	public let members: [DID]

	public init(
		members: [DID]
	) {
		self.members = members
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		members = try container.decode([DID].self, forKey: .members)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(members, forKey: .members)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		members.appendQueryItems(named: "members", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case members = "members"
	}
}


public struct ChatBskyConvoGetConvoForMembersOutput: Codable, Sendable, Equatable {
	public let convo: ChatBskyConvoDefsConvoView

	public init(
		convo: ChatBskyConvoDefsConvoView
	) {
		self.convo = convo
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convo = try container.decode(ChatBskyConvoDefsConvoView.self, forKey: .convo)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convo, forKey: .convo)
	}

	private enum CodingKeys: String, CodingKey {
		case convo = "convo"
	}
}


public struct ChatBskyConvoGetConvoForMembersParameters: Codable, Sendable, Equatable {
	public let members: [DID]

	public init(
		members: [DID]
	) {
		self.members = members
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		members = try container.decode([DID].self, forKey: .members)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(members, forKey: .members)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		members.appendQueryItems(named: "members", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case members = "members"
	}
}


public struct ChatBskyConvoGetConvoOutput: Codable, Sendable, Equatable {
	public let convo: ChatBskyConvoDefsConvoView

	public init(
		convo: ChatBskyConvoDefsConvoView
	) {
		self.convo = convo
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convo = try container.decode(ChatBskyConvoDefsConvoView.self, forKey: .convo)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convo, forKey: .convo)
	}

	private enum CodingKeys: String, CodingKey {
		case convo = "convo"
	}
}


public struct ChatBskyConvoGetConvoParameters: Codable, Sendable, Equatable {
	public let convoId: String

	public init(
		convoId: String
	) {
		self.convoId = convoId
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		convoId.appendQueryItems(named: "convoId", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
	}
}


public struct ChatBskyConvoGetLogOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let logs: [ChatBskyConvoGetLogOutputLogsItem]

	public init(
		cursor: String? = nil,
		logs: [ChatBskyConvoGetLogOutputLogsItem]
	) {
		self.cursor = cursor
		self.logs = logs
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		logs = try container.decode([ChatBskyConvoGetLogOutputLogsItem].self, forKey: .logs)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(logs, forKey: .logs)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case logs = "logs"
	}
}


public indirect enum ChatBskyConvoGetLogOutputLogsItem: Codable, Sendable, Equatable {
	case logBeginConvo(ChatBskyConvoDefsLogBeginConvo)
	case logAcceptConvo(ChatBskyConvoDefsLogAcceptConvo)
	case logLeaveConvo(ChatBskyConvoDefsLogLeaveConvo)
	case logMuteConvo(ChatBskyConvoDefsLogMuteConvo)
	case logUnmuteConvo(ChatBskyConvoDefsLogUnmuteConvo)
	case logCreateMessage(ChatBskyConvoDefsLogCreateMessage)
	case logDeleteMessage(ChatBskyConvoDefsLogDeleteMessage)
	case logReadMessage(ChatBskyConvoDefsLogReadMessage)
	case logAddReaction(ChatBskyConvoDefsLogAddReaction)
	case logRemoveReaction(ChatBskyConvoDefsLogRemoveReaction)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "chat.bsky.convo.defs#logBeginConvo": self = .logBeginConvo(try ChatBskyConvoDefsLogBeginConvo(from: decoder))
		case "chat.bsky.convo.defs#logAcceptConvo": self = .logAcceptConvo(try ChatBskyConvoDefsLogAcceptConvo(from: decoder))
		case "chat.bsky.convo.defs#logLeaveConvo": self = .logLeaveConvo(try ChatBskyConvoDefsLogLeaveConvo(from: decoder))
		case "chat.bsky.convo.defs#logMuteConvo": self = .logMuteConvo(try ChatBskyConvoDefsLogMuteConvo(from: decoder))
		case "chat.bsky.convo.defs#logUnmuteConvo": self = .logUnmuteConvo(try ChatBskyConvoDefsLogUnmuteConvo(from: decoder))
		case "chat.bsky.convo.defs#logCreateMessage": self = .logCreateMessage(try ChatBskyConvoDefsLogCreateMessage(from: decoder))
		case "chat.bsky.convo.defs#logDeleteMessage": self = .logDeleteMessage(try ChatBskyConvoDefsLogDeleteMessage(from: decoder))
		case "chat.bsky.convo.defs#logReadMessage": self = .logReadMessage(try ChatBskyConvoDefsLogReadMessage(from: decoder))
		case "chat.bsky.convo.defs#logAddReaction": self = .logAddReaction(try ChatBskyConvoDefsLogAddReaction(from: decoder))
		case "chat.bsky.convo.defs#logRemoveReaction": self = .logRemoveReaction(try ChatBskyConvoDefsLogRemoveReaction(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .logBeginConvo(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#logBeginConvo", to: encoder)
		case .logAcceptConvo(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#logAcceptConvo", to: encoder)
		case .logLeaveConvo(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#logLeaveConvo", to: encoder)
		case .logMuteConvo(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#logMuteConvo", to: encoder)
		case .logUnmuteConvo(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#logUnmuteConvo", to: encoder)
		case .logCreateMessage(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#logCreateMessage", to: encoder)
		case .logDeleteMessage(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#logDeleteMessage", to: encoder)
		case .logReadMessage(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#logReadMessage", to: encoder)
		case .logAddReaction(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#logAddReaction", to: encoder)
		case .logRemoveReaction(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "chat.bsky.convo.defs#logRemoveReaction", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct ChatBskyConvoGetLogParameters: Codable, Sendable, Equatable {
	public let cursor: String?

	public init(
		cursor: String? = nil
	) {
		self.cursor = cursor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
	}
}


public struct ChatBskyConvoGetMessagesOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let messages: [ChatBskyConvoDefsConvoViewLastMessage]

	public init(
		cursor: String? = nil,
		messages: [ChatBskyConvoDefsConvoViewLastMessage]
	) {
		self.cursor = cursor
		self.messages = messages
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		messages = try container.decode([ChatBskyConvoDefsConvoViewLastMessage].self, forKey: .messages)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(messages, forKey: .messages)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case messages = "messages"
	}
}


public struct ChatBskyConvoGetMessagesParameters: Codable, Sendable, Equatable {
	public let convoId: String
	public let cursor: String?
	public let limit: Int?

	public init(
		convoId: String,
		cursor: String? = nil,
		limit: Int? = nil
	) {
		self.convoId = convoId
		self.cursor = cursor
		self.limit = limit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		convoId.appendQueryItems(named: "convoId", to: &items)
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case cursor = "cursor"
		case limit = "limit"
	}
}


public struct ChatBskyConvoLeaveConvoInput: Codable, Sendable, Equatable {
	public let convoId: String

	public init(
		convoId: String
	) {
		self.convoId = convoId
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
	}
}


public struct ChatBskyConvoLeaveConvoOutput: Codable, Sendable, Equatable {
	public let convoId: String
	public let rev: String

	public init(
		convoId: String,
		rev: String
	) {
		self.convoId = convoId
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		rev = try container.decode(String.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case rev = "rev"
	}
}


public struct ChatBskyConvoListConvosOutput: Codable, Sendable, Equatable {
	public let convos: [ChatBskyConvoDefsConvoView]
	public let cursor: String?

	public init(
		convos: [ChatBskyConvoDefsConvoView],
		cursor: String? = nil
	) {
		self.convos = convos
		self.cursor = cursor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convos = try container.decode([ChatBskyConvoDefsConvoView].self, forKey: .convos)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convos, forKey: .convos)
		try container.encodeIfPresent(cursor, forKey: .cursor)
	}

	private enum CodingKeys: String, CodingKey {
		case convos = "convos"
		case cursor = "cursor"
	}
}


public struct ChatBskyConvoListConvosParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?
	public let readState: ChatBskyConvoListConvosParametersReadState?
	public let status: ChatBskyConvoDefsConvoViewStatus?

	public init(
		cursor: String? = nil,
		limit: Int? = nil,
		readState: ChatBskyConvoListConvosParametersReadState? = nil,
		status: ChatBskyConvoDefsConvoViewStatus? = nil
	) {
		self.cursor = cursor
		self.limit = limit
		self.readState = readState
		self.status = status
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		readState = try container.decodeIfPresent(ChatBskyConvoListConvosParametersReadState.self, forKey: .readState)
		status = try container.decodeIfPresent(ChatBskyConvoDefsConvoViewStatus.self, forKey: .status)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encodeIfPresent(readState, forKey: .readState)
		try container.encodeIfPresent(status, forKey: .status)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		if let value = readState {
			value.appendQueryItems(named: "readState", to: &items)
		}
		if let value = status {
			value.appendQueryItems(named: "status", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
		case readState = "readState"
		case status = "status"
	}
}


public enum ChatBskyConvoListConvosParametersReadState: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case unread = "unread"
}


public struct ChatBskyConvoMuteConvoInput: Codable, Sendable, Equatable {
	public let convoId: String

	public init(
		convoId: String
	) {
		self.convoId = convoId
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
	}
}


public struct ChatBskyConvoMuteConvoOutput: Codable, Sendable, Equatable {
	public let convo: ChatBskyConvoDefsConvoView

	public init(
		convo: ChatBskyConvoDefsConvoView
	) {
		self.convo = convo
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convo = try container.decode(ChatBskyConvoDefsConvoView.self, forKey: .convo)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convo, forKey: .convo)
	}

	private enum CodingKeys: String, CodingKey {
		case convo = "convo"
	}
}


public enum ChatBskyConvoRemoveReactionError: String, Swift.Error, CaseIterable, Sendable {
	case reactionInvalidValue = "ReactionInvalidValue"
	case reactionMessageDeleted = "ReactionMessageDeleted"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ChatBskyConvoRemoveReactionInput: Codable, Sendable, Equatable {
	public let convoId: String
	public let messageId: String
	public let value: String

	public init(
		convoId: String,
		messageId: String,
		value: String
	) {
		self.convoId = convoId
		self.messageId = messageId
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		messageId = try container.decode(String.self, forKey: .messageId)
		value = try container.decode(String.self, forKey: .value)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(messageId, forKey: .messageId)
		try container.encode(value, forKey: .value)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case messageId = "messageId"
		case value = "value"
	}
}


public struct ChatBskyConvoRemoveReactionOutput: Codable, Sendable, Equatable {
	public let message: ChatBskyConvoDefsMessageView

	public init(
		message: ChatBskyConvoDefsMessageView
	) {
		self.message = message
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		message = try container.decode(ChatBskyConvoDefsMessageView.self, forKey: .message)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(message, forKey: .message)
	}

	private enum CodingKeys: String, CodingKey {
		case message = "message"
	}
}


public struct ChatBskyConvoSendMessageBatchBatchItem: Codable, Sendable, Equatable {
	public let convoId: String
	public let message: ChatBskyConvoDefsMessageInput

	public init(
		convoId: String,
		message: ChatBskyConvoDefsMessageInput
	) {
		self.convoId = convoId
		self.message = message
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		message = try container.decode(ChatBskyConvoDefsMessageInput.self, forKey: .message)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(message, forKey: .message)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case message = "message"
	}
}


public struct ChatBskyConvoSendMessageBatchInput: Codable, Sendable, Equatable {
	public let items: [ChatBskyConvoSendMessageBatchBatchItem]

	public init(
		items: [ChatBskyConvoSendMessageBatchBatchItem]
	) {
		self.items = items
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		items = try container.decode([ChatBskyConvoSendMessageBatchBatchItem].self, forKey: .items)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(items, forKey: .items)
	}

	private enum CodingKeys: String, CodingKey {
		case items = "items"
	}
}


public struct ChatBskyConvoSendMessageBatchOutput: Codable, Sendable, Equatable {
	public let items: [ChatBskyConvoDefsMessageView]

	public init(
		items: [ChatBskyConvoDefsMessageView]
	) {
		self.items = items
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		items = try container.decode([ChatBskyConvoDefsMessageView].self, forKey: .items)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(items, forKey: .items)
	}

	private enum CodingKeys: String, CodingKey {
		case items = "items"
	}
}


public struct ChatBskyConvoSendMessageInput: Codable, Sendable, Equatable {
	public let convoId: String
	public let message: ChatBskyConvoDefsMessageInput

	public init(
		convoId: String,
		message: ChatBskyConvoDefsMessageInput
	) {
		self.convoId = convoId
		self.message = message
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		message = try container.decode(ChatBskyConvoDefsMessageInput.self, forKey: .message)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encode(message, forKey: .message)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case message = "message"
	}
}


public typealias ChatBskyConvoSendMessageOutput = ChatBskyConvoDefsMessageView


public struct ChatBskyConvoUnmuteConvoInput: Codable, Sendable, Equatable {
	public let convoId: String

	public init(
		convoId: String
	) {
		self.convoId = convoId
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
	}
}


public struct ChatBskyConvoUnmuteConvoOutput: Codable, Sendable, Equatable {
	public let convo: ChatBskyConvoDefsConvoView

	public init(
		convo: ChatBskyConvoDefsConvoView
	) {
		self.convo = convo
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convo = try container.decode(ChatBskyConvoDefsConvoView.self, forKey: .convo)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convo, forKey: .convo)
	}

	private enum CodingKeys: String, CodingKey {
		case convo = "convo"
	}
}


public struct ChatBskyConvoUpdateAllReadInput: Codable, Sendable, Equatable {
	public let status: ChatBskyConvoDefsConvoViewStatus?

	public init(
		status: ChatBskyConvoDefsConvoViewStatus? = nil
	) {
		self.status = status
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		status = try container.decodeIfPresent(ChatBskyConvoDefsConvoViewStatus.self, forKey: .status)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(status, forKey: .status)
	}

	private enum CodingKeys: String, CodingKey {
		case status = "status"
	}
}


public struct ChatBskyConvoUpdateAllReadOutput: Codable, Sendable, Equatable {
	public let updatedCount: Int

	public init(
		updatedCount: Int
	) {
		self.updatedCount = updatedCount
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		updatedCount = try container.decode(Int.self, forKey: .updatedCount)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(updatedCount, forKey: .updatedCount)
	}

	private enum CodingKeys: String, CodingKey {
		case updatedCount = "updatedCount"
	}
}


public struct ChatBskyConvoUpdateReadInput: Codable, Sendable, Equatable {
	public let convoId: String
	public let messageId: String?

	public init(
		convoId: String,
		messageId: String? = nil
	) {
		self.convoId = convoId
		self.messageId = messageId
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convoId = try container.decode(String.self, forKey: .convoId)
		messageId = try container.decodeIfPresent(String.self, forKey: .messageId)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convoId, forKey: .convoId)
		try container.encodeIfPresent(messageId, forKey: .messageId)
	}

	private enum CodingKeys: String, CodingKey {
		case convoId = "convoId"
		case messageId = "messageId"
	}
}


public struct ChatBskyConvoUpdateReadOutput: Codable, Sendable, Equatable {
	public let convo: ChatBskyConvoDefsConvoView

	public init(
		convo: ChatBskyConvoDefsConvoView
	) {
		self.convo = convo
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		convo = try container.decode(ChatBskyConvoDefsConvoView.self, forKey: .convo)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(convo, forKey: .convo)
	}

	private enum CodingKeys: String, CodingKey {
		case convo = "convo"
	}
}


