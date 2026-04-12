import Foundation


public struct ComAtprotoRepoApplyWritesCreate: Codable, Sendable, Equatable {
	public let collection: NSID
	public let rkey: RecordKey?
	public let value: ATProtocolValueContainer

	public init(
		collection: NSID,
		rkey: RecordKey? = nil,
		value: ATProtocolValueContainer
	) {
		self.collection = collection
		self.rkey = rkey
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		collection = try container.decode(NSID.self, forKey: .collection)
		rkey = try container.decodeIfPresent(RecordKey.self, forKey: .rkey)
		value = try container.decode(ATProtocolValueContainer.self, forKey: .value)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(collection, forKey: .collection)
		try container.encodeIfPresent(rkey, forKey: .rkey)
		try container.encode(value, forKey: .value)
	}

	private enum CodingKeys: String, CodingKey {
		case collection = "collection"
		case rkey = "rkey"
		case value = "value"
	}
}


public struct ComAtprotoRepoApplyWritesCreateResult: Codable, Sendable, Equatable {
	public let cid: CID
	public let uri: ATURI
	public let validationStatus: ComAtprotoRepoApplyWritesCreateResultValidationStatus?

	public init(
		cid: CID,
		uri: ATURI,
		validationStatus: ComAtprotoRepoApplyWritesCreateResultValidationStatus? = nil
	) {
		self.cid = cid
		self.uri = uri
		self.validationStatus = validationStatus
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		uri = try container.decode(ATURI.self, forKey: .uri)
		validationStatus = try container.decodeIfPresent(ComAtprotoRepoApplyWritesCreateResultValidationStatus.self, forKey: .validationStatus)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encode(uri, forKey: .uri)
		try container.encodeIfPresent(validationStatus, forKey: .validationStatus)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case uri = "uri"
		case validationStatus = "validationStatus"
	}
}


public enum ComAtprotoRepoApplyWritesCreateResultValidationStatus: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case valid = "valid"
	case unknown = "unknown"
}


public struct ComAtprotoRepoApplyWritesDelete: Codable, Sendable, Equatable {
	public let collection: NSID
	public let rkey: RecordKey

	public init(
		collection: NSID,
		rkey: RecordKey
	) {
		self.collection = collection
		self.rkey = rkey
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		collection = try container.decode(NSID.self, forKey: .collection)
		rkey = try container.decode(RecordKey.self, forKey: .rkey)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(collection, forKey: .collection)
		try container.encode(rkey, forKey: .rkey)
	}

	private enum CodingKeys: String, CodingKey {
		case collection = "collection"
		case rkey = "rkey"
	}
}


