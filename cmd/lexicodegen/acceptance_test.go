package main

import (
	"bytes"
	"context"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"
	"testing"
)

type acceptanceCase struct {
	name          string
	args          func(t *testing.T, suiteDir string, outputDir string) []string
	workingDir    string
	expectedFiles []string
	snippets      map[string][]string
	absent        []string
}

func TestAcceptanceGenerationContracts(t *testing.T) {
	cases := []acceptanceCase{
		{
			name: "minimal-endpoints",
			args: func(t *testing.T, suiteDir string, outputDir string) []string {
				t.Helper()
				return []string{filepath.Join(suiteDir, "lexicons"), "--output", outputDir}
			},
			expectedFiles: []string{"AppBskyFeed.generated.swift", "Endpoints.swift", "Models.swift"},
			snippets: map[string][]string{
				"AppBskyFeed.generated.swift": {
					"public struct AppBskyFeedDefsPostView",
					"public struct AppBskyFeedGetTimelineParameters",
					"public struct AppBskyFeedGetTimelineOutput",
					"public enum AppBskyFeedGetTimelineError",
					"public struct AppBskyFeedCreatePostInput",
					"public typealias AppBskyFeedCreatePostOutput = AppBskyFeedDefsPostView",
				},
				"Endpoints.swift": {
					"public func getTimeline(input: AppBskyFeedGetTimelineParameters) async throws -> AppBskyFeedGetTimelineOutput",
					"public func createPost(input: AppBskyFeedCreatePostInput) async throws -> AppBskyFeedCreatePostOutput",
					`client.requestJSON(method: "GET"`,
					`client.requestJSON(method: "POST"`,
				},
			},
		},
		{
			name: "refs-and-unions",
			args: func(t *testing.T, suiteDir string, outputDir string) []string {
				t.Helper()
				return []string{filepath.Join(suiteDir, "lexicons"), "--output", outputDir}
			},
			expectedFiles: []string{"AppBskyRichtext.generated.swift", "Endpoints.swift", "Models.swift"},
			snippets: map[string][]string{
				"AppBskyRichtext.generated.swift": {
					"public struct AppBskyRichtextFacet",
					"public struct AppBskyRichtextFacetByteSlice",
					"public indirect enum AppBskyRichtextFacetFeaturesItem",
					"case mention(AppBskyRichtextFacetMention)",
					"case unexpected(ATProtocolValueContainer)",
				},
			},
		},
		{
			name: "permissions",
			args: func(t *testing.T, suiteDir string, outputDir string) []string {
				t.Helper()
				return []string{filepath.Join(suiteDir, "lexicons"), "--output", outputDir}
			},
			expectedFiles: []string{"AppBskyAuthManageProfile.generated.swift", "Endpoints.swift", "Models.swift"},
			snippets: map[string][]string{
				"AppBskyAuthManageProfile.generated.swift": {
					"public struct AppBskyAuthManageProfileMethod",
					`public static let appBskyActorGetProfile = Self(rawValue: "app.bsky.actor.getProfile")`,
					"public struct AppBskyAuthManageProfile: Codable, Sendable, Equatable",
					"public static let knownMethods: [AppBskyAuthManageProfileMethod]",
				},
			},
		},
		{
			name: "config-filtering",
			args: func(t *testing.T, suiteDir string, outputDir string) []string {
				t.Helper()
				return []string{"--config", filepath.Join(suiteDir, "config.json"), "--output", outputDir}
			},
			workingDir: "config-filtering",
			expectedFiles: []string{
				"Filtered_AppBskyFeed.generated.swift",
				"Filtered_Endpoints.swift",
				"Filtered_Models.swift",
			},
			snippets: map[string][]string{
				"Filtered_AppBskyFeed.generated.swift": {
					"public struct AppBskyFeedDefsPostView",
				},
			},
			absent: []string{
				"AppBskyFeedDefsOldView",
				"AppBskyUnspeccedWidget",
				"ComExampleIgnored",
			},
		},
	}

	for _, testCase := range cases {
		testCase := testCase
		t.Run(testCase.name, func(t *testing.T) {
			repoRoot := acceptanceRepoRoot(t)
			suiteDir := filepath.Join(repoRoot, "testdata", "acceptance", testCase.name)
			outputDir := t.TempDir()

			runAcceptanceCase(t, testCase, suiteDir, outputDir)
			assertGeneratedFiles(t, outputDir, testCase.expectedFiles)
			assertGeneratedSnippets(t, outputDir, testCase.snippets)
			assertGeneratedAbsence(t, outputDir, testCase.absent)
			compileSwiftUsageIfAvailable(t, outputDir, filepath.Join(suiteDir, "usage.swift"))
		})
	}
}

