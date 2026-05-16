package main

import (
	"bytes"
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/charliewilco/lexicodegen/internal/config"
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

func TestRunPrintsHelp(t *testing.T) {
	var output bytes.Buffer
	if err := runWithOutput(context.Background(), []string{"--help"}, &output); err != nil {
		t.Fatal(err)
	}

	got := output.String()
	for _, snippet := range []string{
		"lexicodegen generates Swift models",
		"Usage:",
		"--config <path>",
		"--version",
	} {
		if !strings.Contains(got, snippet) {
			t.Fatalf("help output missing %q:\n%s", snippet, got)
		}
	}
}

func TestRunPrintsVersion(t *testing.T) {
	var output bytes.Buffer
	if err := runWithOutput(context.Background(), []string{"--version"}, &output); err != nil {
		t.Fatal(err)
	}

	if got, want := output.String(), "lexicodegen dev (none, unknown)\n"; got != want {
		t.Fatalf("version output mismatch: %q != %q", got, want)
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
