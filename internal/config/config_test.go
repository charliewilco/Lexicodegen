package config

import (
	"os"
	"path/filepath"
	"testing"
)

func TestLoadJSONConfigFile(t *testing.T) {
	t.Parallel()

	configDir := t.TempDir()
	configPath := filepath.Join(configDir, "config.json")
	localSource := filepath.Join(configDir, "lexicons")
	if err := os.MkdirAll(localSource, 0o755); err != nil {
		t.Fatal(err)
	}

	content := `{
		"sources": [{"kind":"local","path":"` + localSource + `","recursive":true}],
		"filters": {
			"allowPrefixes": ["app.bsky"],
			"denyPrefixes": ["com.atproto.lexicon.resolveLexicon"],
			"denyUnspecced": true,
			"denyDeprecated": true
		},
		"targets": ["swift"],
		"output": {
			"swiftOutDir": "./output/custom"
		}
	}`
	if err := os.WriteFile(configPath, []byte(content), 0o644); err != nil {
		t.Fatal(err)
	}

	cwd := t.TempDir()
	cfg, err := Load([]string{"--config", configPath}, cwd)
	if err != nil {
		t.Fatal(err)
	}

	if len(cfg.Sources) != 1 || cfg.Sources[0].Path != localSource {
		t.Fatalf("unexpected sources: %#v", cfg.Sources)
	}
	if got, want := cfg.Filters.AllowPrefixes, []string{"app.bsky"}; !equalStrings(got, want) {
		t.Fatalf("allow prefixes mismatch: %#v != %#v", got, want)
	}
	if got, want := cfg.Filters.DenyPrefixes, []string{"com.atproto.lexicon.resolveLexicon"}; !equalStrings(got, want) {
		t.Fatalf("deny prefixes mismatch: %#v != %#v", got, want)
	}
	if !cfg.Filters.DenyUnspecced || !cfg.Filters.DenyDeprecated {
		t.Fatalf("expected deny flags to be true: %#v", cfg.Filters)
	}
	if got, want := cfg.Targets, []Target{TargetSwift}; !equalTargets(got, want) {
		t.Fatalf("targets mismatch: %#v != %#v", got, want)
	}
	if got, want := cfg.Output.SwiftOutDir, filepath.Join(cwd, "output/custom"); got != want {
		t.Fatalf("swift output dir mismatch: %s != %s", got, want)
	}
}

func TestLoadTOMLConfigWithCLIOverrides(t *testing.T) {
	t.Parallel()

	configDir := t.TempDir()
	configPath := filepath.Join(configDir, "config.toml")
	localSource := filepath.Join(configDir, "lexicons")
	if err := os.MkdirAll(localSource, 0o755); err != nil {
		t.Fatal(err)
	}

	content := `[[sources]]
kind = "local"
path = "` + localSource + `"
recursive = true

[filters]
allowPrefixes = ["app.bsky", "frontpage"]
denyPrefixes = []
denyUnspecced = false
denyDeprecated = false

targets = ["swift"]

[output]
swiftOutDir = "./output/toml"
`
	if err := os.WriteFile(configPath, []byte(content), 0o644); err != nil {
		t.Fatal(err)
	}

	cwd := t.TempDir()
	cfg, err := Load([]string{"--config", configPath, "--output", "./cli-output"}, cwd)
	if err != nil {
		t.Fatal(err)
	}

	if got, want := cfg.Filters.AllowPrefixes, []string{"app.bsky", "frontpage"}; !equalStrings(got, want) {
		t.Fatalf("allow prefixes mismatch: %#v != %#v", got, want)
	}
	if got, want := cfg.Output.SwiftOutDir, filepath.Join(cwd, "cli-output"); got != want {
		t.Fatalf("swift output dir mismatch: %s != %s", got, want)
	}
	if len(cfg.Sources) != 1 || cfg.Sources[0].Path != localSource {
		t.Fatalf("unexpected sources: %#v", cfg.Sources)
	}
}

