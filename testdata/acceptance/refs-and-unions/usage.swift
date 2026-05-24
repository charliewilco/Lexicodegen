import Foundation

func smokeRefsAndUnions() throws {
	let byteSlice = AppBskyRichtextFacetByteSlice(byteEnd: 5, byteStart: 0)
	let mention = AppBskyRichtextFacetMention(did: DID(rawValue: "did:plc:example"))
	let link = AppBskyRichtextFacetLink(uri: "https://example.com")
	let tag = AppBskyRichtextFacetTag(tag: "testing")
	let facet = AppBskyRichtextFacet(
		features: [
			.mention(mention),
			.link(link),
			.tag(tag)
		],
		index: byteSlice
	)

	_ = facet
	_ = AppBskyRichtextFacetFeaturesItem.unexpected(.object([:]))
	_ = try JSONEncoder().encode(facet)
}
