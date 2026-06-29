package schema

import (
	"strings"
	"testing"
)

func TestParseDocumentsSingleAndArray(t *testing.T) {
	t.Parallel()

	single := []byte(`{
		"lexicon": 1,
		"id": "app.bsky.feed.example",
		"defs": {
			"main": {
				"type": "object",
				"properties": {
					"subject": { "type": "string" }
				}
			}
		}
	}`)
	docs, err := ParseDocuments(single)
	if err != nil {
		t.Fatal(err)
	}
	if len(docs) != 1 {
		t.Fatalf("expected 1 doc, got %d", len(docs))
	}
	if docs[0].ID != "app.bsky.feed.example" {
		t.Fatalf("unexpected id: %s", docs[0].ID)
	}
	if docs[0].Defs["main"].Raw() == nil {
		t.Fatalf("expected raw schema payload to be captured")
	}

	enumSchema := docs[0].Defs["main"].Properties["subject"]
	if len(enumSchema.Enum) != 0 {
		t.Fatalf("unexpected enum values in plain string schema: %#v", enumSchema.Enum)
	}

	array := []byte(`[
		{
			"lexicon": 1,
			"id": "app.bsky.feed.one",
			"defs": { "main": { "type": "token" } }
		},
		{
			"lexicon": 1,
			"id": "app.bsky.feed.two",
			"defs": { "main": { "type": "token" } }
		}
	]`)
	docs, err = ParseDocuments(array)
	if err != nil {
		t.Fatal(err)
	}
	if len(docs) != 2 {
		t.Fatalf("expected 2 docs, got %d", len(docs))
	}
	if docs[0].ID != "app.bsky.feed.one" || docs[1].ID != "app.bsky.feed.two" {
		t.Fatalf("unexpected ids: %#v", docs)
	}
}

func TestParseDocumentsPreservesStringEnum(t *testing.T) {
	t.Parallel()

	payload := []byte(`{
		"lexicon": 1,
		"id": "tools.ozone.moderation.query",
		"defs": {
			"main": {
				"type": "query",
				"parameters": {
					"type": "params",
					"properties": {
						"sort": {
							"type": "string",
							"enum": ["createdAt", "updatedAt"]
						}
					}
				}
			}
		}
	}`)

	docs, err := ParseDocuments(payload)
	if err != nil {
		t.Fatal(err)
	}

	sortSchema := docs[0].Defs["main"].Parameters.Properties["sort"]
	if got, want := strings.Join(sortSchema.Enum, ","), "createdAt,updatedAt"; got != want {
		t.Fatalf("unexpected enum values: %s != %s", got, want)
	}
}

func TestParseDocumentsRejectsEmptyAndInvalid(t *testing.T) {
	t.Parallel()

	if _, err := ParseDocuments([]byte(" \n\t ")); err == nil || err.Error() != "empty lexicon payload" {
		t.Fatalf("expected empty payload error, got %v", err)
	}

	invalid := []byte(`{
		"lexicon": 2,
		"id": "app.bsky.feed.example",
		"defs": { "main": { "type": "token" } }
	}`)
	if _, err := ParseDocuments(invalid); err == nil {
		t.Fatalf("expected validation error for invalid lexicon version")
	}
}

func TestNormalizeRefAndSortedDefNames(t *testing.T) {
	t.Parallel()

	if got, want := NormalizeRef("#main", "app.bsky.feed.getPost"), "app.bsky.feed.getPost.main"; got != want {
		t.Fatalf("unexpected ref: %s", got)
	}
	if got, want := NormalizeRef("app.other#reply", "app.bsky.feed.getPost"), "app.other.reply"; got != want {
		t.Fatalf("unexpected ref: %s", got)
	}

	names := SortedDefNames(Document{
		Defs: map[string]Schema{
			"zz":   {},
			"aa":   {},
			"main": {},
		},
	})
	expected := []string{"aa", "main", "zz"}
	for index := range expected {
		if names[index] != expected[index] {
			t.Fatalf("sorted names mismatch: %#v", names)
		}
	}
}