func TestLoadUsesPositionalAndSourceTogether(t *testing.T) {
	t.Parallel()

	cwd := t.TempDir()
	cfg, err := Load([]string{
		"./lexicons",
		"https://example.com/some/collection",
		"--source", "./frontpage-lexicons",
		"--output", "./output/merged",
		"--targets", "swift",
		"--deny-prefix", "com.atproto.lexicon.resolveLexicon",
		"--deny-unspecced",
	}, cwd)
	if err != nil {
		t.Fatal(err)
	}

	expectedSources := []LexiconSource{
		{Kind: "local", Path: filepath.Join(cwd, "frontpage-lexicons"), Recursive: nil},
		{Kind: "local", Path: filepath.Join(cwd, "lexicons"), Recursive: nil},
		{Kind: "http", URL: "https://example.com/some/collection"},
	}
	if len(cfg.Sources) != len(expectedSources) {
		t.Fatalf("sources length mismatch: %#v", cfg.Sources)
	}
	for index, expected := range expectedSources {
		got := cfg.Sources[index]
		if got.Kind != expected.Kind || got.Path != expected.Path || got.URL != expected.URL {
			t.Fatalf("source mismatch at %d: %#v != %#v", index, got, expected)
		}
	}
	if got, want := cfg.Output.SwiftOutDir, filepath.Join(cwd, "output/merged"); got != want {
		t.Fatalf("swift output dir mismatch: %s != %s", got, want)
	}
	if got, want := cfg.Filters.DenyPrefixes, []string{"com.atproto.lexicon.resolveLexicon"}; !equalStrings(got, want) {
		t.Fatalf("deny prefixes mismatch: %#v != %#v", got, want)
	}
	if !cfg.Filters.DenyUnspecced {
		t.Fatalf("expected denyUnspecced to be true")
	}
	if got, want := cfg.Targets, []Target{TargetSwift}; !equalTargets(got, want) {
		t.Fatalf("targets mismatch: %#v != %#v", got, want)
	}
}

func TestLoadRejectsUnknownFlag(t *testing.T) {
	t.Parallel()

	_, err := Load([]string{"--wat"}, t.TempDir())
	if err == nil || err.Error() != "unknown flag: --wat" {
		t.Fatalf("expected unknown flag error, got %v", err)
	}
}

func TestLoadRejectsUnknownTarget(t *testing.T) {
	t.Parallel()

	_, err := Load([]string{"--target", "kotlin"}, t.TempDir())
	if err == nil || err.Error() != "unsupported target: kotlin" {
		t.Fatalf("expected unsupported target error, got %v", err)
	}
}

func TestLoadAcceptsBothAliasAndRejectsMalformedLocalSource(t *testing.T) {
	t.Parallel()

	cfg, err := Load([]string{"--target", "both"}, t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	if got, want := cfg.Targets, []Target{TargetSwift}; !equalTargets(got, want) {
		t.Fatalf("targets mismatch: %#v != %#v", got, want)
	}

	configPath := filepath.Join(t.TempDir(), "config.json")
	if err := os.WriteFile(configPath, []byte(`{"sources":[{"kind":"local"}]}`), 0o644); err != nil {
		t.Fatal(err)
	}
	_, err = Load([]string{"--config", configPath}, t.TempDir())
	if err == nil || err.Error() != "local source requires path" {
		t.Fatalf("expected malformed local source error, got %v", err)
	}
}

func equalStrings(left []string, right []string) bool {
	if len(left) != len(right) {
		return false
	}
	for index := range left {
		if left[index] != right[index] {
			return false
		}
	}
	return true
}

func equalTargets(left []Target, right []Target) bool {
	if len(left) != len(right) {
		return false
	}
	for index := range left {
		if left[index] != right[index] {
			return false
		}
	}
	return true
}
