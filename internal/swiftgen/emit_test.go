package swiftgen

import (
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"testing"

	"github.com/charliewilco/lexicodegen/internal/config"
	"github.com/charliewilco/lexicodegen/internal/ir"
	"github.com/charliewilco/lexicodegen/internal/source"
)

func TestEmitSwiftFromIRMatchesGoldenOutput(t *testing.T) {
	repoRoot := repoRoot(t)
	docs, err := source.LoadLexiconsFromSources(t.Context(), []config.LexiconSource{{
		Kind:      "local",
		Path:      filepath.Join(repoRoot, "lexicons"),
		Recursive: boolPointer(true),
	}})
	if err != nil {
		t.Fatal(err)
	}

	outputDir := t.TempDir()
	if err := EmitSwiftFromIR(ir.BuildLexiconIR(docs, config.GenerationFilter{}), outputDir); err != nil {
		t.Fatal(err)
	}

	compareDirectories(t, filepath.Join(repoRoot, "testdata", "golden", "full"), outputDir)
}

func TestEmitSwiftFromIRIsDeterministic(t *testing.T) {
	repoRoot := repoRoot(t)
	docs, err := source.LoadLexiconsFromSources(t.Context(), []config.LexiconSource{{
		Kind:      "local",
		Path:      filepath.Join(repoRoot, "lexicons"),
		Recursive: boolPointer(true),
	}})
	if err != nil {
		t.Fatal(err)
	}

	data := ir.BuildLexiconIR(docs, config.GenerationFilter{})
	leftDir := t.TempDir()
	rightDir := t.TempDir()

	if err := EmitSwiftFromIR(data, leftDir); err != nil {
		t.Fatal(err)
	}
	if err := EmitSwiftFromIR(data, rightDir); err != nil {
		t.Fatal(err)
	}

	compareDirectories(t, leftDir, rightDir)
}

func TestGeneratedSwiftTypechecks(t *testing.T) {
	if _, err := exec.LookPath("swiftc"); err != nil {
		t.Skip("swiftc not available")
	}

	repoRoot := repoRoot(t)
	docs, err := source.LoadLexiconsFromSources(t.Context(), []config.LexiconSource{{
		Kind:      "local",
		Path:      filepath.Join(repoRoot, "lexicons"),
		Recursive: boolPointer(true),
	}})
	if err != nil {
		t.Fatal(err)
	}

	outputDir := t.TempDir()
	if err := EmitSwiftFromIR(ir.BuildLexiconIR(docs, config.GenerationFilter{}), outputDir); err != nil {
		t.Fatal(err)
	}

	files, err := filepath.Glob(filepath.Join(outputDir, "*.swift"))
	if err != nil {
		t.Fatal(err)
	}
	sort.Strings(files)

	args := append([]string{"-typecheck"}, files...)
	command := exec.Command("swiftc", args...)
	output, err := command.CombinedOutput()
	if err != nil {
		t.Fatalf("swiftc failed: %v\n%s", err, string(output))
	}
}

func repoRoot(t *testing.T) string {
	t.Helper()
	root, err := filepath.Abs(filepath.Join("..", ".."))
	if err != nil {
		t.Fatal(err)
	}
	return root
}

func compareDirectories(t *testing.T, left string, right string) {
	t.Helper()

	leftEntries, err := os.ReadDir(left)
	if err != nil {
		t.Fatal(err)
	}
	rightEntries, err := os.ReadDir(right)
	if err != nil {
		t.Fatal(err)
	}

	leftFiles := swiftFiles(leftEntries)
	rightFiles := swiftFiles(rightEntries)
	if len(leftFiles) != len(rightFiles) {
		t.Fatalf("file count mismatch: %d != %d", len(leftFiles), len(rightFiles))
	}
	for index := range leftFiles {
		if leftFiles[index] != rightFiles[index] {
			t.Fatalf("filename mismatch at %d: %s != %s", index, leftFiles[index], rightFiles[index])
		}
		leftContent, err := os.ReadFile(filepath.Join(left, leftFiles[index]))
		if err != nil {
			t.Fatal(err)
		}
		rightContent, err := os.ReadFile(filepath.Join(right, rightFiles[index]))
		if err != nil {
			t.Fatal(err)
		}
		if string(leftContent) != string(rightContent) {
			t.Fatalf("content mismatch for %s", leftFiles[index])
		}
	}
}

func swiftFiles(entries []os.DirEntry) []string {
	files := make([]string, 0, len(entries))
	for _, entry := range entries {
		if !entry.IsDir() && filepath.Ext(entry.Name()) == ".swift" {
			files = append(files, entry.Name())
		}
	}
	sort.Strings(files)
	return files
}

func boolPointer(value bool) *bool {
	return &value
}
