import Foundation


public struct ComAtprotoIdentityDefsIdentityInfo: Codable, Sendable, Equatable {
	public let did: DID
	public let didDoc: ATProtocolValueContainer
	public let handle: Handle

	public init(
		did: DID,
		didDoc: ATProtocolValueContainer,
		handle: Handle
	) {
		self.did = did
		self.didDoc = didDoc
		self.handle = handle
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		did = try container.decode(DID.self, forKey: .did)
		didDoc = try container.decode(ATProtocolValueContainer.self, forKey: .didDoc)
		handle = try container.decode(Handle.self, forKey: .handle)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(did, forKey: .did)
		try container.encode(didDoc, forKey: .didDoc)
		try container.encode(handle, forKey: .handle)
	}

	private enum CodingKeys: String, CodingKey {
		case did = "did"
		case didDoc = "didDoc"
		case handle = "handle"
	}
}


public struct ComAtprotoIdentityGetRecommendedDidCredentialsOutput: Codable, Sendable, Equatable {
	public let alsoKnownAs: [String]?
	public let rotationKeys: [String]?
	public let services: ATProtocolValueContainer?
	public let verificationMethods: ATProtocolValueContainer?

	public init(
		alsoKnownAs: [String]? = nil,
		rotationKeys: [String]? = nil,
		services: ATProtocolValueContainer? = nil,
		verificationMethods: ATProtocolValueContainer? = nil
	) {
		self.alsoKnownAs = alsoKnownAs
		self.rotationKeys = rotationKeys
		self.services = services
		self.verificationMethods = verificationMethods
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		alsoKnownAs = try container.decodeIfPresent([String].self, forKey: .alsoKnownAs)
		rotationKeys = try container.decodeIfPresent([String].self, forKey: .rotationKeys)
		services = try container.decodeIfPresent(ATProtocolValueContainer.self, forKey: .services)
		verificationMethods = try container.decodeIfPresent(ATProtocolValueContainer.self, forKey: .verificationMethods)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(alsoKnownAs, forKey: .alsoKnownAs)
		try container.encodeIfPresent(rotationKeys, forKey: .rotationKeys)
		try container.encodeIfPresent(services, forKey: .services)
		try container.encodeIfPresent(verificationMethods, forKey: .verificationMethods)
	}

	private enum CodingKeys: String, CodingKey {
		case alsoKnownAs = "alsoKnownAs"
		case rotationKeys = "rotationKeys"
		case services = "services"
		case verificationMethods = "verificationMethods"
	}
}


