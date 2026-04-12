import Foundation


public struct ToolsOzoneVerificationDefsVerificationView: Codable, Sendable, Equatable {
	public let createdAt: ATProtocolDate
	public let displayName: String
	public let handle: Handle
	public let issuer: DID
	public let issuerProfile: ToolsOzoneVerificationDefsVerificationViewIssuerProfile?
	public let issuerRepo: ToolsOzoneVerificationDefsVerificationViewIssuerRepo?
	public let revokeReason: String?
	public let revokedAt: ATProtocolDate?
	public let revokedBy: DID?
	public let subject: DID
	public let subjectProfile: ToolsOzoneVerificationDefsVerificationViewSubjectProfile?
	public let subjectRepo: ToolsOzoneVerificationDefsVerificationViewIssuerRepo?
	public let uri: ATURI

	public init(
		createdAt: ATProtocolDate,
		displayName: String,
		handle: Handle,
		issuer: DID,
		issuerProfile: ToolsOzoneVerificationDefsVerificationViewIssuerProfile? = nil,
		issuerRepo: ToolsOzoneVerificationDefsVerificationViewIssuerRepo? = nil,
		revokeReason: String? = nil,
		revokedAt: ATProtocolDate? = nil,
		revokedBy: DID? = nil,
		subject: DID,
		subjectProfile: ToolsOzoneVerificationDefsVerificationViewSubjectProfile? = nil,
		subjectRepo: ToolsOzoneVerificationDefsVerificationViewIssuerRepo? = nil,
		uri: ATURI
	) {
		self.createdAt = createdAt
		self.displayName = displayName
		self.handle = handle
		self.issuer = issuer
		self.issuerProfile = issuerProfile
		self.issuerRepo = issuerRepo
		self.revokeReason = revokeReason
		self.revokedAt = revokedAt
		self.revokedBy = revokedBy
		self.subject = subject
		self.subjectProfile = subjectProfile
		self.subjectRepo = subjectRepo
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		displayName = try container.decode(String.self, forKey: .displayName)
		handle = try container.decode(Handle.self, forKey: .handle)
		issuer = try container.decode(DID.self, forKey: .issuer)
		issuerProfile = try container.decodeIfPresent(ToolsOzoneVerificationDefsVerificationViewIssuerProfile.self, forKey: .issuerProfile)
		issuerRepo = try container.decodeIfPresent(ToolsOzoneVerificationDefsVerificationViewIssuerRepo.self, forKey: .issuerRepo)
		revokeReason = try container.decodeIfPresent(String.self, forKey: .revokeReason)
		revokedAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .revokedAt)
		revokedBy = try container.decodeIfPresent(DID.self, forKey: .revokedBy)
		subject = try container.decode(DID.self, forKey: .subject)
		subjectProfile = try container.decodeIfPresent(ToolsOzoneVerificationDefsVerificationViewSubjectProfile.self, forKey: .subjectProfile)
		subjectRepo = try container.decodeIfPresent(ToolsOzoneVerificationDefsVerificationViewIssuerRepo.self, forKey: .subjectRepo)
		uri = try container.decode(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encode(displayName, forKey: .displayName)
		try container.encode(handle, forKey: .handle)
		try container.encode(issuer, forKey: .issuer)
		try container.encodeIfPresent(issuerProfile, forKey: .issuerProfile)
		try container.encodeIfPresent(issuerRepo, forKey: .issuerRepo)
		try container.encodeIfPresent(revokeReason, forKey: .revokeReason)
		try container.encodeIfPresent(revokedAt, forKey: .revokedAt)
		try container.encodeIfPresent(revokedBy, forKey: .revokedBy)
		try container.encode(subject, forKey: .subject)
		try container.encodeIfPresent(subjectProfile, forKey: .subjectProfile)
		try container.encodeIfPresent(subjectRepo, forKey: .subjectRepo)
		try container.encode(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case createdAt = "createdAt"
		case displayName = "displayName"
		case handle = "handle"
		case issuer = "issuer"
		case issuerProfile = "issuerProfile"
		case issuerRepo = "issuerRepo"
		case revokeReason = "revokeReason"
		case revokedAt = "revokedAt"
		case revokedBy = "revokedBy"
		case subject = "subject"
		case subjectProfile = "subjectProfile"
		case subjectRepo = "subjectRepo"
		case uri = "uri"
	}
}


public typealias ToolsOzoneVerificationDefsVerificationViewIssuerProfile = ATProtocolValueContainer


public indirect enum ToolsOzoneVerificationDefsVerificationViewIssuerRepo: Codable, Sendable, Equatable {
	case repoViewDetail(ToolsOzoneModerationDefsRepoViewDetail)
	case repoViewNotFound(ToolsOzoneModerationDefsRepoViewNotFound)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "tools.ozone.moderation.defs#repoViewDetail": self = .repoViewDetail(try ToolsOzoneModerationDefsRepoViewDetail(from: decoder))
		case "tools.ozone.moderation.defs#repoViewNotFound": self = .repoViewNotFound(try ToolsOzoneModerationDefsRepoViewNotFound(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .repoViewDetail(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "tools.ozone.moderation.defs#repoViewDetail", to: encoder)
		case .repoViewNotFound(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "tools.ozone.moderation.defs#repoViewNotFound", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public typealias ToolsOzoneVerificationDefsVerificationViewSubjectProfile = ATProtocolValueContainer


public struct ToolsOzoneVerificationGrantVerificationsGrantError: Codable, Sendable, Equatable {
	public let error: String
	public let subject: DID

	public init(
		error: String,
		subject: DID
	) {
		self.error = error
		self.subject = subject
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		error = try container.decode(String.self, forKey: .error)
		subject = try container.decode(DID.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(error, forKey: .error)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case error = "error"
		case subject = "subject"
	}
}


public struct ToolsOzoneVerificationGrantVerificationsInput: Codable, Sendable, Equatable {
	public let verifications: [ToolsOzoneVerificationGrantVerificationsVerificationInput]

	public init(
		verifications: [ToolsOzoneVerificationGrantVerificationsVerificationInput]
	) {
		self.verifications = verifications
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		verifications = try container.decode([ToolsOzoneVerificationGrantVerificationsVerificationInput].self, forKey: .verifications)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(verifications, forKey: .verifications)
	}

	private enum CodingKeys: String, CodingKey {
		case verifications = "verifications"
	}
}


public struct ToolsOzoneVerificationGrantVerificationsOutput: Codable, Sendable, Equatable {
	public let failedVerifications: [ToolsOzoneVerificationGrantVerificationsGrantError]
	public let verifications: [ToolsOzoneVerificationDefsVerificationView]

	public init(
		failedVerifications: [ToolsOzoneVerificationGrantVerificationsGrantError],
		verifications: [ToolsOzoneVerificationDefsVerificationView]
	) {
		self.failedVerifications = failedVerifications
		self.verifications = verifications
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		failedVerifications = try container.decode([ToolsOzoneVerificationGrantVerificationsGrantError].self, forKey: .failedVerifications)
		verifications = try container.decode([ToolsOzoneVerificationDefsVerificationView].self, forKey: .verifications)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(failedVerifications, forKey: .failedVerifications)
		try container.encode(verifications, forKey: .verifications)
	}

	private enum CodingKeys: String, CodingKey {
		case failedVerifications = "failedVerifications"
		case verifications = "verifications"
	}
}


public struct ToolsOzoneVerificationGrantVerificationsVerificationInput: Codable, Sendable, Equatable {
	public let createdAt: ATProtocolDate?
	public let displayName: String
	public let handle: Handle
	public let subject: DID

	public init(
		createdAt: ATProtocolDate? = nil,
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
		createdAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .createdAt)
		displayName = try container.decode(String.self, forKey: .displayName)
		handle = try container.decode(Handle.self, forKey: .handle)
		subject = try container.decode(DID.self, forKey: .subject)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(createdAt, forKey: .createdAt)
		try container.encode(displayName, forKey: .displayName)
		try container.encode(handle, forKey: .handle)
		try container.encode(subject, forKey: .subject)
	}

	private enum CodingKeys: String, CodingKey {
		case createdAt = "createdAt"
		case displayName = "displayName"
		case handle = "handle"
		case subject = "subject"
	}
}


public struct ToolsOzoneVerificationListVerificationsOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let verifications: [ToolsOzoneVerificationDefsVerificationView]

	public init(
		cursor: String? = nil,
		verifications: [ToolsOzoneVerificationDefsVerificationView]
	) {
		self.cursor = cursor
		self.verifications = verifications
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		verifications = try container.decode([ToolsOzoneVerificationDefsVerificationView].self, forKey: .verifications)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(verifications, forKey: .verifications)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case verifications = "verifications"
	}
}


public struct ToolsOzoneVerificationListVerificationsParameters: Codable, Sendable, Equatable {
	public let createdAfter: ATProtocolDate?
	public let createdBefore: ATProtocolDate?
	public let cursor: String?
	public let isRevoked: Bool?
	public let issuers: [DID]?
	public let limit: Int?
	public let sortDirection: String?
	public let subjects: [DID]?

	public init(
		createdAfter: ATProtocolDate? = nil,
		createdBefore: ATProtocolDate? = nil,
		cursor: String? = nil,
		isRevoked: Bool? = nil,
		issuers: [DID]? = nil,
		limit: Int? = nil,
		sortDirection: String? = nil,
		subjects: [DID]? = nil
	) {
		self.createdAfter = createdAfter
		self.createdBefore = createdBefore
		self.cursor = cursor
		self.isRevoked = isRevoked
		self.issuers = issuers
		self.limit = limit
		self.sortDirection = sortDirection
		self.subjects = subjects
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		createdAfter = try container.decodeIfPresent(ATProtocolDate.self, forKey: .createdAfter)
		createdBefore = try container.decodeIfPresent(ATProtocolDate.self, forKey: .createdBefore)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		isRevoked = try container.decodeIfPresent(Bool.self, forKey: .isRevoked)
		issuers = try container.decodeIfPresent([DID].self, forKey: .issuers)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		sortDirection = try container.decodeIfPresent(String.self, forKey: .sortDirection)
		subjects = try container.decodeIfPresent([DID].self, forKey: .subjects)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(createdAfter, forKey: .createdAfter)
		try container.encodeIfPresent(createdBefore, forKey: .createdBefore)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(isRevoked, forKey: .isRevoked)
		try container.encodeIfPresent(issuers, forKey: .issuers)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encodeIfPresent(sortDirection, forKey: .sortDirection)
		try container.encodeIfPresent(subjects, forKey: .subjects)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = createdAfter {
			value.appendQueryItems(named: "createdAfter", to: &items)
		}
		if let value = createdBefore {
			value.appendQueryItems(named: "createdBefore", to: &items)
		}
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = isRevoked {
			value.appendQueryItems(named: "isRevoked", to: &items)
		}
		if let value = issuers {
			value.appendQueryItems(named: "issuers", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		if let value = sortDirection {
			value.appendQueryItems(named: "sortDirection", to: &items)
		}
		if let value = subjects {
			value.appendQueryItems(named: "subjects", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case createdAfter = "createdAfter"
		case createdBefore = "createdBefore"
		case cursor = "cursor"
		case isRevoked = "isRevoked"
		case issuers = "issuers"
		case limit = "limit"
		case sortDirection = "sortDirection"
		case subjects = "subjects"
	}
}


public struct ToolsOzoneVerificationRevokeVerificationsInput: Codable, Sendable, Equatable {
	public let revokeReason: String?
	public let uris: [ATURI]

	public init(
		revokeReason: String? = nil,
		uris: [ATURI]
	) {
		self.revokeReason = revokeReason
		self.uris = uris
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		revokeReason = try container.decodeIfPresent(String.self, forKey: .revokeReason)
		uris = try container.decode([ATURI].self, forKey: .uris)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(revokeReason, forKey: .revokeReason)
		try container.encode(uris, forKey: .uris)
	}

	private enum CodingKeys: String, CodingKey {
		case revokeReason = "revokeReason"
		case uris = "uris"
	}
}


public struct ToolsOzoneVerificationRevokeVerificationsOutput: Codable, Sendable, Equatable {
	public let failedRevocations: [ToolsOzoneVerificationRevokeVerificationsRevokeError]
	public let revokedVerifications: [ATURI]

	public init(
		failedRevocations: [ToolsOzoneVerificationRevokeVerificationsRevokeError],
		revokedVerifications: [ATURI]
	) {
		self.failedRevocations = failedRevocations
		self.revokedVerifications = revokedVerifications
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		failedRevocations = try container.decode([ToolsOzoneVerificationRevokeVerificationsRevokeError].self, forKey: .failedRevocations)
		revokedVerifications = try container.decode([ATURI].self, forKey: .revokedVerifications)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(failedRevocations, forKey: .failedRevocations)
		try container.encode(revokedVerifications, forKey: .revokedVerifications)
	}

	private enum CodingKeys: String, CodingKey {
		case failedRevocations = "failedRevocations"
		case revokedVerifications = "revokedVerifications"
	}
}


public struct ToolsOzoneVerificationRevokeVerificationsRevokeError: Codable, Sendable, Equatable {
	public let error: String
	public let uri: ATURI

	public init(
		error: String,
		uri: ATURI
	) {
		self.error = error
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		error = try container.decode(String.self, forKey: .error)
		uri = try container.decode(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(error, forKey: .error)
		try container.encode(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case error = "error"
		case uri = "uri"
	}
}


