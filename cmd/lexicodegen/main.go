package main

import (
	"context"
	"fmt"
	"io"
	"os"
	"strings"

	"github.com/charliewilco/lexicodegen/internal/config"
	"github.com/charliewilco/lexicodegen/internal/ir"
	"github.com/charliewilco/lexicodegen/internal/source"
	"github.com/charliewilco/lexicodegen/internal/swiftgen"
)

var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
)

func main() {
	if err := runWithOutput(context.Background(), os.Args[1:], os.Stdout); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\n", err)
		os.Exit(1)
	}
}

func run(ctx context.Context, argv []string) error {
	return runWithOutput(ctx, argv, os.Stdout)
}

func runWithOutput(ctx context.Context, argv []string, output io.Writer) error {
	switch {
	case wantsHelp(argv):
		_, err := fmt.Fprint(output, helpText())
		return err
	case wantsVersion(argv):
		_, err := fmt.Fprintf(output, "lexicodegen %s (%s, %s)\n", version, commit, date)
		return err
	}

	cwd, err := os.Getwd()
	if err != nil {
		return err
	}

	cfg, err := config.Load(argv, cwd)
	if err != nil {
		return err
	}

	docs, err := source.LoadLexiconsFromSources(ctx, cfg.Sources)
	if err != nil {
		return err
	}

	irData := ir.BuildLexiconIR(docs, cfg.Filters)

	fmt.Fprintln(output, "Lexicon generator")
	fmt.Fprintf(output, "Loaded %d lexicon documents\n", len(docs))
	fmt.Fprintf(output, "Configured targets: %s\n", joinTargets(cfg.Targets))

	for _, target := range cfg.Targets {
		if target == config.TargetSwift {
			fmt.Fprintf(output, "Generating Swift %s\n", cfg.Output.SwiftOutDir)
			if err := swiftgen.EmitSwiftFromIR(irData, cfg.Output.SwiftOutDir, swiftgen.EmitOptions{
				FilePrefix: cfg.Output.SwiftFilePrefix,
			}); err != nil {
				return err
			}
		}
	}

	return nil
}

func wantsHelp(argv []string) bool {
	return len(argv) == 1 && (argv[0] == "--help" || argv[0] == "-h" || argv[0] == "help")
}

func wantsVersion(argv []string) bool {
	return len(argv) == 1 && (argv[0] == "--version" || argv[0] == "version")
}

func joinTargets(targets []config.Target) string {
	values := make([]string, 0, len(targets))
	for _, target := range targets {
		values = append(values, string(target))
	}
	return strings.Join(values, ", ")
}

func helpText() string {
	return `lexicodegen generates Swift models and XRPC client surface from AT Protocol lexicons.

Usage:
  lexicodegen [source ...] [flags]
  lexicodegen --config <path>
  lexicodegen help
  lexicodegen version

Sources:
  local path                 Local lexicon directory or JSON file
  local:<path>               Explicit local source
  https://example/lex.json   HTTP JSON document or JSON array
  git-archive:<url>          gzipped tar archive URL

Flags:
  --config <path>            JSON or TOML config file
  --source <source>          Additional source, repeatable
  --allow-prefix <prefix>    Include matching lexicon IDs, repeatable or comma-separated
  --deny-prefix <prefix>     Exclude matching lexicon IDs, repeatable or comma-separated
  --deny-unspecced           Skip unspecced definitions
  --deny-deprecated          Skip deprecated definitions
  --output <dir>             Swift output directory
  --swift-output-dir <dir>   Swift output directory
  --target <target>          Generation target; currently only swift
  --targets <target>         Alias for --target
  --help, -h                 Show this help
  --version                  Show version information

Examples:
  lexicodegen ./lexicons --output ./output/swift
  lexicodegen --config ./lexicodegen.toml
  lexicodegen --source git-archive:https://github.com/org/repo/archive/refs/heads/main.tar.gz --output ./output/swift
`
}