public struct ComAtprotoRepoApplyWritesDeleteResult: Codable, Sendable, Equatable {

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


public enum ComAtprotoRepoApplyWritesError: String, Swift.Error, CaseIterable, Sendable {
	case invalidSwap = "InvalidSwap"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ComAtprotoRepoApplyWritesInput: Codable, Sendable, Equatable {
	public let repo: ATIdentifier
	public let swapCommit: CID?
	public let validate: Bool?
	public let writes: [ComAtprotoRepoApplyWritesInputWritesItem]

	public init(
		repo: ATIdentifier,
		swapCommit: CID? = nil,
		validate: Bool? = nil,
		writes: [ComAtprotoRepoApplyWritesInputWritesItem]
	) {
		self.repo = repo
		self.swapCommit = swapCommit
		self.validate = validate
		self.writes = writes
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		repo = try container.decode(ATIdentifier.self, forKey: .repo)
		swapCommit = try container.decodeIfPresent(CID.self, forKey: .swapCommit)
		validate = try container.decodeIfPresent(Bool.self, forKey: .validate)
		writes = try container.decode([ComAtprotoRepoApplyWritesInputWritesItem].self, forKey: .writes)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(repo, forKey: .repo)
		try container.encodeIfPresent(swapCommit, forKey: .swapCommit)
		try container.encodeIfPresent(validate, forKey: .validate)
		try container.encode(writes, forKey: .writes)
	}

	private enum CodingKeys: String, CodingKey {
		case repo = "repo"
		case swapCommit = "swapCommit"
		case validate = "validate"
		case writes = "writes"
	}
}


public indirect enum ComAtprotoRepoApplyWritesInputWritesItem: Codable, Sendable, Equatable {
	case create(ComAtprotoRepoApplyWritesCreate)
	case update(ComAtprotoRepoApplyWritesUpdate)
	case delete(ComAtprotoRepoApplyWritesDelete)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "com.atproto.repo.applyWrites#create": self = .create(try ComAtprotoRepoApplyWritesCreate(from: decoder))
		case "com.atproto.repo.applyWrites#update": self = .update(try ComAtprotoRepoApplyWritesUpdate(from: decoder))
		case "com.atproto.repo.applyWrites#delete": self = .delete(try ComAtprotoRepoApplyWritesDelete(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .create(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "com.atproto.repo.applyWrites#create", to: encoder)
		case .update(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "com.atproto.repo.applyWrites#update", to: encoder)
		case .delete(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "com.atproto.repo.applyWrites#delete", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct ComAtprotoRepoApplyWritesOutput: Codable, Sendable, Equatable {
	public let commit: ComAtprotoRepoDefsCommitMeta?
	public let results: [ComAtprotoRepoApplyWritesOutputResultsItem]?

	public init(
		commit: ComAtprotoRepoDefsCommitMeta? = nil,
		results: [ComAtprotoRepoApplyWritesOutputResultsItem]? = nil
	) {
		self.commit = commit
		self.results = results
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		commit = try container.decodeIfPresent(ComAtprotoRepoDefsCommitMeta.self, forKey: .commit)
		results = try container.decodeIfPresent([ComAtprotoRepoApplyWritesOutputResultsItem].self, forKey: .results)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(commit, forKey: .commit)
		try container.encodeIfPresent(results, forKey: .results)
	}

	private enum CodingKeys: String, CodingKey {
		case commit = "commit"
		case results = "results"
	}
}


public indirect enum ComAtprotoRepoApplyWritesOutputResultsItem: Codable, Sendable, Equatable {
	case createResult(ComAtprotoRepoApplyWritesCreateResult)
	case updateResult(ComAtprotoRepoApplyWritesUpdateResult)
	case deleteResult(ComAtprotoRepoApplyWritesDeleteResult)
	case unexpected(ATProtocolValueContainer)

	public init(from decoder: Decoder) throws {
		let typeIdentifier = try ATProtocolDecoder.decodeTypeIdentifier(from: decoder)
		switch typeIdentifier {
		case "com.atproto.repo.applyWrites#createResult": self = .createResult(try ComAtprotoRepoApplyWritesCreateResult(from: decoder))
		case "com.atproto.repo.applyWrites#updateResult": self = .updateResult(try ComAtprotoRepoApplyWritesUpdateResult(from: decoder))
		case "com.atproto.repo.applyWrites#deleteResult": self = .deleteResult(try ComAtprotoRepoApplyWritesDeleteResult(from: decoder))
		default: self = .unexpected(try ATProtocolValueContainer(from: decoder))
		}
	}

	public func encode(to encoder: Encoder) throws {
		switch self {
		case .createResult(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "com.atproto.repo.applyWrites#createResult", to: encoder)
		case .updateResult(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "com.atproto.repo.applyWrites#updateResult", to: encoder)
		case .deleteResult(let value): try ATProtocolEncoder.encodeTagged(value, typeIdentifier: "com.atproto.repo.applyWrites#deleteResult", to: encoder)
		case .unexpected(let value): try value.encode(to: encoder)
		}
	}
}


public struct ComAtprotoRepoApplyWritesUpdate: Codable, Sendable, Equatable {
	public let collection: NSID
	public let rkey: RecordKey
	public let value: ATProtocolValueContainer

	public init(
		collection: NSID,
		rkey: RecordKey,
		value: ATProtocolValueContainer
	) {
		self.collection = collection
		self.rkey = rkey
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		collection = try container.decode(NSID.self, forKey: .collection)
		rkey = try container.decode(RecordKey.self, forKey: .rkey)
		value = try container.decode(ATProtocolValueContainer.self, forKey: .value)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(collection, forKey: .collection)
		try container.encode(rkey, forKey: .rkey)
		try container.encode(value, forKey: .value)
	}

	private enum CodingKeys: String, CodingKey {
		case collection = "collection"
		case rkey = "rkey"
		case value = "value"
	}
}


public struct ComAtprotoRepoApplyWritesUpdateResult: Codable, Sendable, Equatable {
	public let cid: CID
	public let uri: ATURI
	public let validationStatus: ComAtprotoRepoApplyWritesCreateResultValidationStatus?

	public init(
		cid: CID,
		uri: ATURI,
		validationStatus: ComAtprotoRepoApplyWritesCreateResultValidationStatus? = nil
	) {
		self.cid = cid
		self.uri = uri
		self.validationStatus = validationStatus
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		uri = try container.decode(ATURI.self, forKey: .uri)
		validationStatus = try container.decodeIfPresent(ComAtprotoRepoApplyWritesCreateResultValidationStatus.self, forKey: .validationStatus)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encode(uri, forKey: .uri)
		try container.encodeIfPresent(validationStatus, forKey: .validationStatus)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case uri = "uri"
		case validationStatus = "validationStatus"
	}
}


public enum ComAtprotoRepoCreateRecordError: String, Swift.Error, CaseIterable, Sendable {
	case invalidSwap = "InvalidSwap"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ComAtprotoRepoCreateRecordInput: Codable, Sendable, Equatable {
	public let collection: NSID
	public let record: ATProtocolValueContainer
	public let repo: ATIdentifier
	public let rkey: RecordKey?
	public let swapCommit: CID?
	public let validate: Bool?

	public init(
		collection: NSID,
		record: ATProtocolValueContainer,
		repo: ATIdentifier,
		rkey: RecordKey? = nil,
		swapCommit: CID? = nil,
		validate: Bool? = nil
	) {
		self.collection = collection
		self.record = record
		self.repo = repo
		self.rkey = rkey
		self.swapCommit = swapCommit
		self.validate = validate
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		collection = try container.decode(NSID.self, forKey: .collection)
		record = try container.decode(ATProtocolValueContainer.self, forKey: .record)
		repo = try container.decode(ATIdentifier.self, forKey: .repo)
		rkey = try container.decodeIfPresent(RecordKey.self, forKey: .rkey)
		swapCommit = try container.decodeIfPresent(CID.self, forKey: .swapCommit)
		validate = try container.decodeIfPresent(Bool.self, forKey: .validate)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(collection, forKey: .collection)
		try container.encode(record, forKey: .record)
		try container.encode(repo, forKey: .repo)
		try container.encodeIfPresent(rkey, forKey: .rkey)
		try container.encodeIfPresent(swapCommit, forKey: .swapCommit)
		try container.encodeIfPresent(validate, forKey: .validate)
	}

	private enum CodingKeys: String, CodingKey {
		case collection = "collection"
		case record = "record"
		case repo = "repo"
		case rkey = "rkey"
		case swapCommit = "swapCommit"
		case validate = "validate"
	}
}


public struct ComAtprotoRepoCreateRecordOutput: Codable, Sendable, Equatable {
	public let cid: CID
	public let commit: ComAtprotoRepoDefsCommitMeta?
	public let uri: ATURI
	public let validationStatus: ComAtprotoRepoApplyWritesCreateResultValidationStatus?

	public init(
		cid: CID,
		commit: ComAtprotoRepoDefsCommitMeta? = nil,
		uri: ATURI,
		validationStatus: ComAtprotoRepoApplyWritesCreateResultValidationStatus? = nil
	) {
		self.cid = cid
		self.commit = commit
		self.uri = uri
		self.validationStatus = validationStatus
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		commit = try container.decodeIfPresent(ComAtprotoRepoDefsCommitMeta.self, forKey: .commit)
		uri = try container.decode(ATURI.self, forKey: .uri)
		validationStatus = try container.decodeIfPresent(ComAtprotoRepoApplyWritesCreateResultValidationStatus.self, forKey: .validationStatus)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encodeIfPresent(commit, forKey: .commit)
		try container.encode(uri, forKey: .uri)
		try container.encodeIfPresent(validationStatus, forKey: .validationStatus)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case commit = "commit"
		case uri = "uri"
		case validationStatus = "validationStatus"
	}
}


public struct ComAtprotoRepoDefsCommitMeta: Codable, Sendable, Equatable {
	public let cid: CID
	public let rev: TID

	public init(
		cid: CID,
		rev: TID
	) {
		self.cid = cid
		self.rev = rev
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		rev = try container.decode(TID.self, forKey: .rev)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encode(rev, forKey: .rev)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case rev = "rev"
	}
}


public enum ComAtprotoRepoDeleteRecordError: String, Swift.Error, CaseIterable, Sendable {
	case invalidSwap = "InvalidSwap"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ComAtprotoRepoDeleteRecordInput: Codable, Sendable, Equatable {
	public let collection: NSID
	public let repo: ATIdentifier
	public let rkey: RecordKey
	public let swapCommit: CID?
	public let swapRecord: CID?

	public init(
		collection: NSID,
		repo: ATIdentifier,
		rkey: RecordKey,
		swapCommit: CID? = nil,
		swapRecord: CID? = nil
	) {
		self.collection = collection
		self.repo = repo
		self.rkey = rkey
		self.swapCommit = swapCommit
		self.swapRecord = swapRecord
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		collection = try container.decode(NSID.self, forKey: .collection)
		repo = try container.decode(ATIdentifier.self, forKey: .repo)
		rkey = try container.decode(RecordKey.self, forKey: .rkey)
		swapCommit = try container.decodeIfPresent(CID.self, forKey: .swapCommit)
		swapRecord = try container.decodeIfPresent(CID.self, forKey: .swapRecord)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(collection, forKey: .collection)
		try container.encode(repo, forKey: .repo)
		try container.encode(rkey, forKey: .rkey)
		try container.encodeIfPresent(swapCommit, forKey: .swapCommit)
		try container.encodeIfPresent(swapRecord, forKey: .swapRecord)
	}

	private enum CodingKeys: String, CodingKey {
		case collection = "collection"
		case repo = "repo"
		case rkey = "rkey"
		case swapCommit = "swapCommit"
		case swapRecord = "swapRecord"
	}
}


public struct ComAtprotoRepoDeleteRecordOutput: Codable, Sendable, Equatable {
	public let commit: ComAtprotoRepoDefsCommitMeta?

	public init(
		commit: ComAtprotoRepoDefsCommitMeta? = nil
	) {
		self.commit = commit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		commit = try container.decodeIfPresent(ComAtprotoRepoDefsCommitMeta.self, forKey: .commit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(commit, forKey: .commit)
	}

	private enum CodingKeys: String, CodingKey {
		case commit = "commit"
	}
}


public struct ComAtprotoRepoDescribeRepoOutput: Codable, Sendable, Equatable {
	public let collections: [NSID]
	public let did: DID
	public let didDoc: ATProtocolValueContainer
	public let handle: Handle
	public let handleIsCorrect: Bool

	public init(
		collections: [NSID],
		did: DID,
		didDoc: ATProtocolValueContainer,
		handle: Handle,
		handleIsCorrect: Bool
	) {
		self.collections = collections
		self.did = did
		self.didDoc = didDoc
		self.handle = handle
		self.handleIsCorrect = handleIsCorrect
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		collections = try container.decode([NSID].self, forKey: .collections)
		did = try container.decode(DID.self, forKey: .did)
		didDoc = try container.decode(ATProtocolValueContainer.self, forKey: .didDoc)
		handle = try container.decode(Handle.self, forKey: .handle)
		handleIsCorrect = try container.decode(Bool.self, forKey: .handleIsCorrect)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(collections, forKey: .collections)
		try container.encode(did, forKey: .did)
		try container.encode(didDoc, forKey: .didDoc)
		try container.encode(handle, forKey: .handle)
		try container.encode(handleIsCorrect, forKey: .handleIsCorrect)
	}

	private enum CodingKeys: String, CodingKey {
		case collections = "collections"
		case did = "did"
		case didDoc = "didDoc"
		case handle = "handle"
		case handleIsCorrect = "handleIsCorrect"
	}
}


public struct ComAtprotoRepoDescribeRepoParameters: Codable, Sendable, Equatable {
	public let repo: ATIdentifier

	public init(
		repo: ATIdentifier
	) {
		self.repo = repo
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		repo = try container.decode(ATIdentifier.self, forKey: .repo)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(repo, forKey: .repo)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		repo.appendQueryItems(named: "repo", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case repo = "repo"
	}
}


public enum ComAtprotoRepoGetRecordError: String, Swift.Error, CaseIterable, Sendable {
	case recordNotFound = "RecordNotFound"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ComAtprotoRepoGetRecordOutput: Codable, Sendable, Equatable {
	public let cid: CID?
	public let uri: ATURI
	public let value: ATProtocolValueContainer

	public init(
		cid: CID? = nil,
		uri: ATURI,
		value: ATProtocolValueContainer
	) {
		self.cid = cid
		self.uri = uri
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decodeIfPresent(CID.self, forKey: .cid)
		uri = try container.decode(ATURI.self, forKey: .uri)
		value = try container.decode(ATProtocolValueContainer.self, forKey: .value)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cid, forKey: .cid)
		try container.encode(uri, forKey: .uri)
		try container.encode(value, forKey: .value)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case uri = "uri"
		case value = "value"
	}
}


public struct ComAtprotoRepoGetRecordParameters: Codable, Sendable, Equatable {
	public let cid: CID?
	public let collection: NSID
	public let repo: ATIdentifier
	public let rkey: RecordKey

	public init(
		cid: CID? = nil,
		collection: NSID,
		repo: ATIdentifier,
		rkey: RecordKey
	) {
		self.cid = cid
		self.collection = collection
		self.repo = repo
		self.rkey = rkey
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decodeIfPresent(CID.self, forKey: .cid)
		collection = try container.decode(NSID.self, forKey: .collection)
		repo = try container.decode(ATIdentifier.self, forKey: .repo)
		rkey = try container.decode(RecordKey.self, forKey: .rkey)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cid, forKey: .cid)
		try container.encode(collection, forKey: .collection)
		try container.encode(repo, forKey: .repo)
		try container.encode(rkey, forKey: .rkey)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cid {
			value.appendQueryItems(named: "cid", to: &items)
		}
		collection.appendQueryItems(named: "collection", to: &items)
		repo.appendQueryItems(named: "repo", to: &items)
		rkey.appendQueryItems(named: "rkey", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case collection = "collection"
		case repo = "repo"
		case rkey = "rkey"
	}
}


public struct ComAtprotoRepoImportRepoInput: Sendable, Equatable {
	public let data: Data
	public let contentType: String

	public init(data: Data, contentType: String = "application/vnd.ipld.car") {
		self.data = data
		self.contentType = contentType
	}
}


public struct ComAtprotoRepoListMissingBlobsOutput: Codable, Sendable, Equatable {
	public let blobs: [ComAtprotoRepoListMissingBlobsRecordBlob]
	public let cursor: String?

	public init(
		blobs: [ComAtprotoRepoListMissingBlobsRecordBlob],
		cursor: String? = nil
	) {
		self.blobs = blobs
		self.cursor = cursor
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		blobs = try container.decode([ComAtprotoRepoListMissingBlobsRecordBlob].self, forKey: .blobs)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(blobs, forKey: .blobs)
		try container.encodeIfPresent(cursor, forKey: .cursor)
	}

	private enum CodingKeys: String, CodingKey {
		case blobs = "blobs"
		case cursor = "cursor"
	}
}


public struct ComAtprotoRepoListMissingBlobsParameters: Codable, Sendable, Equatable {
	public let cursor: String?
	public let limit: Int?

	public init(
		cursor: String? = nil,
		limit: Int? = nil
	) {
		self.cursor = cursor
		self.limit = limit
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case limit = "limit"
	}
}


public struct ComAtprotoRepoListMissingBlobsRecordBlob: Codable, Sendable, Equatable {
	public let cid: CID
	public let recordUri: ATURI

	public init(
		cid: CID,
		recordUri: ATURI
	) {
		self.cid = cid
		self.recordUri = recordUri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		recordUri = try container.decode(ATURI.self, forKey: .recordUri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encode(recordUri, forKey: .recordUri)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case recordUri = "recordUri"
	}
}


public struct ComAtprotoRepoListRecordsOutput: Codable, Sendable, Equatable {
	public let cursor: String?
	public let records: [ComAtprotoRepoListRecordsRecord]

	public init(
		cursor: String? = nil,
		records: [ComAtprotoRepoListRecordsRecord]
	) {
		self.cursor = cursor
		self.records = records
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		records = try container.decode([ComAtprotoRepoListRecordsRecord].self, forKey: .records)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encode(records, forKey: .records)
	}

	private enum CodingKeys: String, CodingKey {
		case cursor = "cursor"
		case records = "records"
	}
}


public struct ComAtprotoRepoListRecordsParameters: Codable, Sendable, Equatable {
	public let collection: NSID
	public let cursor: String?
	public let limit: Int?
	public let repo: ATIdentifier
	public let reverse: Bool?

	public init(
		collection: NSID,
		cursor: String? = nil,
		limit: Int? = nil,
		repo: ATIdentifier,
		reverse: Bool? = nil
	) {
		self.collection = collection
		self.cursor = cursor
		self.limit = limit
		self.repo = repo
		self.reverse = reverse
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		collection = try container.decode(NSID.self, forKey: .collection)
		cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
		limit = try container.decodeIfPresent(Int.self, forKey: .limit)
		repo = try container.decode(ATIdentifier.self, forKey: .repo)
		reverse = try container.decodeIfPresent(Bool.self, forKey: .reverse)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(collection, forKey: .collection)
		try container.encodeIfPresent(cursor, forKey: .cursor)
		try container.encodeIfPresent(limit, forKey: .limit)
		try container.encode(repo, forKey: .repo)
		try container.encodeIfPresent(reverse, forKey: .reverse)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		collection.appendQueryItems(named: "collection", to: &items)
		if let value = cursor {
			value.appendQueryItems(named: "cursor", to: &items)
		}
		if let value = limit {
			value.appendQueryItems(named: "limit", to: &items)
		}
		repo.appendQueryItems(named: "repo", to: &items)
		if let value = reverse {
			value.appendQueryItems(named: "reverse", to: &items)
		}
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case collection = "collection"
		case cursor = "cursor"
		case limit = "limit"
		case repo = "repo"
		case reverse = "reverse"
	}
}


public struct ComAtprotoRepoListRecordsRecord: Codable, Sendable, Equatable {
	public let cid: CID
	public let uri: ATURI
	public let value: ATProtocolValueContainer

	public init(
		cid: CID,
		uri: ATURI,
		value: ATProtocolValueContainer
	) {
		self.cid = cid
		self.uri = uri
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		uri = try container.decode(ATURI.self, forKey: .uri)
		value = try container.decode(ATProtocolValueContainer.self, forKey: .value)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encode(uri, forKey: .uri)
		try container.encode(value, forKey: .value)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case uri = "uri"
		case value = "value"
	}
}


public enum ComAtprotoRepoPutRecordError: String, Swift.Error, CaseIterable, Sendable {
	case invalidSwap = "InvalidSwap"

	public init?(transportError: XRPCTransportError) {
		guard let rawValue = transportError.payload?.error else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}


public struct ComAtprotoRepoPutRecordInput: Codable, Sendable, Equatable {
	public let collection: NSID
	public let record: ATProtocolValueContainer
	public let repo: ATIdentifier
	public let rkey: RecordKey
	public let swapCommit: CID?
	public let swapRecord: CID?
	public let validate: Bool?

	public init(
		collection: NSID,
		record: ATProtocolValueContainer,
		repo: ATIdentifier,
		rkey: RecordKey,
		swapCommit: CID? = nil,
		swapRecord: CID? = nil,
		validate: Bool? = nil
	) {
		self.collection = collection
		self.record = record
		self.repo = repo
		self.rkey = rkey
		self.swapCommit = swapCommit
		self.swapRecord = swapRecord
		self.validate = validate
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		collection = try container.decode(NSID.self, forKey: .collection)
		record = try container.decode(ATProtocolValueContainer.self, forKey: .record)
		repo = try container.decode(ATIdentifier.self, forKey: .repo)
		rkey = try container.decode(RecordKey.self, forKey: .rkey)
		swapCommit = try container.decodeIfPresent(CID.self, forKey: .swapCommit)
		swapRecord = try container.decodeIfPresent(CID.self, forKey: .swapRecord)
		validate = try container.decodeIfPresent(Bool.self, forKey: .validate)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(collection, forKey: .collection)
		try container.encode(record, forKey: .record)
		try container.encode(repo, forKey: .repo)
		try container.encode(rkey, forKey: .rkey)
		try container.encodeIfPresent(swapCommit, forKey: .swapCommit)
		try container.encodeIfPresent(swapRecord, forKey: .swapRecord)
		try container.encodeIfPresent(validate, forKey: .validate)
	}

	private enum CodingKeys: String, CodingKey {
		case collection = "collection"
		case record = "record"
		case repo = "repo"
		case rkey = "rkey"
		case swapCommit = "swapCommit"
		case swapRecord = "swapRecord"
		case validate = "validate"
	}
}


public struct ComAtprotoRepoPutRecordOutput: Codable, Sendable, Equatable {
	public let cid: CID
	public let commit: ComAtprotoRepoDefsCommitMeta?
	public let uri: ATURI
	public let validationStatus: ComAtprotoRepoApplyWritesCreateResultValidationStatus?

	public init(
		cid: CID,
		commit: ComAtprotoRepoDefsCommitMeta? = nil,
		uri: ATURI,
		validationStatus: ComAtprotoRepoApplyWritesCreateResultValidationStatus? = nil
	) {
		self.cid = cid
		self.commit = commit
		self.uri = uri
		self.validationStatus = validationStatus
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		commit = try container.decodeIfPresent(ComAtprotoRepoDefsCommitMeta.self, forKey: .commit)
		uri = try container.decode(ATURI.self, forKey: .uri)
		validationStatus = try container.decodeIfPresent(ComAtprotoRepoApplyWritesCreateResultValidationStatus.self, forKey: .validationStatus)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encodeIfPresent(commit, forKey: .commit)
		try container.encode(uri, forKey: .uri)
		try container.encodeIfPresent(validationStatus, forKey: .validationStatus)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case commit = "commit"
		case uri = "uri"
		case validationStatus = "validationStatus"
	}
}


public struct ComAtprotoRepoStrongRef: Codable, Sendable, Equatable {
	public let cid: CID
	public let uri: ATURI

	public init(
		cid: CID,
		uri: ATURI
	) {
		self.cid = cid
		self.uri = uri
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cid = try container.decode(CID.self, forKey: .cid)
		uri = try container.decode(ATURI.self, forKey: .uri)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(cid, forKey: .cid)
		try container.encode(uri, forKey: .uri)
	}

	private enum CodingKeys: String, CodingKey {
		case cid = "cid"
		case uri = "uri"
	}
}


public struct ComAtprotoRepoUploadBlobInput: Sendable, Equatable {
	public let data: Data
	public let contentType: String

	public init(data: Data, contentType: String = "*/*") {
		self.data = data
		self.contentType = contentType
	}
}


public struct ComAtprotoRepoUploadBlobOutput: Codable, Sendable, Equatable {
	public let blob: Blob

	public init(
		blob: Blob
	) {
		self.blob = blob
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		blob = try container.decode(Blob.self, forKey: .blob)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(blob, forKey: .blob)
	}

	private enum CodingKeys: String, CodingKey {
		case blob = "blob"
	}
}


