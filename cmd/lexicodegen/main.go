package main

import (
	"context"
	"fmt"
	"os"
	"strings"

	"github.com/charliewilco/lexicodegen/internal/config"
	"github.com/charliewilco/lexicodegen/internal/ir"
	"github.com/charliewilco/lexicodegen/internal/source"
	"github.com/charliewilco/lexicodegen/internal/swiftgen"
)

func main() {
	if err := run(context.Background(), os.Args[1:]); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\n", err)
		os.Exit(1)
	}
}

func run(ctx context.Context, argv []string) error {
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

	fmt.Println("Lexicon generator")
	fmt.Printf("Loaded %d lexicon documents\n", len(docs))
	fmt.Printf("Configured targets: %s\n", joinTargets(cfg.Targets))

	for _, target := range cfg.Targets {
		if target == config.TargetSwift {
			fmt.Printf("Generating Swift %s\n", cfg.Output.SwiftOutDir)
			if err := swiftgen.EmitSwiftFromIR(irData, cfg.Output.SwiftOutDir, swiftgen.EmitOptions{
				FilePrefix: cfg.Output.SwiftFilePrefix,
			}); err != nil {
				return err
			}
		}
	}

	return nil
}

func joinTargets(targets []config.Target) string {
	values := make([]string, 0, len(targets))
	for _, target := range targets {
		values = append(values, string(target))
	}
	return strings.Join(values, ", ")
}
