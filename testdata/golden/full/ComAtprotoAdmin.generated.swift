import Foundation


public struct ComAtprotoAdminDefsAccountView: Codable, Sendable, Equatable {
	public let deactivatedAt: ATProtocolDate?
	public let did: DID
	public let email: String?
	public let emailConfirmedAt: ATProtocolDate?
	public let handle: Handle
	public let indexedAt: ATProtocolDate
	public let inviteNote: String?
	public let invitedBy: ComAtprotoServerDefsInviteCode?
	public let invites: [ComAtprotoServerDefsInviteCode]?
	public let invitesDisabled: Bool?
	public let relatedRecords: [ATProtocolValueContainer]?
	public let threatSignatures: [ComAtprotoAdminDefsThreatSignature]?

	public init(
		deactivatedAt: ATProtocolDate? = nil,
		did: DID,
		email: String? = nil,
		emailConfirmedAt: ATProtocolDate? = nil,
		handle: Handle,
		indexedAt: ATProtocolDate,
		inviteNote: String? = nil,
		invitedBy: ComAtprotoServerDefsInviteCode? = nil,
		invites: [ComAtprotoServerDefsInviteCode]? = nil,
		invitesDisabled: Bool? = nil,
		relatedRecords: [ATProtocolValueContainer]? = nil,
		threatSignatures: [ComAtprotoAdminDefsThreatSignature]? = nil
	) {
		self.deactivatedAt = deactivatedAt
		self.did = did
		self.email = email
		self.emailConfirmedAt = emailConfirmedAt
		self.handle = handle
		self.indexedAt = indexedAt
		self.inviteNote = inviteNote
		self.invitedBy = invitedBy
		self.invites = invites
		self.invitesDisabled = invitesDisabled
		self.relatedRecords = relatedRecords
		self.threatSignatures = threatSignatures
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		deactivatedAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .deactivatedAt)
		did = try container.decode(DID.self, forKey: .did)
		email = try container.decodeIfPresent(String.self, forKey: .email)
		emailConfirmedAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .emailConfirmedAt)
		handle = try container.decode(Handle.self, forKey: .handle)
		indexedAt = try container.decode(ATProtocolDate.self, forKey: .indexedAt)
		inviteNote = try container.decodeIfPresent(String.self, forKey: .inviteNote)
		invitedBy = try container.decodeIfPresent(ComAtprotoServerDefsInviteCode.self, forKey: .invitedBy)
		invites = try container.decodeIfPresent([ComAtprotoServerDefsInviteCode].self, forKey: .invites)
		invitesDisabled = try container.decodeIfPresent(Bool.self, forKey: .invitesDisabled)
		relatedRecords = try container.decodeIfPresent([ATProtocolValueContainer].self, forKey: .relatedRecords)
		threatSignatures = try container.decodeIfPresent([ComAtprotoAdminDefsThreatSignature].self, forKey: .threatSignatures)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(deactivatedAt, forKey: .deactivatedAt)
		try container.encode(did, forKey: .did)
		try container.encodeIfPresent(email, forKey: .email)
		try container.encodeIfPresent(emailConfirmedAt, forKey: .emailConfirmedAt)
		try container.encode(handle, forKey: .handle)
		try container.encode(indexedAt, forKey: .indexedAt)
		try container.encodeIfPresent(inviteNote, forKey: .inviteNote)
		try container.encodeIfPresent(invitedBy, forKey: .invitedBy)
		try container.encodeIfPresent(invites, forKey: .invites)
		try container.encodeIfPresent(invitesDisabled, forKey: .invitesDisabled)
		try container.encodeIfPresent(relatedRecords, forKey: .relatedRecords)
		try container.encodeIfPresent(threatSignatures, forKey: .threatSignatures)
	}

	private enum CodingKeys: String, CodingKey {
		case deactivatedAt = "deactivatedAt"
		case did = "did"
		case email = "email"
		case emailConfirmedAt = "emailConfirmedAt"
		case handle = "handle"
		case indexedAt = "indexedAt"
		case inviteNote = "inviteNote"
		case invitedBy = "invitedBy"
		case invites = "invites"
		case invitesDisabled = "invitesDisabled"
		case relatedRecords = "relatedRecords"
		case threatSignatures = "threatSignatures"
	}
}


