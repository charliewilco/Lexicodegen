package source

import (
	"archive/tar"
	"compress/gzip"
	"context"
	"fmt"
	"io"
	"io/fs"
	"net/http"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/charliewilco/lexicon-openapi-generator/internal/config"
	"github.com/charliewilco/lexicon-openapi-generator/internal/schema"
)

type SourceLoader interface {
	Load(ctx context.Context, source config.LexiconSource) ([]schema.Document, error)
}

type DefaultLoader struct {
	Client *http.Client
}

func LoadLexiconsFromSources(ctx context.Context, sources []config.LexiconSource) ([]schema.Document, error) {
	loader := DefaultLoader{Client: http.DefaultClient}
	var docs []schema.Document
	for _, source := range sources {
		loaded, err := loader.Load(ctx, source)
		if err != nil {
			return nil, fmt.Errorf("failed to load source %s: %w", source.Kind, err)
		}
		docs = append(docs, loaded...)
	}
	return docs, nil
}

func (l DefaultLoader) Load(ctx context.Context, source config.LexiconSource) ([]schema.Document, error) {
	switch source.Kind {
	case "local":
		return l.loadLocal(source)
	case "http":
		return l.loadHTTP(ctx, source.URL)
	case "git-archive":
		return l.loadGitArchive(ctx, source)
	default:
		return nil, fmt.Errorf("unsupported source kind: %s", source.Kind)
	}
}

func (l DefaultLoader) loadLocal(source config.LexiconSource) ([]schema.Document, error) {
	info, err := os.Stat(source.Path)
	if err != nil {
		return nil, err
	}

	paths := []string{}
	if info.IsDir() {
		recursive := source.Recursive == nil || *source.Recursive
		err = filepath.WalkDir(source.Path, func(path string, entry fs.DirEntry, walkErr error) error {
			if walkErr != nil {
				return walkErr
			}
			if entry.IsDir() {
				if path != source.Path && !recursive {
					return filepath.SkipDir
				}
				return nil
			}
			if strings.HasSuffix(path, ".json") {
				paths = append(paths, path)
			}
			return nil
		})
		if err != nil {
			return nil, err
		}
	} else if strings.HasSuffix(source.Path, ".json") {
		paths = append(paths, source.Path)
	}

	sort.Strings(paths)
	var docs []schema.Document
	for _, path := range paths {
		content, err := os.ReadFile(path)
		if err != nil {
			return nil, err
		}
		parsed, err := schema.ParseDocuments(content)
		if err != nil {
			return nil, err
		}
		docs = append(docs, parsed...)
	}
	return docs, nil
}

func (l DefaultLoader) loadHTTP(ctx context.Context, rawURL string) ([]schema.Document, error) {
	request, err := http.NewRequestWithContext(ctx, http.MethodGet, rawURL, nil)
	if err != nil {
		return nil, err
	}
	response, err := l.client().Do(request)
	if err != nil {
		return nil, err
	}
	defer response.Body.Close()

	if response.StatusCode < 200 || response.StatusCode >= 300 {
		return nil, fmt.Errorf("failed to load %s: %d", rawURL, response.StatusCode)
	}
	contentType := response.Header.Get("content-type")
	if !strings.Contains(strings.ToLower(contentType), "json") {
		return nil, fmt.Errorf("expected JSON response from %s but got %s", rawURL, contentType)
	}
	body, err := io.ReadAll(response.Body)
	if err != nil {
		return nil, err
	}
	return schema.ParseDocuments(body)
}

func (l DefaultLoader) loadGitArchive(ctx context.Context, source config.LexiconSource) ([]schema.Document, error) {
	request, err := http.NewRequestWithContext(ctx, http.MethodGet, source.URL, nil)
	if err != nil {
		return nil, err
	}
	response, err := l.client().Do(request)
	if err != nil {
		return nil, err
	}
	defer response.Body.Close()
	if response.StatusCode < 200 || response.StatusCode >= 300 {
		return nil, fmt.Errorf("failed to load git archive %s", source.URL)
	}

	tempDir, err := os.MkdirTemp("", "lexicon-src-*")
	if err != nil {
		return nil, err
	}
	defer os.RemoveAll(tempDir)

	gzipReader, err := gzip.NewReader(response.Body)
	if err != nil {
		return nil, err
	}
	defer gzipReader.Close()

	tarReader := tar.NewReader(gzipReader)
	for {
		header, err := tarReader.Next()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, err
		}

		targetPath := filepath.Join(tempDir, header.Name)
		switch header.Typeflag {
		case tar.TypeDir:
			if err := os.MkdirAll(targetPath, 0o755); err != nil {
				return nil, err
			}
		case tar.TypeReg:
			if err := os.MkdirAll(filepath.Dir(targetPath), 0o755); err != nil {
				return nil, err
			}
			file, err := os.Create(targetPath)
			if err != nil {
				return nil, err
			}
			if _, err := io.Copy(file, tarReader); err != nil {
				file.Close()
				return nil, err
			}
			if err := file.Close(); err != nil {
				return nil, err
			}
		}
	}

	scanRoot := tempDir
	if source.StripPath != "" {
		scanRoot = filepath.Join(tempDir, source.StripPath)
	}

	return l.loadLocal(config.LexiconSource{
		Kind:      "local",
		Path:      scanRoot,
		Recursive: source.Recursive,
	})
}

func (l DefaultLoader) client() *http.Client {
	if l.Client != nil {
		return l.Client
	}
	return http.DefaultClient
}
