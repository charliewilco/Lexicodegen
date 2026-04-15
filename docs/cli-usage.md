# CLI Usage

This document covers day-to-day usage of the `lexicodegen` command-line interface.

## Quick Start

Build the binary:

```bash
go build -o ./lexicodegen ./cmd/lexicodegen
```

Run generation from local lexicons:

```bash
./lexicodegen ./lexicons --output ./output/swift
```

Equivalent direct run without building:

```bash
go run ./cmd/lexicodegen ./lexicons --output ./output/swift
```

## Command Shape

```bash
lexicodegen <source1> [source2 ...] [--source <source>] [--output <swift-output-dir>]
```

Sources can be provided either as positional arguments or with repeated `--source` flags.

## Supported Source Inputs

A source can be any of the following:

- Local path (directory or file)
- HTTP/HTTPS URL
- `git-archive:` URL

Examples:

```bash
./lexicodegen ./lexicons ./extra-lexicons --output ./output/swift
./lexicodegen ./lexicons https://example.com/namespace.json --output ./output/swift
./lexicodegen --source local:./leaflet --source https://example.com/namespace.json --output ./output/swift
./lexicodegen --source git-archive:https://github.com/org/repo/archive/refs/heads/main.tar.gz --output ./output/swift
```

## Flags

### Core flags

- `--config <path>`
- `--source <path-or-url>` (repeatable)
- `--output <dir>`
- `--swift-output-dir <dir>`
- `--target <target>` / `--targets <target>`

### Filter flags

- `--allow-prefix <prefix>` (repeatable or comma-separated)
- `--deny-prefix <prefix>` (repeatable or comma-separated)
- `--deny-unspecced`
- `--deny-deprecated`

## Target Notes

- `swift` is the only supported target.
- `both` is accepted as a compatibility alias for `swift`.
- Unknown targets are rejected.

## Precedence and Merge Behavior

When both CLI flags and config file values are provided:

- CLI sources replace config `sources` if any positional source or `--source` is present.
- CLI filter flags override config filters individually.
- `--output` and `--swift-output-dir` override `output.swiftOutDir` from config.
- `output.swiftFilePrefix` is config-only.

## Common Workflows

Generate from default local source (`./lexicons`) using defaults:

```bash
./lexicodegen
```

Generate from config file:

```bash
./lexicodegen --config ./lexicodegen.toml
```

Generate while excluding deprecated and unspecced defs:

```bash
./lexicodegen ./lexicons --deny-unspecced --deny-deprecated --output ./output/swift
```

Generate a subset by namespace prefix:

```bash
./lexicodegen ./lexicons --allow-prefix app.bsky,com.atproto --output ./output/swift
```
