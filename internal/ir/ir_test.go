package ir

import (
	"testing"

	"github.com/charliewilco/lexicon-openapi-generator/internal/config"
	"github.com/charliewilco/lexicon-openapi-generator/internal/schema"
)

func TestBuildLexiconIRAppliesFilters(t *testing.T) {
	t.Parallel()

	docs := []schema.Document{
		{
			Lexicon: 1,
			ID:      "app.bsky.feed.getFeed",
			Defs: map[string]schema.Schema{
				"main": {
					Type: "query",
					Output: &schema.OutputSchema{
						Encoding: "application/json",
						Schema: &schema.Schema{
							Type: "object",
							Properties: map[string]schema.Schema{
								"cursor": {Type: "string"},
							},
						},
					},
				},
				"recordType": {
					Type: "record",
					Record: &schema.Schema{
						Type: "object",
						Properties: map[string]schema.Schema{
							"cursor": {Type: "string"},
						},
					},
				},
				"deprecatedThing": {
					Type:        "object",
					Description: "Deprecated: old shape",
					Properties: map[string]schema.Schema{
						"old": {Type: "string"},
					},
				},
			},
		},
		{
			Lexicon: 1,
			ID:      "app.bsky.feed.subscribeFeed",
			Defs: map[string]schema.Schema{
				"main": {
					Type: "subscription",
					Message: &schema.MessageSchema{
						Schema: &schema.Schema{
							Type: "union",
							Refs: []string{"app.bsky.feed.getFeed.recordType"},
						},
					},
				},
			},
		},
		{
			Lexicon: 1,
			ID:      "app.bsky.unspecced.widget",
			Defs: map[string]schema.Schema{
				"main": {
					Type: "record",
					Record: &schema.Schema{
						Type: "object",
						Properties: map[string]schema.Schema{
							"value": {Type: "integer"},
						},
					},
				},
			},
		},
		{
			Lexicon: 1,
			ID:      "com.other.test",
			Defs: map[string]schema.Schema{
				"main": {
					Type: "record",
					Record: &schema.Schema{
						Type: "object",
						Properties: map[string]schema.Schema{
							"name": {Type: "string"},
						},
					},
				},
			},
		},
	}

	result := BuildLexiconIR(docs, config.GenerationFilter{
		AllowPrefixes:  []string{"app.bsky"},
		DenyPrefixes:   []string{"com.other"},
		DenyUnspecced:  true,
		DenyDeprecated: true,
	})

	assertDocumentIDs(t, result.Documents, []string{"app.bsky.feed.getFeed", "app.bsky.feed.subscribeFeed"})
	assertEndpointNames(t, result.Endpoints, []string{"app.bsky.feed.getFeed", "app.bsky.feed.subscribeFeed"})
	assertNamedTypeNames(t, result.NamedTypes, []string{"app.bsky.feed.getFeed.recordType"})
	if _, ok := result.DefinitionIndex["app.bsky.feed.getFeed.recordType"]; !ok {
		t.Fatalf("expected record type in definition index")
	}
	if _, ok := result.DefinitionIndex["app.bsky.unspecced.widget"]; ok {
		t.Fatalf("unexpected unspecced type in definition index")
	}
	if _, ok := result.DefinitionIndex["app.bsky.feed.getFeed.deprecatedThing"]; ok {
		t.Fatalf("unexpected deprecated type in definition index")
	}
}

func TestBuildLexiconIRDeterministicOrdering(t *testing.T) {
	t.Parallel()

	docs := []schema.Document{
		{
			Lexicon: 1,
			ID:      "com.zed.alpha",
			Defs: map[string]schema.Schema{
				"zz": {Type: "object", Properties: map[string]schema.Schema{"name": {Type: "string"}}},
				"aa": {Type: "object", Properties: map[string]schema.Schema{"value": {Type: "string"}}},
			},
		},
		{
			Lexicon: 1,
			ID:      "app.bsky.alpha",
			Defs: map[string]schema.Schema{
				"bb": {Type: "object", Properties: map[string]schema.Schema{"value": {Type: "string"}}},
				"main": {
					Type: "procedure",
					Input: &schema.InputSchema{
						Encoding: "application/json",
					},
					Output: &schema.OutputSchema{
						Encoding: "application/json",
					},
				},
			},
		},
	}

	result := BuildLexiconIR(docs, config.GenerationFilter{})
	assertDocumentIDs(t, result.Documents, []string{"app.bsky.alpha", "com.zed.alpha"})
	assertNamedTypeNames(t, result.NamedTypes, []string{"app.bsky.alpha.bb", "com.zed.alpha.aa", "com.zed.alpha.zz"})
	assertEndpointNames(t, result.Endpoints, []string{"app.bsky.alpha"})
}

func TestNormalizeRef(t *testing.T) {
	t.Parallel()

	if got, want := schema.NormalizeRef("#main", "app.bsky.feed.getPost"), "app.bsky.feed.getPost.main"; got != want {
		t.Fatalf("normalize ref mismatch: %s != %s", got, want)
	}
	if got, want := schema.NormalizeRef("app.other#reply", "app.bsky.feed.getPost"), "app.other.reply"; got != want {
		t.Fatalf("normalize ref mismatch: %s != %s", got, want)
	}
	if got, want := schema.NormalizeRef("app.other.type", "app.bsky.feed.getPost"), "app.other.type"; got != want {
		t.Fatalf("normalize ref mismatch: %s != %s", got, want)
	}
}

func assertDocumentIDs(t *testing.T, docs []Document, expected []string) {
	t.Helper()
	if len(docs) != len(expected) {
		t.Fatalf("documents length mismatch: %#v", docs)
	}
	for index, doc := range docs {
		if doc.ID != expected[index] {
			t.Fatalf("unexpected document id at %d: %s != %s", index, doc.ID, expected[index])
		}
	}
}

func assertEndpointNames(t *testing.T, endpoints []Endpoint, expected []string) {
	t.Helper()
	if len(endpoints) != len(expected) {
		t.Fatalf("endpoints length mismatch: %#v", endpoints)
	}
	for index, endpoint := range endpoints {
		if endpoint.FullName != expected[index] {
			t.Fatalf("unexpected endpoint at %d: %s != %s", index, endpoint.FullName, expected[index])
		}
	}
}

func assertNamedTypeNames(t *testing.T, namedTypes []NamedType, expected []string) {
	t.Helper()
	if len(namedTypes) != len(expected) {
		t.Fatalf("named types length mismatch: %#v", namedTypes)
	}
	for index, namedType := range namedTypes {
		if namedType.FullName != expected[index] {
			t.Fatalf("unexpected named type at %d: %s != %s", index, namedType.FullName, expected[index])
		}
	}
}
