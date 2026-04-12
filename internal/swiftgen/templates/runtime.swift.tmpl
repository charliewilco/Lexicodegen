import Foundation

public protocol QueryParameterValue {
	func appendQueryItems(named name: String, to items: inout [URLQueryItem])
}

public protocol Parametrizable {
	func asQueryItems() -> [URLQueryItem]
}

public struct XRPCRequest: Sendable {
	public let method: String
	public let path: String
	public let queryItems: [URLQueryItem]
	public let body: Data?
	public let headers: [String: String]
	public let responseKind: XRPCResponseKind

	public init(
		method: String,
		path: String,
		queryItems: [URLQueryItem] = [],
		body: Data? = nil,
		headers: [String: String] = [:],
		responseKind: XRPCResponseKind = .json
	) {
		self.method = method
		self.path = path
		self.queryItems = queryItems
		self.body = body
		self.headers = headers
		self.responseKind = responseKind
	}
}

public protocol LexiconTransport {
	func execute(_ request: XRPCRequest) async throws -> XRPCResponse
	func subscribe(_ request: XRPCRequest) -> AsyncThrowingStream<XRPCSubscriptionFrame, Error>
}

public enum LexiconRuntimeError: Error {
	case unsupported
}

public struct XRPCErrorPayload: Codable, Sendable, Equatable {
	public let error: String?
	public let message: String?
}

public struct XRPCResponse: Sendable, Equatable {
	public let statusCode: Int?
	public let body: Data

	public init(statusCode: Int? = nil, body: Data) {
		self.statusCode = statusCode
		self.body = body
	}
}

public enum XRPCResponseKind: Sendable {
	case json
	case binary
	case jsonl
	case car
	case subscription
}

public enum XRPCSubscriptionFrame: Sendable, Equatable {
	case message(Data)
	case error(XRPCErrorPayload)
}

public enum XRPCSubscriptionEvent<Message: Sendable>: Sendable {
	case message(Message)
	case error(XRPCErrorPayload)
}

public struct XRPCTransportError: Error, Sendable, Equatable {
	public let statusCode: Int?
	public let payload: XRPCErrorPayload?

	public init(statusCode: Int? = nil, payload: XRPCErrorPayload? = nil) {
		self.statusCode = statusCode
		self.payload = payload
	}

	public init(statusCode: Int? = nil, body: Data, decoder: JSONDecoder = JSONDecoder()) {
		self.statusCode = statusCode
		self.payload = try? decoder.decode(XRPCErrorPayload.self, from: body)
	}
}

public struct EmptyResponse: Codable, Hashable, Sendable {
	public init() {}

	public init(from decoder: Decoder) throws {
		if let container = try? decoder.container(keyedBy: DynamicCodingKey.self) {
			guard container.allKeys.isEmpty else {
				throw DecodingError.dataCorrupted(
					DecodingError.Context(
						codingPath: decoder.codingPath,
						debugDescription: "Expected an empty object for EmptyResponse"
					)
				)
			}
			return
		}

		if let container = try? decoder.unkeyedContainer(), container.isAtEnd {
			return
		}

		let container = try decoder.singleValueContainer()
		if container.decodeNil() {
			return
		}

		throw DecodingError.dataCorruptedError(
			in: container,
			debugDescription: "Expected an empty payload for EmptyResponse"
		)
	}

	public func encode(to encoder: Encoder) throws {
		_ = encoder.container(keyedBy: DynamicCodingKey.self)
	}
}

public enum ATProtocolValueContainer: Codable, Sendable, Equatable {
	case string(String)
	case int(Int)
	case double(Double)
	case bool(Bool)
	case object([String: ATProtocolValueContainer])
	case array([ATProtocolValueContainer])
	case null

