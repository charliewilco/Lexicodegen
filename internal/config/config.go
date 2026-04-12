package config

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/pelletier/go-toml/v2"
)

type Target string

const TargetSwift Target = "swift"

type LexiconSource struct {
	Kind      string `json:"kind" toml:"kind"`
	Path      string `json:"path,omitempty" toml:"path,omitempty"`
	URL       string `json:"url,omitempty" toml:"url,omitempty"`
	Recursive *bool  `json:"recursive,omitempty" toml:"recursive,omitempty"`
	StripPath string `json:"stripPath,omitempty" toml:"stripPath,omitempty"`
	Branch    string `json:"branch,omitempty" toml:"branch,omitempty"`
}

type GenerationFilter struct {
	AllowPrefixes  []string `json:"allowPrefixes,omitempty" toml:"allowPrefixes,omitempty"`
	DenyPrefixes   []string `json:"denyPrefixes,omitempty" toml:"denyPrefixes,omitempty"`
	DenyUnspecced  bool     `json:"denyUnspecced,omitempty" toml:"denyUnspecced,omitempty"`
	DenyDeprecated bool     `json:"denyDeprecated,omitempty" toml:"denyDeprecated,omitempty"`
}

type OutputConfig struct {
	SwiftOutDir     string `json:"swiftOutDir,omitempty" toml:"swiftOutDir,omitempty"`
	SwiftFilePrefix string `json:"swiftFilePrefix,omitempty" toml:"swiftFilePrefix,omitempty"`
}

type GeneratorConfig struct {
	Sources []LexiconSource  `json:"sources" toml:"sources"`
	Filters GenerationFilter `json:"filters" toml:"filters"`
	Targets []Target         `json:"targets" toml:"targets"`
	Output  OutputConfig     `json:"output" toml:"output"`
}

type rawConfig struct {
	Sources []LexiconSource   `json:"sources" toml:"sources"`
	Filters *GenerationFilter `json:"filters" toml:"filters"`
	Targets []string          `json:"targets" toml:"targets"`
	Output  *OutputConfig     `json:"output" toml:"output"`
}

type rawCLI struct {
	ConfigPath     string
	Sources        []LexiconSource
	Positional     []string
	AllowPrefixes  []string
	DenyPrefixes   []string
	Targets        []string
	SwiftOutputDir string
	OutputDir      string
	DenyUnspecced  *bool
	DenyDeprecated *bool
}

var defaultRecursive = true

var defaultConfig = GeneratorConfig{
	Sources: []LexiconSource{{
		Kind:      "local",
		Path:      "./lexicons",
		Recursive: &defaultRecursive,
	}},
	Filters: GenerationFilter{
		AllowPrefixes:  []string{},
		DenyPrefixes:   []string{},
		DenyUnspecced:  false,
		DenyDeprecated: false,
	},
	Targets: []Target{TargetSwift},
	Output: OutputConfig{
		SwiftOutDir:     "./output/swift",
		SwiftFilePrefix: "",
	},
}

func Load(argv []string, cwd string) (GeneratorConfig, error) {
	cli, err := parseArgs(argv)
	if err != nil {
		return GeneratorConfig{}, err
	}

	var fileConfig rawConfig
	if cli.ConfigPath != "" {
		fileConfig, err = loadConfigFile(cli.ConfigPath, cwd)
		if err != nil {
			return GeneratorConfig{}, err
		}
	}

	filters := mergeFilters(cli, fileConfig)
	targets, err := mergeTargets(cli.Targets, fileConfig.Targets)
	if err != nil {
		return GeneratorConfig{}, err
	}
	sources, err := mergeSources(cli, fileConfig, cwd)
	if err != nil {
		return GeneratorConfig{}, err
	}

	output := defaultConfig.Output.SwiftOutDir
	if fileConfig.Output != nil && strings.TrimSpace(fileConfig.Output.SwiftOutDir) != "" {
		output = fileConfig.Output.SwiftOutDir
	}
	if cli.SwiftOutputDir != "" {
		output = cli.SwiftOutputDir
	}
	if cli.OutputDir != "" {
		output = cli.OutputDir
	}

	filePrefix := defaultConfig.Output.SwiftFilePrefix
	if fileConfig.Output != nil {
		filePrefix, err = normalizeSwiftFilePrefix(fileConfig.Output.SwiftFilePrefix)
		if err != nil {
			return GeneratorConfig{}, err
		}
	}

	return GeneratorConfig{
		Sources: sources,
		Filters: filters,
		Targets: targets,
		Output: OutputConfig{
			SwiftOutDir:     resolvePath(cwd, output),
			SwiftFilePrefix: filePrefix,
		},
	}, nil
}

