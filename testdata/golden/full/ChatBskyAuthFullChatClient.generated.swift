import Foundation


public struct ChatBskyAuthFullChatClient: Codable, Sendable, Equatable {
	public static let title: String? = "Full Chat Client (All Conversations)"
	public static let detail: String? = "Control of all chat conversations and configuration management."
	public static let knownMethods: [ChatBskyAuthFullChatClientMethod] = [.chatBskyActorDeleteAccount, .chatBskyActorExportAccountData, .chatBskyConvoAcceptConvo, .chatBskyConvoAddReaction, .chatBskyConvoDeleteMessageForSelf, .chatBskyConvoGetConvo, .chatBskyConvoGetConvoAvailability, .chatBskyConvoGetConvoForMembers, .chatBskyConvoGetLog, .chatBskyConvoGetMessages, .chatBskyConvoLeaveConvo, .chatBskyConvoListConvos, .chatBskyConvoMuteConvo, .chatBskyConvoRemoveReaction, .chatBskyConvoSendMessage, .chatBskyConvoSendMessageBatch, .chatBskyConvoUnmuteConvo, .chatBskyConvoUpdateAllRead, .chatBskyConvoUpdateRead]

	public let grantedMethods: [ChatBskyAuthFullChatClientMethod]

	public init(grantedMethods: [ChatBskyAuthFullChatClientMethod] = []) {
		self.grantedMethods = grantedMethods
	}

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		var grantedMethods: [ChatBskyAuthFullChatClientMethod] = []
		while !container.isAtEnd {
			grantedMethods.append(ChatBskyAuthFullChatClientMethod(rawValue: try container.decode(String.self)))
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


public struct ChatBskyAuthFullChatClientMethod: RawRepresentable, Codable, Hashable, Sendable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public static let chatBskyActorDeleteAccount = Self(rawValue: "chat.bsky.actor.deleteAccount")
	public static let chatBskyActorExportAccountData = Self(rawValue: "chat.bsky.actor.exportAccountData")
	public static let chatBskyConvoAcceptConvo = Self(rawValue: "chat.bsky.convo.acceptConvo")
	public static let chatBskyConvoAddReaction = Self(rawValue: "chat.bsky.convo.addReaction")
	public static let chatBskyConvoDeleteMessageForSelf = Self(rawValue: "chat.bsky.convo.deleteMessageForSelf")
	public static let chatBskyConvoGetConvo = Self(rawValue: "chat.bsky.convo.getConvo")
	public static let chatBskyConvoGetConvoAvailability = Self(rawValue: "chat.bsky.convo.getConvoAvailability")
	public static let chatBskyConvoGetConvoForMembers = Self(rawValue: "chat.bsky.convo.getConvoForMembers")
	public static let chatBskyConvoGetLog = Self(rawValue: "chat.bsky.convo.getLog")
	public static let chatBskyConvoGetMessages = Self(rawValue: "chat.bsky.convo.getMessages")
	public static let chatBskyConvoLeaveConvo = Self(rawValue: "chat.bsky.convo.leaveConvo")
	public static let chatBskyConvoListConvos = Self(rawValue: "chat.bsky.convo.listConvos")
	public static let chatBskyConvoMuteConvo = Self(rawValue: "chat.bsky.convo.muteConvo")
	public static let chatBskyConvoRemoveReaction = Self(rawValue: "chat.bsky.convo.removeReaction")
	public static let chatBskyConvoSendMessage = Self(rawValue: "chat.bsky.convo.sendMessage")
	public static let chatBskyConvoSendMessageBatch = Self(rawValue: "chat.bsky.convo.sendMessageBatch")
	public static let chatBskyConvoUnmuteConvo = Self(rawValue: "chat.bsky.convo.unmuteConvo")
	public static let chatBskyConvoUpdateAllRead = Self(rawValue: "chat.bsky.convo.updateAllRead")
	public static let chatBskyConvoUpdateRead = Self(rawValue: "chat.bsky.convo.updateRead")
}


