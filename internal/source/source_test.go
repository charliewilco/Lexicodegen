package source

import (
	"archive/tar"
	"bytes"
	"compress/gzip"
	"context"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"sort"
	"testing"

	"github.com/charliewilco/lexicodegen/internal/config"
)

func TestLoadLexiconsRecursivelyByDefault(t *testing.T) {
	t.Parallel()

	sourceDir := t.TempDir()
	nestedDir := filepath.Join(sourceDir, "nested")
	if err := os.MkdirAll(nestedDir, 0o755); err != nil {
		t.Fatal(err)
	}
	writeFile(t, filepath.Join(sourceDir, "root.json"), `{"id":"app.bsky.root","lexicon":1,"defs":{"main":{"type":"token"}}}`)
	writeFile(t, filepath.Join(nestedDir, "nested.json"), `{"id":"app.bsky.nested","lexicon":1,"defs":{"main":{"type":"token"}}}`)

	docs, err := LoadLexiconsFromSources(context.Background(), []config.LexiconSource{{
		Kind:      "local",
		Path:      sourceDir,
		Recursive: boolPointer(true),
	}})
	if err != nil {
		t.Fatal(err)
	}
	if len(docs) != 2 {
		t.Fatalf("expected 2 docs, got %d", len(docs))
	}
}

func TestLoadLexiconsNonRecursive(t *testing.T) {
	t.Parallel()

	sourceDir := t.TempDir()
	nestedDir := filepath.Join(sourceDir, "nested")
	if err := os.MkdirAll(nestedDir, 0o755); err != nil {
		t.Fatal(err)
	}
	writeFile(t, filepath.Join(sourceDir, "root.json"), `{"id":"app.bsky.root","lexicon":1,"defs":{"main":{"type":"token"}}}`)
	writeFile(t, filepath.Join(nestedDir, "nested.json"), `{"id":"app.bsky.nested","lexicon":1,"defs":{"main":{"type":"token"}}}`)

	docs, err := LoadLexiconsFromSources(context.Background(), []config.LexiconSource{{
		Kind:      "local",
		Path:      sourceDir,
		Recursive: boolPointer(false),
	}})
	if err != nil {
		t.Fatal(err)
	}
	if len(docs) != 1 {
		t.Fatalf("expected 1 doc, got %d", len(docs))
	}
}

func TestLoadLexiconsFromHTTPArray(t *testing.T) {
	t.Parallel()

	server := httptest.NewServer(http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		writer.Header().Set("content-type", "application/json")
		_, _ = writer.Write([]byte(`[{"id":"app.bsky.feed.post","lexicon":1,"defs":{"main":{"type":"token"}}},{"id":"app.bsky.actor.profile","lexicon":1,"defs":{"main":{"type":"token"}}}]`))
	}))
	defer server.Close()

	docs, err := LoadLexiconsFromSources(context.Background(), []config.LexiconSource{{
		Kind: "http",
		URL:  server.URL,
	}})
	if err != nil {
		t.Fatal(err)
	}
	if len(docs) != 2 {
		t.Fatalf("expected 2 docs, got %d", len(docs))
	}
	if docs[0].ID != "app.bsky.feed.post" || docs[1].ID != "app.bsky.actor.profile" {
		t.Fatalf("unexpected ids: %#v", docs)
	}
}

func TestLoadLexiconsWrapsHTTPError(t *testing.T) {
	t.Parallel()

	server := httptest.NewServer(http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		http.Error(writer, "missing", http.StatusNotFound)
	}))
	defer server.Close()

	_, err := LoadLexiconsFromSources(context.Background(), []config.LexiconSource{{
		Kind: "http",
		URL:  server.URL,
	}})
	if err == nil || err.Error() != "failed to load source http: failed to load "+server.URL+": 404" {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestLoadLexiconsRejectsNonJSONHTTPPayload(t *testing.T) {
	t.Parallel()

	server := httptest.NewServer(http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		_, _ = writer.Write([]byte("not-json"))
	}))
	defer server.Close()

	_, err := LoadLexiconsFromSources(context.Background(), []config.LexiconSource{{
		Kind: "http",
		URL:  server.URL,
	}})
	if err == nil || err.Error() != "failed to load source http: expected JSON response from "+server.URL+" but got text/plain; charset=utf-8" {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestLoadLexiconsFromGitArchive(t *testing.T) {
	t.Parallel()

	var payload bytes.Buffer
	gzipWriter := gzip.NewWriter(&payload)
	tarWriter := tar.NewWriter(gzipWriter)

	writeTarDir(t, tarWriter, "archive-root")
	writeTarDir(t, tarWriter, "archive-root/lexicons")
	writeTarFile(t, tarWriter, "archive-root/lexicons/one.json", `{"id":"app.bsky.feed.one","lexicon":1,"defs":{"main":{"type":"token"}}}`)
	writeTarDir(t, tarWriter, "archive-root/lexicons/nested")
	writeTarFile(t, tarWriter, "archive-root/lexicons/nested/two.json", `{"id":"app.bsky.feed.two","lexicon":1,"defs":{"main":{"type":"token"}}}`)

	if err := tarWriter.Close(); err != nil {
		t.Fatal(err)
	}
	if err := gzipWriter.Close(); err != nil {
		t.Fatal(err)
	}

	server := httptest.NewServer(http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		writer.WriteHeader(http.StatusOK)
		_, _ = writer.Write(payload.Bytes())
	}))
	defer server.Close()

	docs, err := LoadLexiconsFromSources(context.Background(), []config.LexiconSource{{
		Kind:      "git-archive",
		URL:       server.URL,
		StripPath: "archive-root/lexicons",
		Recursive: boolPointer(true),
	}})
	if err != nil {
		t.Fatal(err)
	}
	if len(docs) != 2 {
		t.Fatalf("expected 2 docs, got %d", len(docs))
	}
	gotIDs := []string{docs[0].ID, docs[1].ID}
	expectedIDs := []string{"app.bsky.feed.one", "app.bsky.feed.two"}
	sort.Strings(gotIDs)
	sort.Strings(expectedIDs)
	for index := range expectedIDs {
		if gotIDs[index] != expectedIDs[index] {
			t.Fatalf("unexpected ids: %#v", docs)
		}
	}
}

func boolPointer(value bool) *bool {
	return &value
}

func writeFile(t *testing.T, path string, content string) {
	t.Helper()
	if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
		t.Fatal(err)
	}
}

func writeTarDir(t *testing.T, writer *tar.Writer, name string) {
	t.Helper()
	header := &tar.Header{Name: name + "/", Mode: 0o755, Typeflag: tar.TypeDir}
	if err := writer.WriteHeader(header); err != nil {
		t.Fatal(err)
	}
}

func writeTarFile(t *testing.T, writer *tar.Writer, name string, content string) {
	t.Helper()
	header := &tar.Header{Name: name, Mode: 0o644, Size: int64(len(content))}
	if err := writer.WriteHeader(header); err != nil {
		t.Fatal(err)
	}
	if _, err := writer.Write([]byte(content)); err != nil {
		t.Fatal(err)
	}
}
