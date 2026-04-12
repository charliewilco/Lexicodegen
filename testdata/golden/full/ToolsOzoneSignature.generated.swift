import Foundation


public struct ToolsOzoneSignatureDefsSigDetail: Codable, Sendable, Equatable {
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


public struct ToolsOzoneSignatureFindCorrelationOutput: Codable, Sendable, Equatable {
	public let details: [ToolsOzoneSignatureDefsSigDetail]

	public init(
		details: [ToolsOzoneSignatureDefsSigDetail]
	) {
		self.details = details
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		details = try container.decode([ToolsOzoneSignatureDefsSigDetail].self, forKey: .details)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(details, forKey: .details)
	}

	private enum CodingKeys: String, CodingKey {
		case details = "details"
	}
}


public struct ToolsOzoneSignatureFindCorrelationParameters: Codable, Sendable, Equatable {
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


public struct ToolsOzoneSignatureFindRelatedAccountsOutput: Codable, Sendable, Equatable {
	public let accounts: [ToolsOzoneSignatureFindRelatedAccountsRelatedAccount]
	public let cursor: String?

	public init(
		accounts: [ToolsOzoneSignatureFindRelatedAccountsRelatedAccount],
		cursor: String? = nil
	) {
		self.accounts = accounts
		self.cursor = cursor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		accounts = try container.decode([ToolsOzoneSignatureFindRelatedAccountsRelatedAccount].self, forKey: .accounts)
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


public struct ToolsOzoneSignatureFindRelatedAccountsParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let did: DID
	public let limit: Int?

	public init(
		cursor: String? = nil,
		did: DID,
		limit: Int? = nil
	) {
		self.cursor = cursor
		self.did = did
		self.limit = limit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		did = try container.decode(DID.self, forKey: .did)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(did, forKey: .did)
		try container.encodeIfPresent(limit, forKey: .limit)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		did.appendQueryItems(named: "did", to: &items)
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case did = "did"
		case limit = "limit"
	}
}


public struct ToolsOzoneSignatureFindRelatedAccountsRelatedAccount: Codable, Sendable, Equatable {
	public let account: ComAtprotoAdminDefsAccountView
	public let similarities: [ToolsOzoneSignatureDefsSigDetail]?

	public init(
		account: ComAtprotoAdminDefsAccountView,
		similarities: [ToolsOzoneSignatureDefsSigDetail]? = nil
	) {
		self.account = account
		self.similarities = similarities
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		account = try container.decode(ComAtprotoAdminDefsAccountView.self, forKey: .account)
		similarities = try container.decodeIfPresent([ToolsOzoneSignatureDefsSigDetail].self, forKey: .similarities)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(account, forKey: .account)
		try container.encodeIfPresent(similarities, forKey: .similarities)
	}

	private enum CodingKeys: String, CodingKey {
		case account = "account"
		case similarities = "similarities"
	}
}


public struct ToolsOzoneSignatureSearchAccountsOutput: Codable, Sendable, Equatable {
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


public struct ToolsOzoneSignatureSearchAccountsParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?
	public let values: [String]

	public init(
		cursor: String? = nil,
		limit: Int? = nil,
		values: [String]
	) {
		self.cursor = cursor
		self.limit = limit
		self.values = values
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		values = try container.decode([String].self, forKey: .values)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encode(values, forKey: .values)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		values.appendQueryItems(named: "values", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
		case values = "values"
	}
}


