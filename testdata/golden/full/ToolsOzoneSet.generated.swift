import Foundation


public struct ToolsOzoneSetAddValuesInput: Codable, Sendable, Equatable {
	public let name: String
	public let values: [String]

	public init(
		name: String,
		values: [String]
	) {
		self.name = name
		self.values = values
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decode(String.self, forKey: .name)
		values = try container.decode([String].self, forKey: .values)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(values, forKey: .values)
	}

	private enum CodingKeys: String, CodingKey {
		case name = "name"
		case values = "values"
	}
}


public struct ToolsOzoneSetDefsSet: Codable, Sendable, Equatable {
	public let description: String?
	public let name: String

	public init(
		description: String? = nil,
		name: String
	) {
		self.description = description
		self.name = name
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		description = try container.decodeIfPresent(String.self, forKey: .description)
		name = try container.decode(String.self, forKey: .name)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encode(name, forKey: .name)
	}

	private enum CodingKeys: String, CodingKey {
		case description = "description"
		case name = "name"
	}
}


public struct ToolsOzoneSetDefsSetView: Codable, Sendable, Equatable {
	public let createdAt: ATProtocolDate
	public let description: String?
	public let name: String
	public let setSize: Int
	public let updatedAt: ATProtocolDate

	public init(
		createdAt: ATProtocolDate,
		description: String? = nil,
		name: String,
		setSize: Int,
		updatedAt: ATProtocolDate
	) {
		self.createdAt = createdAt
		self.description = description
		self.name = name
		self.setSize = setSize
		self.updatedAt = updatedAt
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		createdAt = try container.decode(ATProtocolDate.self, forKey: .createdAt)
		description = try container.decodeIfPresent(String.self, forKey: .description)
		name = try container.decode(String.self, forKey: .name)
		setSize = try container.decode(Int.self, forKey: .setSize)
		updatedAt = try container.decode(ATProtocolDate.self, forKey: .updatedAt)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encode(name, forKey: .name)
		try container.encode(setSize, forKey: .setSize)
		try container.encode(updatedAt, forKey: .updatedAt)
	}

	private enum CodingKeys: String, CodingKey {
		case createdAt = "createdAt"
		case description = "description"
		case name = "name"
		case setSize = "setSize"
		case updatedAt = "updatedAt"
	}
}


public enum ToolsOzoneSetDeleteSetError: String, Swift.Error, CaseIterable, Sendable {
	case setNotFound = "SetNotFound"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ToolsOzoneSetDeleteSetInput: Codable, Sendable, Equatable {
	public let name: String

	public init(
		name: String
	) {
		self.name = name
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decode(String.self, forKey: .name)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
	}

	private enum CodingKeys: String, CodingKey {
		case name = "name"
	}
}


public struct ToolsOzoneSetDeleteSetOutput: Codable, Sendable, Equatable {

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


public enum ToolsOzoneSetDeleteValuesError: String, Swift.Error, CaseIterable, Sendable {
	case setNotFound = "SetNotFound"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ToolsOzoneSetDeleteValuesInput: Codable, Sendable, Equatable {
	public let name: String
	public let values: [String]

	public init(
		name: String,
		values: [String]
	) {
		self.name = name
		self.values = values
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decode(String.self, forKey: .name)
		values = try container.decode([String].self, forKey: .values)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(values, forKey: .values)
	}

	private enum CodingKeys: String, CodingKey {
		case name = "name"
		case values = "values"
	}
}


public enum ToolsOzoneSetGetValuesError: String, Swift.Error, CaseIterable, Sendable {
	case setNotFound = "SetNotFound"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ToolsOzoneSetGetValuesOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let set: ToolsOzoneSetDefsSetView
	public let values: [String]

	public init(
		cursor: String? = nil,
		set: ToolsOzoneSetDefsSetView,
		values: [String]
	) {
		self.cursor = cursor
		self.set = set
		self.values = values
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		set = try container.decode(ToolsOzoneSetDefsSetView.self, forKey: .set)
		values = try container.decode([String].self, forKey: .values)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(set, forKey: .set)
		try container.encode(values, forKey: .values)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case set = "set"
		case values = "values"
	}
}


public struct ToolsOzoneSetGetValuesParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?
	public let name: String

	public init(
		cursor: String? = nil,
		limit: Int? = nil,
		name: String
	) {
		self.cursor = cursor
		self.limit = limit
		self.name = name
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		name = try container.decode(String.self, forKey: .name)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encode(name, forKey: .name)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		name.appendQueryItems(named: "name", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
		case name = "name"
	}
}


public struct ToolsOzoneSetQuerySetsOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let sets: [ToolsOzoneSetDefsSetView]

	public init(
		cursor: String? = nil,
		sets: [ToolsOzoneSetDefsSetView]
	) {
		self.cursor = cursor
		self.sets = sets
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		sets = try container.decode([ToolsOzoneSetDefsSetView].self, forKey: .sets)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(sets, forKey: .sets)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case sets = "sets"
	}
}


public struct ToolsOzoneSetQuerySetsParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?
	public let namePrefix: String?
	public let sortBy: String?
	public let sortDirection: String?

	public init(
		cursor: String? = nil,
		limit: Int? = nil,
		namePrefix: String? = nil,
		sortBy: String? = nil,
		sortDirection: String? = nil
	) {
		self.cursor = cursor
		self.limit = limit
		self.namePrefix = namePrefix
		self.sortBy = sortBy
		self.sortDirection = sortDirection
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		namePrefix = try container.decodeIfPresent(String.self, forKey: .namePrefix)
		sortBy = try container.decodeIfPresent(String.self, forKey: .sortBy)
		sortDirection = try container.decodeIfPresent(String.self, forKey: .sortDirection)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encodeIfPresent(namePrefix, forKey: .namePrefix)
		try container.encodeIfPresent(sortBy, forKey: .sortBy)
		try container.encodeIfPresent(sortDirection, forKey: .sortDirection)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		if let value = namePrefix {
			value.appendQueryItems(named: "namePrefix", to: &items)
		}
		if let value = sortBy {
			value.appendQueryItems(named: "sortBy", to: &items)
		}
		if let value = sortDirection {
			value.appendQueryItems(named: "sortDirection", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
		case namePrefix = "namePrefix"
		case sortBy = "sortBy"
		case sortDirection = "sortDirection"
	}
}


public typealias ToolsOzoneSetUpsertSetInput = ToolsOzoneSetDefsSet


public typealias ToolsOzoneSetUpsertSetOutput = ToolsOzoneSetDefsSetView


