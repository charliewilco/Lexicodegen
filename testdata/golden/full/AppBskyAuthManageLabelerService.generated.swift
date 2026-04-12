import Foundation


public struct AppBskyAuthManageLabelerService: Codable, Sendable, Equatable {
	public static let title: String? = "Manage Hosted Labeling Service"
	public static let detail: String? = "Configure labeler declaration records."
	public static let knownMethods: [AppBskyAuthManageLabelerServiceMethod] = []

	public let grantedMethods: [AppBskyAuthManageLabelerServiceMethod]

	public init(grantedMethods: [AppBskyAuthManageLabelerServiceMethod] = []) {
		self.grantedMethods = grantedMethods
	}

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		var grantedMethods: [AppBskyAuthManageLabelerServiceMethod] = []
		while !container.isAtEnd {
			grantedMethods.append(AppBskyAuthManageLabelerServiceMethod(rawValue: try container.decode(String.self)))
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


public struct AppBskyAuthManageLabelerServiceMethod: RawRepresentable, Codable, Hashable, Sendable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}


