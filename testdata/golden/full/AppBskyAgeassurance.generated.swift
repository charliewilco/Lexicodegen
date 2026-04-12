import Foundation


public enum AppBskyAgeassuranceBeginError: String, Swift.Error, CaseIterable, Sendable {
	case didTooLong = "DidTooLong"
	case invalidEmail = "InvalidEmail"
	case invalidInitiation = "InvalidInitiation"
	case regionNotSupported = "RegionNotSupported"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct AppBskyAgeassuranceBeginInput: Codable, Sendable, Equatable {
	public let countryCode: String
	public let email: String
	public let language: String
	public let regionCode: String?

	public init(
		countryCode: String,
		email: String,
		language: String,
		regionCode: String? = nil
	) {
		self.countryCode = countryCode
		self.email = email
		self.language = language
		self.regionCode = regionCode
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		countryCode = try container.decode(String.self, forKey: .countryCode)
		email = try container.decode(String.self, forKey: .email)
		language = try container.decode(String.self, forKey: .language)
		regionCode = try container.decodeIfPresent(String.self, forKey: .regionCode)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(countryCode, forKey: .countryCode)
		try container.encode(email, forKey: .email)
		try container.encode(language, forKey: .language)
		try container.encodeIfPresent(regionCode, forKey: .regionCode)
	}

	private enum CodingKeys: String, CodingKey {
		case countryCode = "countryCode"
		case email = "email"
		case language = "language"
		case regionCode = "regionCode"
	}
}


public typealias AppBskyAgeassuranceBeginOutput = AppBskyAgeassuranceDefsState


public enum AppBskyAgeassuranceDefsAccess: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case unknown = "unknown"
	case none = "none"
	case safe = "safe"
	case full = "full"
}


public struct AppBskyAgeassuranceDefsConfig: Codable, Sendable, Equatable {
	public let regions: [AppBskyAgeassuranceDefsConfigRegion]

	public init(
		regions: [AppBskyAgeassuranceDefsConfigRegion]
	) {
		self.regions = regions
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		regions = try container.decode([AppBskyAgeassuranceDefsConfigRegion].self, forKey: .regions)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(regions, forKey: .regions)
	}

	private enum CodingKeys: String, CodingKey {
		case regions = "regions"
	}
}


public struct AppBskyAgeassuranceDefsConfigRegion: Codable, Sendable, Equatable {
	public let countryCode: String
	public let minAccessAge: Int
	public let regionCode: String?
	public let rules: [AppBskyAgeassuranceDefsConfigRegionRulesItem]

	public init(
		countryCode: String,
		minAccessAge: Int,
		regionCode: String? = nil,
		rules: [AppBskyAgeassuranceDefsConfigRegionRulesItem]
	) {
		self.countryCode = countryCode
		self.minAccessAge = minAccessAge
		self.regionCode = regionCode
		self.rules = rules
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		countryCode = try container.decode(String.self, forKey: .countryCode)
		minAccessAge = try container.decode(Int.self, forKey: .minAccessAge)
		regionCode = try container.decodeIfPresent(String.self, forKey: .regionCode)
		rules = try container.decode([AppBskyAgeassuranceDefsConfigRegionRulesItem].self, forKey: .rules)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(countryCode, forKey: .countryCode)
		try container.encode(minAccessAge, forKey: .minAccessAge)
		try container.encodeIfPresent(regionCode, forKey: .regionCode)
		try container.encode(rules, forKey: .rules)
	}

	private enum CodingKeys: String, CodingKey {
		case countryCode = "countryCode"
		case minAccessAge = "minAccessAge"
		case regionCode = "regionCode"
		case rules = "rules"
	}
}


public struct AppBskyAgeassuranceDefsConfigRegionRuleDefault: Codable, Sendable, Equatable {
	public let access: AppBskyAgeassuranceDefsAccess

	public init(
		access: AppBskyAgeassuranceDefsAccess
	) {
		self.access = access
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		access = try container.decode(AppBskyAgeassuranceDefsAccess.self, forKey: .access)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(access, forKey: .access)
	}

	private enum CodingKeys: String, CodingKey {
		case access = "access"
	}
}


public struct AppBskyAgeassuranceDefsConfigRegionRuleIfAccountNewerThan: Codable, Sendable, Equatable {
	public let access: AppBskyAgeassuranceDefsAccess
	public let date: ATProtocolDate

	public init(
		access: AppBskyAgeassuranceDefsAccess,
		date: ATProtocolDate
	) {
		self.access = access
		self.date = date
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		access = try container.decode(AppBskyAgeassuranceDefsAccess.self, forKey: .access)
		date = try container.decode(ATProtocolDate.self, forKey: .date)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(access, forKey: .access)
		try container.encode(date, forKey: .date)
	}

