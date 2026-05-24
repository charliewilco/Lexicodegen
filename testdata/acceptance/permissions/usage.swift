import Foundation

func smokePermissions() throws {
	let read = AppBskyAuthManageProfileMethod.appBskyActorGetProfile
	let write = AppBskyAuthManageProfileMethod.appBskyActorPutPreferences
	let grant = AppBskyAuthManageProfile(grantedMethods: [read, write])

	_ = AppBskyAuthManageProfile.title
	_ = AppBskyAuthManageProfile.detail
	_ = AppBskyAuthManageProfile.knownMethods
	_ = try JSONEncoder().encode(grant)
}