public struct ComAtprotoAdminDefsRepoBlobRef: Codable, Sendable, Equatable {
	public let cid: CID
	public let did: DID
	public let recordUri: ATURI?

	public init(
		cid: CID,
		did: DID,
		recordUri: ATURI? = nil
	) {
		self.cid = cid
		self.did = did
		self.recordUri = recordUri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		did = try container.decode(DID.self, forKey: .did)
		recordUri = try container.decodeIfPresent(ATURI.self, forKey: .recordUri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encode(did, forKey: .did)
		try container.encodeIfPresent(recordUri, forKey: .recordUri)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case did = "did"
		case recordUri = "recordUri"
	}
}


public struct ComAtprotoAdminDefsRepoRef: Codable, Sendable, Equatable {
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


public struct ComAtprotoAdminDefsStatusAttr: Codable, Sendable, Equatable {
	public let applied: Bool
	public let ref: String?

	public init(
		applied: Bool,
		ref: String? = nil
	) {
		self.applied = applied
		self.ref = ref
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		applied = try container.decode(Bool.self, forKey: .applied)
		ref = try container.decodeIfPresent(String.self, forKey: .ref)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(applied, forKey: .applied)
		try container.encodeIfPresent(ref, forKey: .ref)
	}

	private enum CodingKeys: String, CodingKey {
		case applied = "applied"
		case ref = "ref"
	}
}


public struct ComAtprotoAdminDefsThreatSignature: Codable, Sendable, Equatable {
	public let property: String
	public let value: String

	public init(
		property: String,
		value: String
	) {
		self.property = property
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		property = try container.decode(String.self, forKey: .property)
		value = try container.decode(String.self, forKey: .value)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(property, forKey: .property)
		try container.encode(value, forKey: .value)
	}

	private enum CodingKeys: String, CodingKey {
		case property = "property"
		case value = "value"
	}
}


public struct ComAtprotoAdminDeleteAccountInput: Codable, Sendable, Equatable {
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


public struct ComAtprotoAdminDisableAccountInvitesInput: Codable, Sendable, Equatable {
	public let account: DID
	public let note: String?

	public init(
		account: DID,
		note: String? = nil
	) {
		self.account = account
		self.note = note
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		account = try container.decode(DID.self, forKey: .account)
		note = try container.decodeIfPresent(String.self, forKey: .note)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(account, forKey: .account)
		try container.encodeIfPresent(note, forKey: .note)
	}

	private enum CodingKeys: String, CodingKey {
		case account = "account"
		case note = "note"
	}
}


public struct ComAtprotoAdminDisableInviteCodesInput: Codable, Sendable, Equatable {
	public let accounts: [String]?
	public let codes: [String]?

	public init(
		accounts: [String]? = nil,
		codes: [String]? = nil
	) {
		self.accounts = accounts
		self.codes = codes
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		accounts = try container.decodeIfPresent([String].self, forKey: .accounts)
		codes = try container.decodeIfPresent([String].self, forKey: .codes)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(accounts, forKey: .accounts)
		try container.encodeIfPresent(codes, forKey: .codes)
	}

	private enum CodingKeys: String, CodingKey {
		case accounts = "accounts"
		case codes = "codes"
	}
}


public struct ComAtprotoAdminEnableAccountInvitesInput: Codable, Sendable, Equatable {
	public let account: DID
	public let note: String?

	public init(
		account: DID,
		note: String? = nil
	) {
		self.account = account
		self.note = note
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		account = try container.decode(DID.self, forKey: .account)
		note = try container.decodeIfPresent(String.self, forKey: .note)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(account, forKey: .account)
		try container.encodeIfPresent(note, forKey: .note)
	}

	private enum CodingKeys: String, CodingKey {
		case account = "account"
		case note = "note"
	}
}


public typealias ComAtprotoAdminGetAccountInfoOutput = ComAtprotoAdminDefsAccountView


public struct ComAtprotoAdminGetAccountInfoParameters: Codable, Sendable, Equatable {
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

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		did.appendQueryItems(named: "did", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case did = "did"
	}
}


public struct ComAtprotoAdminGetAccountInfosOutput: Codable, Sendable, Equatable {
	public let infos: [ComAtprotoAdminDefsAccountView]