	public init(from decoder: Decoder) throws {
		if let container = try? decoder.container(keyedBy: DynamicCodingKey.self) {
			var object: [String: ATProtocolValueContainer] = [:]
			for key in container.allKeys {
				object[key.stringValue] = try container.decode(
					ATProtocolValueContainer.self,
					forKey: key
				)
			}
			self = .object(object)
			return
		}

		let arrayContainer = try? decoder.unkeyedContainer()
		if var arrayContainer {
			var values: [ATProtocolValueContainer] = []
			while !arrayContainer.isAtEnd {
				values.append(try arrayContainer.decode(ATProtocolValueContainer.self))
			}
			self = .array(values)
			return
		}

		let container = try decoder.singleValueContainer()
		if container.decodeNil() {
			self = .null
		} else if let value = try? container.decode(Bool.self) {
			self = .bool(value)
		} else if let value = try? container.decode(Int.self) {
			self = .int(value)
		} else if let value = try? container.decode(Double.self) {
			self = .double(value)
		} else if let value = try? container.decode(String.self) {
			self = .string(value)
		} else {
			throw DecodingError.dataCorruptedError(
				in: container,
				debugDescription: "Unsupported ATProtocolValueContainer payload"
			)
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .string(let value):
			var container = encoder.singleValueContainer()
			try container.encode(value)
		case .int(let value):
			var container = encoder.singleValueContainer()
			try container.encode(value)
		case .double(let value):
			var container = encoder.singleValueContainer()
			try container.encode(value)
		case .bool(let value):
			var container = encoder.singleValueContainer()
			try container.encode(value)
		case .array(let value):
			var container = encoder.unkeyedContainer()
			for item in value {
				try container.encode(item)
			}
		case .object(let value):
			var container = encoder.container(keyedBy: DynamicCodingKey.self)
			for (key, item) in value {
				try container.encode(item, forKey: DynamicCodingKey(key))
			}
		case .null:
			var container = encoder.singleValueContainer()
			try container.encodeNil()
		}
	}
}

public enum ATProtocolDecoder {
	public static func decodeTypeIdentifier(from decoder: Decoder) throws -> String? {
		let container = try decoder.container(keyedBy: DynamicCodingKey.self)
		return try container.decodeIfPresent(String.self, forKey: DynamicCodingKey("$type"))
	}
}

public enum ATProtocolEncoder {
	public static func encodeTagged<T: Encodable>(
		_ value: T,
		typeIdentifier: String,
		to encoder: Encoder
	) throws {
		let encoded = try JSONEncoder().encode(value)
		let jsonObject = try JSONSerialization.jsonObject(with: encoded)
		guard var object = jsonObject as? [String: Any] else {
			var container = encoder.singleValueContainer()
			try container.encode(value)
			return
		}

		object["$type"] = typeIdentifier
		let taggedData = try JSONSerialization.data(withJSONObject: object)
		let taggedValue = try JSONDecoder().decode(ATProtocolValueContainer.self, from: taggedData)
		try taggedValue.encode(to: encoder)
	}
}

public struct DynamicCodingKey: CodingKey, Hashable {
	public let stringValue: String
	public let intValue: Int?

	public init(_ stringValue: String) {
		self.stringValue = stringValue
		self.intValue = nil
	}

	public init?(stringValue: String) {
		self.init(stringValue)
	}

	public init?(intValue: Int) {
		self.stringValue = String(intValue)
		self.intValue = intValue
	}
}

public struct ATProtocolDate: RawRepresentable, Codable, Hashable, Sendable, QueryParameterValue {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: rawValue))
	}
}

public struct CID: RawRepresentable, Codable, Hashable, Sendable, QueryParameterValue {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: rawValue))
	}
}

public struct DID: RawRepresentable, Codable, Hashable, Sendable, QueryParameterValue {
	public let rawValue: String
	public init(rawValue: String) { self.rawValue = rawValue }
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: rawValue))
	}
}

public struct Handle: RawRepresentable, Codable, Hashable, Sendable, QueryParameterValue {
	public let rawValue: String
	public init(rawValue: String) { self.rawValue = rawValue }
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: rawValue))
	}
}

public struct TID: RawRepresentable, Codable, Hashable, Sendable, QueryParameterValue {
	public let rawValue: String
	public init(rawValue: String) { self.rawValue = rawValue }
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: rawValue))
	}
}

public struct ATIdentifier: RawRepresentable, Codable, Hashable, Sendable, QueryParameterValue {
	public let rawValue: String
	public init(rawValue: String) { self.rawValue = rawValue }
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: rawValue))
	}
}

public struct ATURI: RawRepresentable, Codable, Hashable, Sendable, QueryParameterValue {
	public let rawValue: String
	public init(rawValue: String) { self.rawValue = rawValue }
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: rawValue))
	}
}

public struct NSID: RawRepresentable, Codable, Hashable, Sendable, QueryParameterValue {
	public let rawValue: String
	public init(rawValue: String) { self.rawValue = rawValue }
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: rawValue))
	}
}

public struct RecordKey: RawRepresentable, Codable, Hashable, Sendable, QueryParameterValue {
	public let rawValue: String
	public init(rawValue: String) { self.rawValue = rawValue }
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: rawValue))
	}
}

public struct Bytes: Codable, Hashable, Sendable {
	public let data: Data

	public init(data: Data) {
		self.data = data
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let encoded = try? container.decode(String.self) {
			self.data = Data(base64Encoded: encoded) ?? Data(encoded.utf8)
			return
		}

		self.data = try container.decode(Data.self)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(data.base64EncodedString())
	}
}

public struct Blob: Codable, Hashable, Sendable {
	public let ref: CID?
	public let mimeType: String?
	public let size: Int?

