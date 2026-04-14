# Lexicodegen

Generate Swift models and XRPC client surface from AT Protocol lexicons with a single Go CLI.

Implementation notes:

- lexicon parsing and validation use [Indigo](https://github.com/bluesky-social/indigo)
- config, source loading, IR building, and Swift emission are repo-owned Go code
- the generated output target is Swift

## Current Output

- Generated Swift files are written to `output/swift` by default.
- Files are namespace-grouped, for example:
	- `AppBskyActor.generated.swift`
	- `AppBskyFeed.generated.swift`
- Shared helper files are emitted as:
	- `Models.swift`
	- `Endpoints.swift`
- `output.swiftFilePrefix` can prepend every generated Swift filename, for example `Generated_Models.swift`.

## Project Layout

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

Install with Homebrew:

```bash
brew install charliewilco/tap/lexicodegen
```

Install with Go:

```bash
go install github.com/charliewilco/lexicodegen/cmd/lexicodegen@latest
```

Build the CLI from source:

```bash
go build -o ./lexicodegen ./cmd/lexicodegen
```

Or run it directly from a checkout:

```bash
go run ./cmd/lexicodegen ./lexicons --output ./output/swift
```

## Git Hooks

Lefthook is configured as a project-local Go tool and tracked in `go.mod`. The repo config lives in `lefthook.toml`.

Install the hooks with:

```bash
go tool github.com/evilmartians/lefthook/v2 install
```

Or use the repo helper:

```bash
just hooks-install
```

Configured hooks:

- `pre-commit`: run `gofmt -w` on staged Go files and restage fixes
- `pre-push`: run `go test ./...`

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
- `output.swiftFilePrefix` is currently config-only

## Config Files

JSON and TOML config files are supported:

```bash
go run ./cmd/lexicodegen --config ./lexicodegen.toml
go run ./cmd/lexicodegen --config ./lexicodegen.json
```

### Config Shape

| Key | Type | Default | Notes |
|---|---|---|---|
| `sources` | `LexiconSource[]` | `[{ kind: "local", path: "./lexicons", recursive: true }]` | Replaced entirely if any CLI source is provided |
| `filters.allowPrefixes` | `string[]` | `[]` | Keep only matching lexicon IDs |
| `filters.denyPrefixes` | `string[]` | `[]` | Exclude matching lexicon IDs |
| `filters.denyUnspecced` | `boolean` | `false` | Skip unspecced defs |
| `filters.denyDeprecated` | `boolean` | `false` | Skip deprecated defs |
| `targets` | `string[]` | `["swift"]` | Swift is the only supported target |
| `output.swiftOutDir` | `string` | `"./output/swift"` | Resolved relative to the current working directory |
| `output.swiftFilePrefix` | `string` | `""` | Prepends every generated Swift filename; path separators are rejected |

This repo already supports filter prefixes in config via `filters.allowPrefixes` and `filters.denyPrefixes`. `output.swiftFilePrefix` is separate: it changes generated filenames, not lexicon filtering.

### `sources` Schema

Each source is one of:

- Local source:

```json
{
	"kind": "local",
	"path": "./lexicons",
	"recursive": true
}
```

- HTTP source:

```json
{
	"kind": "http",
	"url": "https://example.com/lexicons.json"
}
```

- Git archive source:

```json
{
	"kind": "git-archive",
	"url": "https://github.com/org/repo/archive/refs/heads/main.tar.gz",
	"stripPath": "some/subfolder"
}
```

`stripPath` is used during archive extraction. If you need a specific branch or tag, point `url` at the archive for that ref directly.

### JSON Example

```json
{
	"sources": [
		{
			"kind": "local",
			"path": "./lexicons",
			"recursive": true
		}
	],
	"filters": {
		"allowPrefixes": ["app.bsky", "frontpage"],
		"denyPrefixes": ["com.atproto.lexicon.resolveLexicon"],
		"denyUnspecced": false,
		"denyDeprecated": false
	},
	"targets": ["swift"],
	"output": {
		"swiftOutDir": "./output/swift",
		"swiftFilePrefix": "Generated_"
	}
}
```

### TOML Example

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
swiftFilePrefix = "Generated_"
```

`output.swiftFilePrefix` is applied verbatim. If you want a separator, include it yourself, for example `Generated_` or `ATProto`.

### Precedence

Merge behavior is intentionally simple:

- CLI sources replace config-file sources when any positional source or `--source` is provided
- CLI filter flags override config filters individually
- `--output` and `--swift-output-dir` override `output.swiftOutDir`
- `output.swiftFilePrefix` comes from config only
- resolved local paths are normalized relative to the current working directory

## Development

Common commands:

- `just build`
- `just test`
- `just lint`
- `just generate`
- `just verify-swift`
- `just all`

Primary verification flow:

- `go test ./...`
- `go build -o ./lexicodegen ./cmd/lexicodegen`
- `go run ./cmd/lexicodegen ./lexicons --output ./output/swift`
- `bash ./scripts/check-swift-compile.sh ./output/swift`

## Releases

Tagged releases are published with GoReleaser via `.github/workflows/release.yml`.

Release flow:

- create and push a semver tag such as `v0.1.0`
- GitHub Actions runs GoReleaser
- GoReleaser uploads release archives to GitHub Releases
- GoReleaser updates `charliewilco/homebrew-tap` with `Formula/lexicodegen.rb`

One-time setup:

- create the tap repository `charliewilco/homebrew-tap`
- add a repository secret named `HOMEBREW_TAP_GITHUB_TOKEN`
- the token should be a GitHub personal access token with `contents: write` access to the tap repository
- the release workflow uses the default `GITHUB_TOKEN` for this repository and `HOMEBREW_TAP_GITHUB_TOKEN` only for cross-repo tap updates

Local release validation:

```bash
goreleaser check
goreleaser release --snapshot --clean
```

If you publish to a different tap repository, update the `brews[0].repository` values in `.goreleaser.yaml`.