	public init(
		infos: [ComAtprotoAdminDefsAccountView]
	) {
		self.infos = infos
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		infos = try container.decode([ComAtprotoAdminDefsAccountView].self, forKey: .infos)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(infos, forKey: .infos)
	}

	private enum CodingKeys: String, CodingKey {
		case infos = "infos"
	}
}


public struct ComAtprotoAdminGetAccountInfosParameters: Codable, Sendable, Equatable {
	public let dids: [DID]

	public init(
		dids: [DID]
	) {
		self.dids = dids
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		dids = try container.decode([DID].self, forKey: .dids)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(dids, forKey: .dids)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		dids.appendQueryItems(named: "dids", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case dids = "dids"
	}
}


public struct ComAtprotoAdminGetInviteCodesOutput: Codable, Sendable, Equatable {
	public let codes: [ComAtprotoServerDefsInviteCode]
	public let cursor: String?

	public init(
		codes: [ComAtprotoServerDefsInviteCode],
		cursor: String? = nil
	) {
		self.codes = codes
		self.cursor = cursor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		codes = try container.decode([ComAtprotoServerDefsInviteCode].self, forKey: .codes)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(codes, forKey: .codes)
		try container.encodeIfPresent(cursor, forKey: .cursor)
	}

	private enum CodingKeys: String, CodingKey {
		case codes = "codes"
		case cursor = "cursor"
	}
}


public struct ComAtprotoAdminGetInviteCodesParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?
	public let sort: ComAtprotoAdminGetInviteCodesParametersSort?

	public init(
		cursor: String? = nil,
		limit: Int? = nil,
		sort: ComAtprotoAdminGetInviteCodesParametersSort? = nil
	) {
		self.cursor = cursor
		self.limit = limit
		self.sort = sort
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		sort = try container.decodeIfPresent(ComAtprotoAdminGetInviteCodesParametersSort.self, forKey: .sort)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encodeIfPresent(sort, forKey: .sort)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		if let value = sort {
			value.appendQueryItems(named: "sort", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
		case sort = "sort"
	}
}


public enum ComAtprotoAdminGetInviteCodesParametersSort: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case recent = "recent"
	case usage = "usage"
}


public struct ComAtprotoAdminGetSubjectStatusOutput: Codable, Sendable, Equatable {
	public let deactivated: ComAtprotoAdminDefsStatusAttr?
	public let subject: ComAtprotoAdminGetSubjectStatusOutputSubject
	public let takedown: ComAtprotoAdminDefsStatusAttr?

	public init(
		deactivated: ComAtprotoAdminDefsStatusAttr? = nil,
		subject: ComAtprotoAdminGetSubjectStatusOutputSubject,
		takedown: ComAtprotoAdminDefsStatusAttr? = nil
	) {
		self.deactivated = deactivated
		self.subject = subject
		self.takedown = takedown
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		deactivated = try container.decodeIfPresent(ComAtprotoAdminDefsStatusAttr.self, forKey: .deactivated)
		subject = try container.decode(ComAtprotoAdminGetSubjectStatusOutputSubject.self, forKey: .subject)
		takedown = try container.decodeIfPresent(ComAtprotoAdminDefsStatusAttr.self, forKey: .takedown)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(deactivated, forKey: .deactivated)
		try container.encode(subject, forKey: .subject)
		try container.encodeIfPresent(takedown, forKey: .takedown)
	}