func parseArgs(argv []string) (rawCLI, error) {
	var cli rawCLI
	for index := 0; index < len(argv); index++ {
		arg := argv[index]
		if !strings.HasPrefix(arg, "-") || arg == "-" {
			cli.Positional = append(cli.Positional, arg)
			continue
		}

		name, value, hasValue := strings.Cut(arg, "=")
		nextValue := func() (string, error) {
			if hasValue {
				return value, nil
			}
			index++
			if index >= len(argv) {
				return "", fmt.Errorf("missing value for %s", name)
			}
			return argv[index], nil
		}

		switch name {
		case "--config":
			parsed, err := nextValue()
			if err != nil {
				return rawCLI{}, err
			}
			cli.ConfigPath = parsed
		case "--source":
			parsed, err := nextValue()
			if err != nil {
				return rawCLI{}, err
			}
			cli.Sources = append(cli.Sources, parseSourceArgument(parsed))
		case "--allow-prefix":
			parsed, err := nextValue()
			if err != nil {
				return rawCLI{}, err
			}
			cli.AllowPrefixes = append(cli.AllowPrefixes, splitListArg(parsed)...)
		case "--deny-prefix":
			parsed, err := nextValue()
			if err != nil {
				return rawCLI{}, err
			}
			cli.DenyPrefixes = append(cli.DenyPrefixes, splitListArg(parsed)...)
		case "--target", "--targets":
			parsed, err := nextValue()
			if err != nil {
				return rawCLI{}, err
			}
			cli.Targets = append(cli.Targets, splitListArg(parsed)...)
		case "--output":
			parsed, err := nextValue()
			if err != nil {
				return rawCLI{}, err
			}
			cli.OutputDir = parsed
		case "--swift-output-dir":
			parsed, err := nextValue()
			if err != nil {
				return rawCLI{}, err
			}
			cli.SwiftOutputDir = parsed
		case "--deny-unspecced":
			value := true
			cli.DenyUnspecced = &value
		case "--deny-deprecated":
			value := true
			cli.DenyDeprecated = &value
		default:
			return rawCLI{}, fmt.Errorf("unknown flag: %s", name)
		}
	}
	return cli, nil
}

func parseSourceArgument(source string) LexiconSource {
	switch {
	case strings.HasPrefix(source, "git-archive:"):
		return LexiconSource{Kind: "git-archive", URL: strings.TrimPrefix(source, "git-archive:")}
	case strings.HasPrefix(source, "local:"):
		return LexiconSource{Kind: "local", Path: strings.TrimPrefix(source, "local:")}
	case strings.HasPrefix(source, "http://"), strings.HasPrefix(source, "https://"):
		return LexiconSource{Kind: "http", URL: source}
	default:
		return LexiconSource{Kind: "local", Path: source}
	}
}

func splitListArg(raw string) []string {
	parts := strings.Split(raw, ",")
	values := make([]string, 0, len(parts))
	for _, part := range parts {
		part = strings.TrimSpace(part)
		if part != "" {
			values = append(values, part)
		}
	}
	return values
}

func loadConfigFile(rawPath string, cwd string) (rawConfig, error) {
	path := resolvePath(cwd, rawPath)
	content, err := os.ReadFile(path)
	if err != nil {
		return rawConfig{}, err
	}

	var config rawConfig
	switch filepath.Ext(path) {
	case ".toml":
		if err := toml.Unmarshal(content, &config); err != nil {
			return rawConfig{}, err
		}
	default:
		if err := json.Unmarshal(content, &config); err != nil {
			return rawConfig{}, err
		}
	}

	return config, nil
}

