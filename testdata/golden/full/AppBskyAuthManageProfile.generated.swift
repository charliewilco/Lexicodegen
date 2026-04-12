import Foundation


public struct AppBskyAuthManageProfile: Codable, Sendable, Equatable {
	public static let title: String? = "Manage Bluesky Profile"
	public static let detail: String? = "Update profile data, as well as status and public chat visibility."
	public static let knownMethods: [AppBskyAuthManageProfileMethod] = []

	public let grantedMethods: [AppBskyAuthManageProfileMethod]

	public init(grantedMethods: [AppBskyAuthManageProfileMethod] = []) {
		self.grantedMethods = grantedMethods
	}

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		var grantedMethods: [AppBskyAuthManageProfileMethod] = []
		while !container.isAtEnd {
			grantedMethods.append(AppBskyAuthManageProfileMethod(rawValue: try container.decode(String.self)))
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


public struct AppBskyAuthManageProfileMethod: RawRepresentable, Codable, Hashable, Sendable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}