public enum ComAtprotoIdentityRefreshIdentityError: String, Swift.Error, CaseIterable, Sendable {
	case didDeactivated = "DidDeactivated"
	case didNotFound = "DidNotFound"
	case handleNotFound = "HandleNotFound"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ComAtprotoIdentityRefreshIdentityInput: Codable, Sendable, Equatable {
	public let identifier: ATIdentifier

	public init(
		identifier: ATIdentifier
	) {
		self.identifier = identifier
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		identifier = try container.decode(ATIdentifier.self, forKey: .identifier)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(identifier, forKey: .identifier)
	}

	private enum CodingKeys: String, CodingKey {
		case identifier = "identifier"
	}
}


public typealias ComAtprotoIdentityRefreshIdentityOutput = ComAtprotoIdentityDefsIdentityInfo


public enum ComAtprotoIdentityResolveDidError: String, Swift.Error, CaseIterable, Sendable {
	case didDeactivated = "DidDeactivated"
	case didNotFound = "DidNotFound"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ComAtprotoIdentityResolveDidOutput: Codable, Sendable, Equatable {
	public let didDoc: ATProtocolValueContainer

	public init(
		didDoc: ATProtocolValueContainer
	) {
		self.didDoc = didDoc
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		didDoc = try container.decode(ATProtocolValueContainer.self, forKey: .didDoc)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(didDoc, forKey: .didDoc)
	}

	private enum CodingKeys: String, CodingKey {
		case didDoc = "didDoc"
	}
}


public struct ComAtprotoIdentityResolveDidParameters: Codable, Sendable, Equatable {
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


public enum ComAtprotoIdentityResolveHandleError: String, Swift.Error, CaseIterable, Sendable {
	case handleNotFound = "HandleNotFound"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ComAtprotoIdentityResolveHandleOutput: Codable, Sendable, Equatable {
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


public struct ComAtprotoIdentityResolveHandleParameters: Codable, Sendable, Equatable {
	public let handle: Handle

	public init(
		handle: Handle
	) {
		self.handle = handle
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		handle = try container.decode(Handle.self, forKey: .handle)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(handle, forKey: .handle)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		handle.appendQueryItems(named: "handle", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case handle = "handle"
	}
}


public enum ComAtprotoIdentityResolveIdentityError: String, Swift.Error, CaseIterable, Sendable {
	case didDeactivated = "DidDeactivated"
	case didNotFound = "DidNotFound"
	case handleNotFound = "HandleNotFound"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public typealias ComAtprotoIdentityResolveIdentityOutput = ComAtprotoIdentityDefsIdentityInfo


public struct ComAtprotoIdentityResolveIdentityParameters: Codable, Sendable, Equatable {
	public let identifier: ATIdentifier

	public init(
		identifier: ATIdentifier
	) {
		self.identifier = identifier
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		identifier = try container.decode(ATIdentifier.self, forKey: .identifier)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(identifier, forKey: .identifier)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		identifier.appendQueryItems(named: "identifier", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case identifier = "identifier"
	}
}


public struct ComAtprotoIdentitySignPlcOperationInput: Codable, Sendable, Equatable {
	public let alsoKnownAs: [String]?
	public let rotationKeys: [String]?
	public let services: ATProtocolValueContainer?
	public let token: String?
	public let verificationMethods: ATProtocolValueContainer?

	public init(
		alsoKnownAs: [String]? = nil,
		rotationKeys: [String]? = nil,
		services: ATProtocolValueContainer? = nil,
		token: String? = nil,
		verificationMethods: ATProtocolValueContainer? = nil
	) {
		self.alsoKnownAs = alsoKnownAs
		self.rotationKeys = rotationKeys
		self.services = services
		self.token = token
		self.verificationMethods = verificationMethods
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		alsoKnownAs = try container.decodeIfPresent([String].self, forKey: .alsoKnownAs)
		rotationKeys = try container.decodeIfPresent([String].self, forKey: .rotationKeys)
		services = try container.decodeIfPresent(ATProtocolValueContainer.self, forKey: .services)
		token = try container.decodeIfPresent(String.self, forKey: .token)
		verificationMethods = try container.decodeIfPresent(ATProtocolValueContainer.self, forKey: .verificationMethods)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(alsoKnownAs, forKey: .alsoKnownAs)
		try container.encodeIfPresent(rotationKeys, forKey: .rotationKeys)
		try container.encodeIfPresent(services, forKey: .services)
		try container.encodeIfPresent(token, forKey: .token)
		try container.encodeIfPresent(verificationMethods, forKey: .verificationMethods)
	}

	private enum CodingKeys: String, CodingKey {
		case alsoKnownAs = "alsoKnownAs"
		case rotationKeys = "rotationKeys"
		case services = "services"
		case token = "token"
		case verificationMethods = "verificationMethods"
	}
}


public struct ComAtprotoIdentitySignPlcOperationOutput: Codable, Sendable, Equatable {
	public let operation: ATProtocolValueContainer

	public init(
		operation: ATProtocolValueContainer
	) {
		self.operation = operation
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		operation = try container.decode(ATProtocolValueContainer.self, forKey: .operation)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(operation, forKey: .operation)
	}

	private enum CodingKeys: String, CodingKey {
		case operation = "operation"
	}
}


public struct ComAtprotoIdentitySubmitPlcOperationInput: Codable, Sendable, Equatable {
	public let operation: ATProtocolValueContainer

	public init(
		operation: ATProtocolValueContainer
	) {
		self.operation = operation
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		operation = try container.decode(ATProtocolValueContainer.self, forKey: .operation)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(operation, forKey: .operation)
	}

	private enum CodingKeys: String, CodingKey {
		case operation = "operation"
	}
}


public struct ComAtprotoIdentityUpdateHandleInput: Codable, Sendable, Equatable {
	public let handle: Handle

	public init(
		handle: Handle
	) {
		self.handle = handle
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		handle = try container.decode(Handle.self, forKey: .handle)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(handle, forKey: .handle)
	}

	private enum CodingKeys: String, CodingKey {
		case handle = "handle"
	}
}