func mergeFilters(cli rawCLI, fileConfig rawConfig) GenerationFilter {
	filters := defaultConfig.Filters
	if fileConfig.Filters != nil {
		filters = *fileConfig.Filters
		if filters.AllowPrefixes == nil {
			filters.AllowPrefixes = []string{}
		}
		if filters.DenyPrefixes == nil {
			filters.DenyPrefixes = []string{}
		}
	}

	if len(cli.AllowPrefixes) > 0 {
		filters.AllowPrefixes = append([]string{}, cli.AllowPrefixes...)
	}
	if len(cli.DenyPrefixes) > 0 {
		filters.DenyPrefixes = append([]string{}, cli.DenyPrefixes...)
	}
	if cli.DenyUnspecced != nil {
		filters.DenyUnspecced = *cli.DenyUnspecced
	}
	if cli.DenyDeprecated != nil {
		filters.DenyDeprecated = *cli.DenyDeprecated
	}

	filters.AllowPrefixes = filterEmptyStrings(filters.AllowPrefixes)
	filters.DenyPrefixes = filterEmptyStrings(filters.DenyPrefixes)
	return filters
}

func mergeTargets(cliTargets []string, fileTargets []string) ([]Target, error) {
	source := fileTargets
	if len(source) == 0 {
		source = []string{"swift"}
	}
	if len(cliTargets) > 0 {
		source = cliTargets
	}

	seen := map[Target]bool{}
	targets := make([]Target, 0, len(source))
	for _, raw := range source {
		switch strings.ToLower(strings.TrimSpace(raw)) {
		case "", "swift", "both":
			if !seen[TargetSwift] {
				targets = append(targets, TargetSwift)
				seen[TargetSwift] = true
			}
		default:
			return nil, fmt.Errorf("unsupported target: %s", raw)
		}
	}
	if len(targets) == 0 {
		return nil, errors.New("no valid targets configured")
	}
	return targets, nil
}

func mergeSources(cli rawCLI, fileConfig rawConfig, cwd string) ([]LexiconSource, error) {
	hasCLISources := len(cli.Sources) > 0 || len(cli.Positional) > 0

	var sources []LexiconSource
	if hasCLISources {
		sources = append(sources, cli.Sources...)
		for _, positional := range cli.Positional {
			sources = append(sources, parseSourceArgument(positional))
		}
	} else if len(fileConfig.Sources) > 0 {
		sources = append(sources, fileConfig.Sources...)
	} else {
		sources = append(sources, defaultConfig.Sources...)
	}

	normalized := make([]LexiconSource, 0, len(sources))
	for _, source := range sources {
		if err := validateSource(source); err != nil {
			return nil, err
		}
		if source.Kind == "local" {
			source.Path = resolvePath(cwd, source.Path)
			if source.Recursive == nil {
				source.Recursive = &defaultRecursive
			}
		}
		normalized = append(normalized, source)
	}
	return normalized, nil
}

func validateSource(source LexiconSource) error {
	switch source.Kind {
	case "local":
		if strings.TrimSpace(source.Path) == "" {
			return errors.New("local source requires path")
		}
	case "http":
		if strings.TrimSpace(source.URL) == "" {
			return errors.New("http source requires url")
		}
	case "git-archive":
		if strings.TrimSpace(source.URL) == "" {
			return errors.New("git-archive source requires url")
		}
	default:
		return fmt.Errorf("unsupported source kind: %s", source.Kind)
	}
	return nil
}

func filterEmptyStrings(values []string) []string {
	filtered := make([]string, 0, len(values))
	for _, value := range values {
		value = strings.TrimSpace(value)
		if value != "" {
			filtered = append(filtered, value)
		}
	}
	return filtered
}

func normalizeSwiftFilePrefix(raw string) (string, error) {
	normalized := strings.TrimSpace(raw)
	if strings.ContainsAny(normalized, `/\`) {
		return "", errors.New("output.swiftFilePrefix cannot contain path separators")
	}
	return normalized, nil
}

func resolvePath(cwd string, raw string) string {
	if filepath.IsAbs(raw) {
		return raw
	}
	return filepath.Join(cwd, raw)
}
