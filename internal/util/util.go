package util

import (
	"context"
	"encoding/json"
	"net/http"
	"net/url"
	"os"
	"strings"
)

type Endpoint int

const (
	EndpointPublic Endpoint = iota
	EndpointNeedsAuthentication
	EndpointDoesNotExist
)

var endpointBaseURL = "https://bsky.social/xrpc/"
var endpointHTTPClient = http.DefaultClient

func LoadJSONFile(path string, target any) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	return json.Unmarshal(data, target)
}

func IsEmptyObject(object map[string]any) bool {
	return len(object) == 0
}

func CalculateTag(id string) string {
	parts := strings.Split(id, ".")
	limit := 3
	if len(parts) < limit {
		limit = len(parts)
	}
	return strings.Join(parts[:limit], ".")
}

func IsGlobPattern(path string) bool {
	return strings.ContainsAny(path, "*?[")
}

func IsDeprecatedDefinition(description string) bool {
	return strings.HasPrefix(strings.TrimSpace(strings.ToLower(description)), "deprecated")
}

func CheckEndpoint(ctx context.Context, endpointPath string, method string) (Endpoint, error) {
	if method == "" {
		method = http.MethodGet
	}
	base, err := url.Parse(endpointBaseURL)
	if err != nil {
		return EndpointDoesNotExist, err
	}
	target, err := base.Parse(endpointPath)
	if err != nil {
		return EndpointDoesNotExist, err
	}

	request, err := http.NewRequestWithContext(ctx, method, target.String(), nil)
	if err != nil {
		return EndpointDoesNotExist, err
	}
	response, err := endpointHTTPClient.Do(request)
	if err != nil {
		return EndpointDoesNotExist, err
	}
	defer response.Body.Close()

	switch response.StatusCode {
	case http.StatusUnauthorized:
		return EndpointNeedsAuthentication, nil
	case http.StatusNotFound:
		return EndpointDoesNotExist, nil
	default:
		return EndpointPublic, nil
	}
}