	private enum CodingKeys: String, CodingKey {
		case deactivated = "deactivated"
		case subject = "subject"
		case takedown = "takedown"
	}
}


public indirect enum ComAtprotoAdminGetSubjectStatusOutputSubject: Codable, Sendable, Equatable {
	case repoRef(ComAtprotoAdminDefsRepoRef)
	case strongRef(ComAtprotoRepoStrongRef)
	case repoBlobRef(ComAtprotoAdminDefsRepoBlobRef)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "com.atproto.admin.defs#repoRef": self = .repoRef(try ComAtprotoAdminDefsRepoRef(from: decoder))
		case "com.atproto.repo.strongRef": self = .strongRef(try ComAtprotoRepoStrongRef(from: decoder))
		case "com.atproto.admin.defs#repoBlobRef": self = .repoBlobRef(try ComAtprotoAdminDefsRepoBlobRef(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .repoRef(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "com.atproto.admin.defs#repoRef", to: encoder)
		case .strongRef(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "com.atproto.repo.strongRef", to: encoder)
		case .repoBlobRef(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "com.atproto.admin.defs#repoBlobRef", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct ComAtprotoAdminGetSubjectStatusParameters: Codable, Sendable, Equatable {
	public let blob: CID?
	public let did: DID?
	public let uri: ATURI?

	public init(
		blob: CID? = nil,
		did: DID? = nil,
		uri: ATURI? = nil
	) {
		self.blob = blob
		self.did = did
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		blob = try container.decodeIfPresent(CID.self, forKey: .blob)
		did = try container.decodeIfPresent(DID.self, forKey: .did)
		uri = try container.decodeIfPresent(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(blob, forKey: .blob)
		try container.encodeIfPresent(did, forKey: .did)
		try container.encodeIfPresent(uri, forKey: .uri)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = blob {
			value.appendQueryItems(named: "blob", to: &items)
		}
		if let value = did {
			value.appendQueryItems(named: "did", to: &items)
		}
		if let value = uri {
			value.appendQueryItems(named: "uri", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case blob = "blob"
		case did = "did"
		case uri = "uri"
	}
}


public struct ComAtprotoAdminSearchAccountsOutput: Codable, Sendable, Equatable {
	public let accounts: [ComAtprotoAdminDefsAccountView]
	public let cursor: String?

	public init(
		accounts: [ComAtprotoAdminDefsAccountView],
		cursor: String? = nil
	) {
		self.accounts = accounts
		self.cursor = cursor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		accounts = try container.decode([ComAtprotoAdminDefsAccountView].self, forKey: .accounts)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(accounts, forKey: .accounts)
		try container.encodeIfPresent(cursor, forKey: .cursor)
	}

	private enum CodingKeys: String, CodingKey {
		case accounts = "accounts"
		case cursor = "cursor"
	}
}


public struct ComAtprotoAdminSearchAccountsParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let email: String?
	public let limit: Int?

	public init(
		cursor: String? = nil,
		email: String? = nil,
		limit: Int? = nil
	) {
		self.cursor = cursor
		self.email = email
		self.limit = limit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		email = try container.decodeIfPresent(String.self, forKey: .email)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(email, forKey: .email)
		try container.encodeIfPresent(limit, forKey: .limit)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = email {
			value.appendQueryItems(named: "email", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case email = "email"
		case limit = "limit"
	}
}


public struct ComAtprotoAdminSendEmailInput: Codable, Sendable, Equatable {
	public let comment: String?
	public let content: String
	public let recipientDid: DID
	public let senderDid: DID
	public let subject: String?

	public init(
		comment: String? = nil,
		content: String,
		recipientDid: DID,
		senderDid: DID,
		subject: String? = nil
	) {
		self.comment = comment
		self.content = content
		self.recipientDid = recipientDid
		self.senderDid = senderDid
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		comment = try container.decodeIfPresent(String.self, forKey: .comment)
		content = try container.decode(String.self, forKey: .content)
		recipientDid = try container.decode(DID.self, forKey: .recipientDid)
		senderDid = try container.decode(DID.self, forKey: .senderDid)
		subject = try container.decodeIfPresent(String.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(comment, forKey: .comment)
		try container.encode(content, forKey: .content)
		try container.encode(recipientDid, forKey: .recipientDid)
		try container.encode(senderDid, forKey: .senderDid)
		try container.encodeIfPresent(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case comment = "comment"
		case content = "content"
		case recipientDid = "recipientDid"
		case senderDid = "senderDid"
		case subject = "subject"
	}
}


public struct ComAtprotoAdminSendEmailOutput: Codable, Sendable, Equatable {
	public let sent: Bool

	public init(
		sent: Bool
	) {
		self.sent = sent
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		sent = try container.decode(Bool.self, forKey: .sent)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(sent, forKey: .sent)
	}

	private enum CodingKeys: String, CodingKey {
		case sent = "sent"
	}
}


public struct ComAtprotoAdminUpdateAccountEmailInput: Codable, Sendable, Equatable {
	public let account: ATIdentifier
	public let email: String

	public init(
		account: ATIdentifier,
		email: String
	) {
		self.account = account
		self.email = email
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		account = try container.decode(ATIdentifier.self, forKey: .account)
		email = try container.decode(String.self, forKey: .email)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(account, forKey: .account)
		try container.encode(email, forKey: .email)
	}

	private enum CodingKeys: String, CodingKey {
		case account = "account"
		case email = "email"
	}
}


public struct ComAtprotoAdminUpdateAccountHandleInput: Codable, Sendable, Equatable {
	public let did: DID
	public let handle: Handle

	public init(
		did: DID,
		handle: Handle
	) {
		self.did = did
		self.handle = handle
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		did = try container.decode(DID.self, forKey: .did)
		handle = try container.decode(Handle.self, forKey: .handle)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(did, forKey: .did)
		try container.encode(handle, forKey: .handle)
	}

	private enum CodingKeys: String, CodingKey {
		case did = "did"
		case handle = "handle"
	}
}


public struct ComAtprotoAdminUpdateAccountPasswordInput: Codable, Sendable, Equatable {
	public let did: DID
	public let password: String

	public init(
		did: DID,
		password: String
	) {
		self.did = did
		self.password = password
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		did = try container.decode(DID.self, forKey: .did)
		password = try container.decode(String.self, forKey: .password)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(did, forKey: .did)
		try container.encode(password, forKey: .password)
	}

	private enum CodingKeys: String, CodingKey {
		case did = "did"
		case password = "password"
	}
}


public struct ComAtprotoAdminUpdateAccountSigningKeyInput: Codable, Sendable, Equatable {
	public let did: DID
	public let signingKey: DID

	public init(
		did: DID,
		signingKey: DID
	) {
		self.did = did
		self.signingKey = signingKey
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		did = try container.decode(DID.self, forKey: .did)
		signingKey = try container.decode(DID.self, forKey: .signingKey)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(did, forKey: .did)
		try container.encode(signingKey, forKey: .signingKey)
	}

	private enum CodingKeys: String, CodingKey {
		case did = "did"
		case signingKey = "signingKey"
	}
}


public struct ComAtprotoAdminUpdateSubjectStatusInput: Codable, Sendable, Equatable {
	public let deactivated: ComAtprotoAdminDefsStatusAttr?
	public let subject: ComAtprotoAdminGetSubjectStatusOutputSubject
	public let takedown: ComAtprotoAdminDefsStatusAttr?

	public init(
		deactivated: ComAtprotoAdminDefsStatusAttr? = nil,
		subject: ComAtprotoAdminGetSubjectStatusOutputSubject,
		takedown: ComAtprotoAdminDefsStatusAttr? = nil
	) {
		self.deactivated = deactivated
		self.subject = subject
		self.takedown = takedown
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		deactivated = try container.decodeIfPresent(ComAtprotoAdminDefsStatusAttr.self, forKey: .deactivated)
		subject = try container.decode(ComAtprotoAdminGetSubjectStatusOutputSubject.self, forKey: .subject)
		takedown = try container.decodeIfPresent(ComAtprotoAdminDefsStatusAttr.self, forKey: .takedown)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(deactivated, forKey: .deactivated)
		try container.encode(subject, forKey: .subject)
		try container.encodeIfPresent(takedown, forKey: .takedown)
	}

	private enum CodingKeys: String, CodingKey {
		case deactivated = "deactivated"
		case subject = "subject"
		case takedown = "takedown"
	}
}


public struct ComAtprotoAdminUpdateSubjectStatusOutput: Codable, Sendable, Equatable {
	public let subject: ComAtprotoAdminGetSubjectStatusOutputSubject
	public let takedown: ComAtprotoAdminDefsStatusAttr?

	public init(
		subject: ComAtprotoAdminGetSubjectStatusOutputSubject,
		takedown: ComAtprotoAdminDefsStatusAttr? = nil
	) {
		self.subject = subject
		self.takedown = takedown
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		subject = try container.decode(ComAtprotoAdminGetSubjectStatusOutputSubject.self, forKey: .subject)
		takedown = try container.decodeIfPresent(ComAtprotoAdminDefsStatusAttr.self, forKey: .takedown)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(subject, forKey: .subject)
		try container.encodeIfPresent(takedown, forKey: .takedown)
	}

	private enum CodingKeys: String, CodingKey {
		case subject = "subject"
		case takedown = "takedown"
	}
}