	private enum CodingKeys: String, CodingKey {
		case access = "access"
		case date = "date"
	}
}


public struct AppBskyAgeassuranceDefsConfigRegionRuleIfAccountOlderThan: Codable, Sendable, Equatable {
	public let access: AppBskyAgeassuranceDefsAccess
	public let date: ATProtocolDate

	public init(
		access: AppBskyAgeassuranceDefsAccess,
		date: ATProtocolDate
	) {
		self.access = access
		self.date = date
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		access = try container.decode(AppBskyAgeassuranceDefsAccess.self, forKey: .access)
		date = try container.decode(ATProtocolDate.self, forKey: .date)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(access, forKey: .access)
		try container.encode(date, forKey: .date)
	}

	private enum CodingKeys: String, CodingKey {
		case access = "access"
		case date = "date"
	}
}


public struct AppBskyAgeassuranceDefsConfigRegionRuleIfAssuredOverAge: Codable, Sendable, Equatable {
	public let access: AppBskyAgeassuranceDefsAccess
	public let age: Int

	public init(
		access: AppBskyAgeassuranceDefsAccess,
		age: Int
	) {
		self.access = access
		self.age = age
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		access = try container.decode(AppBskyAgeassuranceDefsAccess.self, forKey: .access)
		age = try container.decode(Int.self, forKey: .age)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(access, forKey: .access)
		try container.encode(age, forKey: .age)
	}

	private enum CodingKeys: String, CodingKey {
		case access = "access"
		case age = "age"
	}
}


public struct AppBskyAgeassuranceDefsConfigRegionRuleIfAssuredUnderAge: Codable, Sendable, Equatable {
	public let access: AppBskyAgeassuranceDefsAccess
	public let age: Int

	public init(
		access: AppBskyAgeassuranceDefsAccess,
		age: Int
	) {
		self.access = access
		self.age = age
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		access = try container.decode(AppBskyAgeassuranceDefsAccess.self, forKey: .access)
		age = try container.decode(Int.self, forKey: .age)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(access, forKey: .access)
		try container.encode(age, forKey: .age)
	}

	private enum CodingKeys: String, CodingKey {
		case access = "access"
		case age = "age"
	}
}


public struct AppBskyAgeassuranceDefsConfigRegionRuleIfDeclaredOverAge: Codable, Sendable, Equatable {
	public let access: AppBskyAgeassuranceDefsAccess
	public let age: Int

	public init(
		access: AppBskyAgeassuranceDefsAccess,
		age: Int
	) {
		self.access = access
		self.age = age
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		access = try container.decode(AppBskyAgeassuranceDefsAccess.self, forKey: .access)
		age = try container.decode(Int.self, forKey: .age)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(access, forKey: .access)
		try container.encode(age, forKey: .age)
	}

	private enum CodingKeys: String, CodingKey {
		case access = "access"
		case age = "age"
	}
}


public struct AppBskyAgeassuranceDefsConfigRegionRuleIfDeclaredUnderAge: Codable, Sendable, Equatable {
	public let access: AppBskyAgeassuranceDefsAccess
	public let age: Int

	public init(
		access: AppBskyAgeassuranceDefsAccess,
		age: Int
	) {
		self.access = access
		self.age = age
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		access = try container.decode(AppBskyAgeassuranceDefsAccess.self, forKey: .access)
		age = try container.decode(Int.self, forKey: .age)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(access, forKey: .access)
		try container.encode(age, forKey: .age)
	}

	private enum CodingKeys: String, CodingKey {
		case access = "access"
		case age = "age"
	}
}


