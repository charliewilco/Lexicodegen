# Lexicodegen

Generate Swift models and XRPC client surface from AT Protocol lexicons with a single Go CLI.

This repo used to be Bun/TypeScript-based. It is now Go-first:

- lexicon parsing and validation use [Indigo](https://github.com/bluesky-social/indigo)
- config, source loading, IR building, and Swift emission are repo-owned Go code
- generated Swift output is kept near-parity with the previous implementation

## Current status

As of 2026-04-11, the primary local verification flow is:

- `go test ./...`
- `go build -o ./lexicodegen ./cmd/lexicodegen`
- `go run ./cmd/lexicodegen ./lexicons --output ./output/swift`
- `bash ./scripts/check-swift-compile.sh ./output/swift`

`go test ./...` includes:

- config precedence tests for JSON and TOML
- source loading tests for local and HTTP inputs
- IR filtering and determinism tests
- full golden-output parity tests for the checked-in lexicon set
- optional `swiftc` compilation of generated output when `swiftc` is available on `PATH`

## Why this exists

The generator is Swift-first. It takes one or more lexicon sources and emits:

- namespace-grouped generated Swift model files such as `AppBskyFeed.generated.swift`
- shared runtime helpers in `Models.swift`
- namespaced endpoint accessors in `Endpoints.swift`

The design intentionally keeps a repo-owned intermediate representation so future targets are possible without coupling the project to Indigo’s generator packages.

## Project layout

- `cmd/lexicodegen`: CLI entrypoint
- `internal/config`: CLI and config-file parsing, defaults, normalization, validation
- `internal/source`: local, HTTP, and git-archive lexicon loading
- `internal/schema`: raw normalized schema model plus Indigo-backed validation adapter
- `internal/ir`: generator IR for Swift emission
- `internal/swiftgen`: Swift-specific code generation
- `lexicons/`: checked-in lexicon JSON input
- `testdata/golden/full/`: parity snapshot for generated Swift output
- `scripts/get-lexicons.sh`: refreshes lexicon snapshots from upstream
- `scripts/check-swift-compile.sh`: typechecks generated Swift with `swiftc`

## Installation

Requirements:

- Go 1.26+
- Swift 6.2+ if you want to run generated-code compilation checks

Build the CLI:

```bash
go build -o ./lexicodegen ./cmd/lexicodegen
```

Or run it directly:

```bash
go run ./cmd/lexicodegen ./lexicons --output ./output/swift
```

## Usage

Basic usage:

```bash
go run ./cmd/lexicodegen <source1> [source2 ...] [--source <source>] [--output <swift-output-dir>]
```

Examples:

```bash
go run ./cmd/lexicodegen ./lexicons ./frontpage-lexicons --output ./output/swift
go run ./cmd/lexicodegen ./lexicons https://example.com/namespace.json --output ./output/swift
go run ./cmd/lexicodegen --source local:./leaflet --source https://example.com/namespace.json --output ./output/swift
```

Supported source kinds:

- local directory or file
- HTTP JSON document or JSON array of documents
- `git-archive:` tarball URL with optional `stripPath` in config

## Flags

Supported CLI flags:

- `--config <path>`
- `--source <path-or-url>` (repeatable)
- `--allow-prefix <prefix>` (repeatable or comma-separated)
- `--deny-prefix <prefix>` (repeatable or comma-separated)
- `--deny-unspecced`
- `--deny-deprecated`
- `--output <dir>`
- `--swift-output-dir <dir>`
- `--target <target>` / `--targets <target>`

Notes:

- `swift` is the only supported target
- `both` is accepted as a compatibility alias for `swift`
- unknown flags are rejected
- unknown targets are rejected

## Config files

JSON and TOML config files are supported:

```bash
go run ./cmd/lexicodegen --config ./lexicodegen.toml
go run ./cmd/lexicodegen --config ./lexicodegen.json
```

Config shape:

- `sources`
- `filters`
- `targets`
- `output.swiftOutDir`

Example:

```toml
[[sources]]
kind = "local"
path = "./lexicons"
recursive = true

[filters]
allowPrefixes = ["app.bsky", "frontpage"]
denyPrefixes = ["com.atproto.lexicon.resolveLexicon"]
denyUnspecced = false
denyDeprecated = false

targets = ["swift"]

[output]
swiftOutDir = "./output/swift"
```

## Development

Common commands:

```bash
go test ./...
go build -o ./lexicodegen ./cmd/lexicodegen
go run ./cmd/lexicodegen ./lexicons --output ./output/swift
bash ./scripts/check-swift-compile.sh ./output/swift
```

Optional `just` wrappers:

```bash
just test
just build
just generate
just verify-swift
```

Refresh lexicons from upstream:

```bash
sh ./scripts/get-lexicons.sh
```

## Testing

Run the full Go suite:

```bash
go test ./...
```

That suite verifies:

- config merge and validation behavior
- source loading behavior
- IR inclusion and ordering
- exact generated Swift parity against `testdata/golden/full`
- deterministic repeat output
- generated Swift compilation when `swiftc` is available