	public init(ref: CID? = nil, mimeType: String? = nil, size: Int? = nil) {
		self.ref = ref
		self.mimeType = mimeType
		self.size = size
	}

	private enum CodingKeys: String, CodingKey {
		case typeIdentifier = "$type"
		case ref
		case mimeType
		case size
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		_ = try container.decodeIfPresent(String.self, forKey: .typeIdentifier)
		ref = try container.decodeIfPresent(CID.self, forKey: .ref)
		mimeType = try container.decodeIfPresent(String.self, forKey: .mimeType)
		size = try container.decodeIfPresent(Int.self, forKey: .size)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode("blob", forKey: .typeIdentifier)
		try container.encodeIfPresent(ref, forKey: .ref)
		try container.encodeIfPresent(mimeType, forKey: .mimeType)
		try container.encodeIfPresent(size, forKey: .size)
	}
}

extension String: QueryParameterValue {
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: self))
	}
}

extension Int: QueryParameterValue {
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: String(self)))
	}
}

extension Bool: QueryParameterValue {
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: self ? "true" : "false"))
	}
}

extension Double: QueryParameterValue {
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		items.append(URLQueryItem(name: name, value: String(self)))
	}
}

extension QueryParameterValue where Self: RawRepresentable, RawValue == String {
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		rawValue.appendQueryItems(named: name, to: &items)
	}
}

extension Array: QueryParameterValue where Element: QueryParameterValue {
	public func appendQueryItems(named name: String, to items: inout [URLQueryItem]) {
		for element in self {
			element.appendQueryItems(named: name, to: &items)
		}
	}
}

public final class ATProtoClient {
	private let transport: LexiconTransport?
	private let encoder: JSONEncoder
	private let decoder: JSONDecoder

	public init(
		transport: LexiconTransport? = nil,
		encoder: JSONEncoder = JSONEncoder(),
		decoder: JSONDecoder = JSONDecoder()
	) {
		self.transport = transport
		self.encoder = encoder
		self.decoder = decoder
	}

	private func execute(
		method: String,
		path: String,
		body: Data? = nil,
		queryItems: [URLQueryItem] = [],
		headers: [String: String] = [:],
		responseKind: XRPCResponseKind = .json
	) async throws -> XRPCResponse {
		guard let transport else {
			throw LexiconRuntimeError.unsupported
		}

		return try await transport.execute(
			XRPCRequest(
				method: method,
				path: path,
				queryItems: queryItems,
				body: body,
				headers: headers,
				responseKind: responseKind
			)
		)
	}

	public func requestJSON<T: Decodable>(
		method: String,
		path: String,
		body: Data? = nil,
		queryItems: [URLQueryItem] = [],
		headers: [String: String] = [:],
		responseType: T.Type
	) async throws -> T {
		let response = try await execute(
			method: method,
			path: path,
			body: body,
			queryItems: queryItems,
			headers: headers
			,
			responseKind: .json
		)
		if response.body.isEmpty, responseType == EmptyResponse.self {
			return EmptyResponse() as! T
		}
		return try decoder.decode(responseType, from: response.body)
	}

	public func requestData(
		method: String,
		path: String,
		body: Data? = nil,
		queryItems: [URLQueryItem] = [],
		headers: [String: String] = [:],
		responseKind: XRPCResponseKind = .binary
	) async throws -> Data {
		let response = try await execute(
			method: method,
			path: path,
			body: body,
			queryItems: queryItems,
			headers: headers,
			responseKind: responseKind
		)
		return response.body
	}

	public func subscribe<T: Decodable>(
		path: String,
		queryItems: [URLQueryItem] = [],
		responseType: T.Type
	) -> AsyncThrowingStream<XRPCSubscriptionEvent<T>, Error> where T: Sendable {
		guard let transport else {
			return AsyncThrowingStream { continuation in
				continuation.finish(throwing: LexiconRuntimeError.unsupported)
			}
		}

		let baseStream = transport.subscribe(
			XRPCRequest(
				method: "GET",
				path: path,
				queryItems: queryItems,
				responseKind: .subscription
			)
		)
		let decoder = self.decoder
		return AsyncThrowingStream { continuation in
			Task {
				do {
					for try await frame in baseStream {
						switch frame {
						case .message(let payload):
							continuation.yield(
								.message(try decoder.decode(T.self, from: payload))
							)
						case .error(let payload):
							continuation.yield(.error(payload))
						}
					}
					continuation.finish()
				} catch {
					continuation.finish(throwing: error)
				}
			}
		}
	}

	public func encodedBody<T: Encodable>(_ value: T) throws -> Data {
		try encoder.encode(value)
	}
}