public indirect enum AppBskyAgeassuranceDefsConfigRegionRulesItem: Codable, Sendable, Equatable {
	case configRegionRuleDefault(AppBskyAgeassuranceDefsConfigRegionRuleDefault)
	case configRegionRuleIfDeclaredOverAge(AppBskyAgeassuranceDefsConfigRegionRuleIfDeclaredOverAge)
	case configRegionRuleIfDeclaredUnderAge(AppBskyAgeassuranceDefsConfigRegionRuleIfDeclaredUnderAge)
	case configRegionRuleIfAssuredOverAge(AppBskyAgeassuranceDefsConfigRegionRuleIfAssuredOverAge)
	case configRegionRuleIfAssuredUnderAge(AppBskyAgeassuranceDefsConfigRegionRuleIfAssuredUnderAge)
	case configRegionRuleIfAccountNewerThan(AppBskyAgeassuranceDefsConfigRegionRuleIfAccountNewerThan)
	case configRegionRuleIfAccountOlderThan(AppBskyAgeassuranceDefsConfigRegionRuleIfAccountOlderThan)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "app.bsky.ageassurance.defs#configRegionRuleDefault": self = .configRegionRuleDefault(try AppBskyAgeassuranceDefsConfigRegionRuleDefault(from: decoder))
		case "app.bsky.ageassurance.defs#configRegionRuleIfDeclaredOverAge": self = .configRegionRuleIfDeclaredOverAge(try AppBskyAgeassuranceDefsConfigRegionRuleIfDeclaredOverAge(from: decoder))
		case "app.bsky.ageassurance.defs#configRegionRuleIfDeclaredUnderAge": self = .configRegionRuleIfDeclaredUnderAge(try AppBskyAgeassuranceDefsConfigRegionRuleIfDeclaredUnderAge(from: decoder))
		case "app.bsky.ageassurance.defs#configRegionRuleIfAssuredOverAge": self = .configRegionRuleIfAssuredOverAge(try AppBskyAgeassuranceDefsConfigRegionRuleIfAssuredOverAge(from: decoder))
		case "app.bsky.ageassurance.defs#configRegionRuleIfAssuredUnderAge": self = .configRegionRuleIfAssuredUnderAge(try AppBskyAgeassuranceDefsConfigRegionRuleIfAssuredUnderAge(from: decoder))
		case "app.bsky.ageassurance.defs#configRegionRuleIfAccountNewerThan": self = .configRegionRuleIfAccountNewerThan(try AppBskyAgeassuranceDefsConfigRegionRuleIfAccountNewerThan(from: decoder))
		case "app.bsky.ageassurance.defs#configRegionRuleIfAccountOlderThan": self = .configRegionRuleIfAccountOlderThan(try AppBskyAgeassuranceDefsConfigRegionRuleIfAccountOlderThan(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .configRegionRuleDefault(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.ageassurance.defs#configRegionRuleDefault", to: encoder)
		case .configRegionRuleIfDeclaredOverAge(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.ageassurance.defs#configRegionRuleIfDeclaredOverAge", to: encoder)
		case .configRegionRuleIfDeclaredUnderAge(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.ageassurance.defs#configRegionRuleIfDeclaredUnderAge", to: encoder)
		case .configRegionRuleIfAssuredOverAge(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.ageassurance.defs#configRegionRuleIfAssuredOverAge", to: encoder)
		case .configRegionRuleIfAssuredUnderAge(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.ageassurance.defs#configRegionRuleIfAssuredUnderAge", to: encoder)
		case .configRegionRuleIfAccountNewerThan(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.ageassurance.defs#configRegionRuleIfAccountNewerThan", to: encoder)
		case .configRegionRuleIfAccountOlderThan(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "app.bsky.ageassurance.defs#configRegionRuleIfAccountOlderThan", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct AppBskyAgeassuranceDefsEvent: Codable, Sendable, Equatable {
	public let access: AppBskyAgeassuranceDefsEventAccess
	public let attemptId: String
	public let completeIp: String?
	public let completeUa: String?
	public let countryCode: String
	public let createdAt: ATProtocolDate
	public let email: String?
	public let initIp: String?
	public let initUa: String?
	public let regionCode: String?
	public let status: AppBskyAgeassuranceDefsEventStatus

	public init(
		access: AppBskyAgeassuranceDefsEventAccess,
		attemptId: String,
		completeIp: String? = nil,
		completeUa: String? = nil,
		countryCode: String,
		createdAt: ATProtocolDate,
		email: String? = nil,
		initIp: String? = nil,
		initUa: String? = nil,
		regionCode: String? = nil,
		status: AppBskyAgeassuranceDefsEventStatus
	) {
		self.access = access
		self.attemptId = attemptId
		self.completeIp = completeIp
		self.completeUa = completeUa
		self.countryCode = countryCode
		self.createdAt = createdAt
		self.email = email
		self.initIp = initIp
		self.initUa = initUa
		self.regionCode = regionCode
		self.status = status
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		access = try container.decode(AppBskyAgeassuranceDefsEventAccess.self, forKey: .access)
		attemptId = try container.decode(String.self, forKey: .attemptId)
		completeIp = try container.decodeIfPresent(String.self, forKey: .completeIp)
		completeUa = try container.decodeIfPresent(String.self, forKey: .completeUa)
		countryCode = try container.decode(String.self, forKey: .countryCode)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		email = try container.decodeIfPresent(String.self, forKey: .email)
		initIp = try container.decodeIfPresent(String.self, forKey: .initIp)
		initUa = try container.decodeIfPresent(String.self, forKey: .initUa)
		regionCode = try container.decodeIfPresent(String.self, forKey: .regionCode)
		status = try container.decode(AppBskyAgeassuranceDefsEventStatus.self, forKey: .status)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(access, forKey: .access)
		try container.encode(attemptId, forKey: .attemptId)
		try container.encodeIfPresent(completeIp, forKey: .completeIp)
		try container.encodeIfPresent(completeUa, forKey: .completeUa)
		try container.encode(countryCode, forKey: .countryCode)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encodeIfPresent(email, forKey: .email)
		try container.encodeIfPresent(initIp, forKey: .initIp)
		try container.encodeIfPresent(initUa, forKey: .initUa)
		try container.encodeIfPresent(regionCode, forKey: .regionCode)
		try container.encode(status, forKey: .status)
	}

	private enum CodingKeys: String, CodingKey {
		case access = "access"
		case attemptId = "attemptId"
		case completeIp = "completeIp"
		case completeUa = "completeUa"
		case countryCode = "countryCode"
		case createdAt = "createdAt"
		case email = "email"
		case initIp = "initIp"
		case initUa = "initUa"
		case regionCode = "regionCode"
		case status = "status"
	}
}


public enum AppBskyAgeassuranceDefsEventAccess: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case unknown = "unknown"
	case none = "none"
	case safe = "safe"
	case full = "full"
}


public enum AppBskyAgeassuranceDefsEventStatus: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case unknown = "unknown"
	case pending = "pending"
	case assured = "assured"
	case blocked = "blocked"
}


public struct AppBskyAgeassuranceDefsState: Codable, Sendable, Equatable {
	public let access: AppBskyAgeassuranceDefsAccess
	public let lastInitiatedAt: ATProtocolDate?
	public let status: AppBskyAgeassuranceDefsStatus

	public init(
		access: AppBskyAgeassuranceDefsAccess,
		lastInitiatedAt: ATProtocolDate? = nil,
		status: AppBskyAgeassuranceDefsStatus
	) {
		self.access = access
		self.lastInitiatedAt = lastInitiatedAt
		self.status = status
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		access = try container.decode(AppBskyAgeassuranceDefsAccess.self, forKey: .access)
		lastInitiatedAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .lastInitiatedAt)
		status = try container.decode(AppBskyAgeassuranceDefsStatus.self, forKey: .status)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(access, forKey: .access)
		try container.encodeIfPresent(lastInitiatedAt, forKey: .lastInitiatedAt)
		try container.encode(status, forKey: .status)
	}

	private enum CodingKeys: String, CodingKey {
		case access = "access"
		case lastInitiatedAt = "lastInitiatedAt"
		case status = "status"
	}
}


public struct AppBskyAgeassuranceDefsStateMetadata: Codable, Sendable, Equatable {
	public let accountCreatedAt: ATProtocolDate?

	public init(
		accountCreatedAt: ATProtocolDate? = nil
	) {
		self.accountCreatedAt = accountCreatedAt
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		accountCreatedAt = try container.decodeIfPresent(ATProtocolDate.self, forKey: .accountCreatedAt)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(accountCreatedAt, forKey: .accountCreatedAt)
	}

	private enum CodingKeys: String, CodingKey {
		case accountCreatedAt = "accountCreatedAt"
	}
}


public enum AppBskyAgeassuranceDefsStatus: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case unknown = "unknown"
	case pending = "pending"
	case assured = "assured"
	case blocked = "blocked"
}


public typealias AppBskyAgeassuranceGetConfigOutput = AppBskyAgeassuranceDefsConfig


public struct AppBskyAgeassuranceGetStateOutput: Codable, Sendable, Equatable {
	public let metadata: AppBskyAgeassuranceDefsStateMetadata
	public let state: AppBskyAgeassuranceDefsState

	public init(
		metadata: AppBskyAgeassuranceDefsStateMetadata,
		state: AppBskyAgeassuranceDefsState
	) {
		self.metadata = metadata
		self.state = state
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		metadata = try container.decode(AppBskyAgeassuranceDefsStateMetadata.self, forKey: .metadata)
		state = try container.decode(AppBskyAgeassuranceDefsState.self, forKey: .state)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(metadata, forKey: .metadata)
		try container.encode(state, forKey: .state)
	}

	private enum CodingKeys: String, CodingKey {
		case metadata = "metadata"
		case state = "state"
	}
}


public struct AppBskyAgeassuranceGetStateParameters: Codable, Sendable, Equatable {
	public let countryCode: String
	public let regionCode: String?

	public init(
		countryCode: String,
		regionCode: String? = nil
	) {
		self.countryCode = countryCode
		self.regionCode = regionCode
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		countryCode = try container.decode(String.self, forKey: .countryCode)
		regionCode = try container.decodeIfPresent(String.self, forKey: .regionCode)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(countryCode, forKey: .countryCode)
		try container.encodeIfPresent(regionCode, forKey: .regionCode)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		countryCode.appendQueryItems(named: "countryCode", to: &items)
		if let value = regionCode {
			value.appendQueryItems(named: "regionCode", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case countryCode = "countryCode"
		case regionCode = "regionCode"
	}
}


