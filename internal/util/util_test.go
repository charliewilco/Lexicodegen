package util

import (
	"context"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"
)

func TestUtilityHelpers(t *testing.T) {
	t.Parallel()

	if got, want := CalculateTag("app.bsky.feed.post"), "app.bsky.feed"; got != want {
		t.Fatalf("tag mismatch: %s != %s", got, want)
	}
	if got, want := CalculateTag("com.atproto.admin.reputation"), "com.atproto.admin"; got != want {
		t.Fatalf("tag mismatch: %s != %s", got, want)
	}
	if got, want := CalculateTag("single"), "single"; got != want {
		t.Fatalf("tag mismatch: %s != %s", got, want)
	}
	if !IsGlobPattern("path/*.json") || !IsGlobPattern("path/[a-z].json") || IsGlobPattern("path/plain.json") {
		t.Fatalf("glob detection mismatch")
	}
	if !IsEmptyObject(map[string]any{}) || IsEmptyObject(map[string]any{"a": 1}) {
		t.Fatalf("empty object detection mismatch")
	}
	if !IsDeprecatedDefinition("Deprecated: this is old") || !IsDeprecatedDefinition("deprecated - do not use") || !IsDeprecatedDefinition("  DEPRECATED now") || IsDeprecatedDefinition("valid description") || IsDeprecatedDefinition("") {
		t.Fatalf("deprecated detection mismatch")
	}
}

func TestCheckEndpoint(t *testing.T) {
	originalBaseURL := endpointBaseURL
	originalClient := endpointHTTPClient
	t.Cleanup(func() {
		endpointBaseURL = originalBaseURL
		endpointHTTPClient = originalClient
	})

	server := httptest.NewServer(http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		switch request.URL.Path {
		case "/xrpc/exists":
			writer.WriteHeader(http.StatusOK)
		case "/xrpc/unauthorized":
			writer.WriteHeader(http.StatusUnauthorized)
		default:
			writer.WriteHeader(http.StatusNotFound)
		}
	}))
	defer server.Close()

	endpointBaseURL = server.URL + "/xrpc/"
	endpointHTTPClient = server.Client()

	if got, _ := CheckEndpoint(context.Background(), "exists", http.MethodGet); got != EndpointPublic {
		t.Fatalf("expected public endpoint, got %v", got)
	}
	if got, _ := CheckEndpoint(context.Background(), "unauthorized", http.MethodGet); got != EndpointNeedsAuthentication {
		t.Fatalf("expected auth endpoint, got %v", got)
	}
	if got, _ := CheckEndpoint(context.Background(), "missing", http.MethodGet); got != EndpointDoesNotExist {
		t.Fatalf("expected missing endpoint, got %v", got)
	}
}

func TestLoadJSONFile(t *testing.T) {
	t.Parallel()

	type payload struct {
		Name  string `json:"name"`
		Count int    `json:"count"`
	}

	tempDir := t.TempDir()
	validPath := filepath.Join(tempDir, "valid.json")
	if err := os.WriteFile(validPath, []byte(`{"name":"example","count":3}`), 0o644); err != nil {
		t.Fatalf("write valid fixture: %v", err)
	}

	var got payload
	if err := LoadJSONFile(validPath, &got); err != nil {
		t.Fatalf("load valid json: %v", err)
	}
	if got.Name != "example" || got.Count != 3 {
		t.Fatalf("unexpected payload: %#v", got)
	}

	if err := LoadJSONFile(filepath.Join(tempDir, "missing.json"), &got); err == nil {
		t.Fatalf("expected missing-file error")
	}

	invalidPath := filepath.Join(tempDir, "invalid.json")
	if err := os.WriteFile(invalidPath, []byte(`{"name":`), 0o644); err != nil {
		t.Fatalf("write invalid fixture: %v", err)
	}
	if err := LoadJSONFile(invalidPath, &got); err == nil {
		t.Fatalf("expected invalid-json error")
	}
}

func TestCheckEndpoint_DefaultMethodAndInvalidBaseURL(t *testing.T) {
	originalBaseURL := endpointBaseURL
	originalClient := endpointHTTPClient
	t.Cleanup(func() {
		endpointBaseURL = originalBaseURL
		endpointHTTPClient = originalClient
	})

	requestMethod := ""
	server := httptest.NewServer(http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		requestMethod = request.Method
		writer.WriteHeader(http.StatusOK)
	}))
	defer server.Close()

	endpointBaseURL = server.URL + "/xrpc/"
	endpointHTTPClient = server.Client()

	if got, err := CheckEndpoint(context.Background(), "defaults-method", ""); err != nil {
		t.Fatalf("unexpected default-method error: %v", err)
	} else if got != EndpointPublic {
		t.Fatalf("expected public endpoint, got %v", got)
	}
	if requestMethod != http.MethodGet {
		t.Fatalf("expected default method GET, got %q", requestMethod)
	}

	endpointBaseURL = ":// not a valid url"
	if got, err := CheckEndpoint(context.Background(), "defaults-method", http.MethodGet); err == nil {
		t.Fatalf("expected base-url parse error, got endpoint status %v", got)
	}
}
