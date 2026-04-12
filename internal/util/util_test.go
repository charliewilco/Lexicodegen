package util

import (
	"context"
	"net/http"
	"net/http/httptest"
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