func runAcceptanceCase(t *testing.T, testCase acceptanceCase, suiteDir string, outputDir string) {
	t.Helper()

	var output bytes.Buffer
	if testCase.workingDir == "" {
		if err := runWithOutput(context.Background(), testCase.args(t, suiteDir, outputDir), &output); err != nil {
			t.Fatalf("acceptance generation failed:\n%s\n%v", output.String(), err)
		}
		return
	}

	originalWD, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	if err := os.Chdir(filepath.Join(filepath.Dir(suiteDir), testCase.workingDir)); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() {
		_ = os.Chdir(originalWD)
	})

	if err := runWithOutput(context.Background(), testCase.args(t, suiteDir, outputDir), &output); err != nil {
		t.Fatalf("acceptance generation failed:\n%s\n%v", output.String(), err)
	}
}

func assertGeneratedFiles(t *testing.T, outputDir string, expected []string) {
	t.Helper()

	entries, err := os.ReadDir(outputDir)
	if err != nil {
		t.Fatal(err)
	}
	got := make([]string, 0, len(entries))
	for _, entry := range entries {
		if !entry.IsDir() && filepath.Ext(entry.Name()) == ".swift" {
			got = append(got, entry.Name())
		}
	}
	sort.Strings(got)
	expected = append([]string(nil), expected...)
	sort.Strings(expected)

	if strings.Join(got, "\n") != strings.Join(expected, "\n") {
		t.Fatalf("generated files mismatch:\ngot:\n%s\nwant:\n%s", strings.Join(got, "\n"), strings.Join(expected, "\n"))
	}
}

func assertGeneratedSnippets(t *testing.T, outputDir string, snippets map[string][]string) {
	t.Helper()

	for fileName, expectedSnippets := range snippets {
		content := readAcceptanceFile(t, filepath.Join(outputDir, fileName))
		for _, snippet := range expectedSnippets {
			if !strings.Contains(content, snippet) {
				t.Fatalf("%s missing snippet %q", fileName, snippet)
			}
		}
	}
}

func assertGeneratedAbsence(t *testing.T, outputDir string, absent []string) {
	t.Helper()

	if len(absent) == 0 {
		return
	}
	content := strings.Join(readGeneratedSwiftFiles(t, outputDir), "\n")
	for _, snippet := range absent {
		if strings.Contains(content, snippet) {
			t.Fatalf("generated output unexpectedly contains %q", snippet)
		}
	}
}

func compileSwiftUsageIfAvailable(t *testing.T, outputDir string, usagePath string) {
	t.Helper()

	if _, err := exec.LookPath("swiftc"); err != nil {
		t.Skip("swiftc not available")
	}

	swiftFiles, err := filepath.Glob(filepath.Join(outputDir, "*.swift"))
	if err != nil {
		t.Fatal(err)
	}
	sort.Strings(swiftFiles)
	args := append([]string{"-typecheck"}, swiftFiles...)
	args = append(args, usagePath)

	command := exec.Command("swiftc", args...)
	output, err := command.CombinedOutput()
	if err != nil {
		t.Fatalf("swift usage typecheck failed: %v\n%s", err, string(output))
	}
}

func readGeneratedSwiftFiles(t *testing.T, outputDir string) []string {
	t.Helper()

	swiftFiles, err := filepath.Glob(filepath.Join(outputDir, "*.swift"))
	if err != nil {
		t.Fatal(err)
	}
	sort.Strings(swiftFiles)

	contents := make([]string, 0, len(swiftFiles))
	for _, path := range swiftFiles {
		contents = append(contents, readAcceptanceFile(t, path))
	}
	return contents
}

func readAcceptanceFile(t *testing.T, path string) string {
	t.Helper()

	content, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	return string(content)
}

func acceptanceRepoRoot(t *testing.T) string {
	t.Helper()

	root, err := filepath.Abs(filepath.Join("..", ".."))
	if err != nil {
		t.Fatal(err)
	}
	return root
}
