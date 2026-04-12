import Foundation


public struct AppBskyVideoDefsJobStatus: Codable, Sendable, Equatable {
	public let blob: Blob?
	public let did: DID
	public let error: String?
	public let jobId: String
	public let message: String?
	public let progress: Int?
	public let state: AppBskyVideoDefsJobStatusState

	public init(
		blob: Blob? = nil,
		did: DID,
		error: String? = nil,
		jobId: String,
		message: String? = nil,
		progress: Int? = nil,
		state: AppBskyVideoDefsJobStatusState
	) {
		self.blob = blob
		self.did = did
		self.error = error
		self.jobId = jobId
		self.message = message
		self.progress = progress
		self.state = state
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		blob = try container.decodeIfPresent(Blob.self, forKey: .blob)
		did = try container.decode(DID.self, forKey: .did)
		error = try container.decodeIfPresent(String.self, forKey: .error)
		jobId = try container.decode(String.self, forKey: .jobId)
		message = try container.decodeIfPresent(String.self, forKey: .message)
		progress = try container.decodeIfPresent(Int.self, forKey: .progress)
		state = try container.decode(AppBskyVideoDefsJobStatusState.self, forKey: .state)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(blob, forKey: .blob)
		try container.encode(did, forKey: .did)
		try container.encodeIfPresent(error, forKey: .error)
		try container.encode(jobId, forKey: .jobId)
		try container.encodeIfPresent(message, forKey: .message)
		try container.encodeIfPresent(progress, forKey: .progress)
		try container.encode(state, forKey: .state)
	}

	private enum CodingKeys: String, CodingKey {
		case blob = "blob"
		case did = "did"
		case error = "error"
		case jobId = "jobId"
		case message = "message"
		case progress = "progress"
		case state = "state"
	}
}


public enum AppBskyVideoDefsJobStatusState: String, Codable, CaseIterable, QueryParameterValue, Sendable {
	case jobStateCompleted = "JOB_STATE_COMPLETED"
	case jobStateFailed = "JOB_STATE_FAILED"
}


public struct AppBskyVideoGetJobStatusOutput: Codable, Sendable, Equatable {
	public let jobStatus: AppBskyVideoDefsJobStatus

	public init(
		jobStatus: AppBskyVideoDefsJobStatus
	) {
		self.jobStatus = jobStatus
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		jobStatus = try container.decode(AppBskyVideoDefsJobStatus.self, forKey: .jobStatus)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(jobStatus, forKey: .jobStatus)
	}

	private enum CodingKeys: String, CodingKey {
		case jobStatus = "jobStatus"
	}
}


public struct AppBskyVideoGetJobStatusParameters: Codable, Sendable, Equatable {
	public let jobId: String

	public init(
		jobId: String
	) {
		self.jobId = jobId
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		jobId = try container.decode(String.self, forKey: .jobId)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(jobId, forKey: .jobId)
	}

	public func asQueryItems() -> [URLQueryItem] {
		var items: [URLQueryItem] = []
		jobId.appendQueryItems(named: "jobId", to: &items)
		return items
	}

	private enum CodingKeys: String, CodingKey {
		case jobId = "jobId"
	}
}


public struct AppBskyVideoGetUploadLimitsOutput: Codable, Sendable, Equatable {
	public let canUpload: Bool
	public let error: String?
	public let message: String?
	public let remainingDailyBytes: Int?
	public let remainingDailyVideos: Int?

	public init(
		canUpload: Bool,
		error: String? = nil,
		message: String? = nil,
		remainingDailyBytes: Int? = nil,
		remainingDailyVideos: Int? = nil
	) {
		self.canUpload = canUpload
		self.error = error
		self.message = message
		self.remainingDailyBytes = remainingDailyBytes
		self.remainingDailyVideos = remainingDailyVideos
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		canUpload = try container.decode(Bool.self, forKey: .canUpload)
		error = try container.decodeIfPresent(String.self, forKey: .error)
		message = try container.decodeIfPresent(String.self, forKey: .message)
		remainingDailyBytes = try container.decodeIfPresent(Int.self, forKey: .remainingDailyBytes)
		remainingDailyVideos = try container.decodeIfPresent(Int.self, forKey: .remainingDailyVideos)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(canUpload, forKey: .canUpload)
		try container.encodeIfPresent(error, forKey: .error)
		try container.encodeIfPresent(message, forKey: .message)
		try container.encodeIfPresent(remainingDailyBytes, forKey: .remainingDailyBytes)
		try container.encodeIfPresent(remainingDailyVideos, forKey: .remainingDailyVideos)
	}

	private enum CodingKeys: String, CodingKey {
		case canUpload = "canUpload"
		case error = "error"
		case message = "message"
		case remainingDailyBytes = "remainingDailyBytes"
		case remainingDailyVideos = "remainingDailyVideos"
	}
}


public struct AppBskyVideoUploadVideoInput: Sendable, Equatable {
	public let data: Data
	public let contentType: String

	public init(data: Data, contentType: String = "video/mp4") {
		self.data = data
		self.contentType = contentType
	}
}


public struct AppBskyVideoUploadVideoOutput: Codable, Sendable, Equatable {
	public let jobStatus: AppBskyVideoDefsJobStatus

	public init(
		jobStatus: AppBskyVideoDefsJobStatus
	) {
		self.jobStatus = jobStatus
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		jobStatus = try container.decode(AppBskyVideoDefsJobStatus.self, forKey: .jobStatus)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(jobStatus, forKey: .jobStatus)
	}

	private enum CodingKeys: String, CodingKey {
		case jobStatus = "jobStatus"
	}
}


