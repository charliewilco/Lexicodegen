package main

import (
	"context"
	"os"
	"path/filepath"
	"testing"

	"github.com/charliewilco/lexicon-openapi-generator/internal/config"
)

func TestRunGeneratesSwiftOutput(t *testing.T) {
	originalWD, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() {
		_ = os.Chdir(originalWD)
	})

	workspace := t.TempDir()
	if err := os.Chdir(workspace); err != nil {
		t.Fatal(err)
	}

	lexiconDir := filepath.Join(workspace, "lexicons")
	if err := os.MkdirAll(lexiconDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(lexiconDir, "sample.json"), []byte(`{
		"lexicon": 1,
		"id": "app.bsky.feed.example",
		"defs": {
			"main": {
				"type": "query",
				"parameters": {
					"type": "params",
					"properties": {
						"actor": { "type": "string", "format": "at-identifier" }
					}
				},
				"output": {
					"encoding": "application/json",
					"schema": {
						"type": "object",
						"properties": {
							"cursor": { "type": "string" }
						}
					}
				}
			}
		}
	}`), 0o644); err != nil {
		t.Fatal(err)
	}

	outputDir := filepath.Join(workspace, "output", "swift")
	if err := run(context.Background(), []string{"./lexicons", "--output", outputDir}); err != nil {
		t.Fatal(err)
	}

	for _, file := range []string{"Models.swift", "Endpoints.swift", "AppBskyFeed.generated.swift"} {
		if _, err := os.Stat(filepath.Join(outputDir, file)); err != nil {
			t.Fatalf("expected generated file %s: %v", file, err)
		}
	}
}

func TestRunRejectsUnknownFlag(t *testing.T) {
	if err := run(context.Background(), []string{"--wat"}); err == nil || err.Error() != "unknown flag: --wat" {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestJoinTargets(t *testing.T) {
	if got, want := joinTargets(nil), ""; got != want {
		t.Fatalf("unexpected empty join result: %q", got)
	}
	if got, want := joinTargets([]config.Target{"swift", "other"}), "swift, other"; got != want {
		t.Fatalf("unexpected joined targets: %q", got)
	}
}
