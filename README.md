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
- `testdata/golden/minimal-endpoints/`: pinned parity snapshot for focused generated Swift output
- `scripts/get-lexicons.sh`: refreshes lexicon snapshots from upstream
- `scripts/check-swift-compile.sh`: typechecks generated Swift with `swiftc`
- `docs/`: focused documentation for CLI usage, GitHub Actions usage, and TOML configuration

## Installation

Requirements:

- Go 1.26+
- Swift 6.2+ if you want to run generated-code compilation checks

Install with Homebrew after the tap repository exists and a tagged release has published the formula:

```bash
brew install charliewilco/lexicodegen/lexicodegen
```

The Homebrew shorthand above expects a `charliewilco/homebrew-lexicodegen` tap repository. If you are working from an unreleased commit, use `go install` or build from source instead.

Install with Go:

```bash
go install github.com/charliewilco/lexicodegen/cmd/lexicodegen@v0.1.0
```

Build the CLI from source:

```bash
go build -o ./lexicodegen ./cmd/lexicodegen
```

Or run it directly from a checkout:

```bash
go run ./cmd/lexicodegen ./lexicons --output ./output/swift
```

## GitHub Actions

Use [`charliewilco/action-lexicodegen`](https://github.com/charliewilco/action-lexicodegen) when another repository needs Lexicodegen in CI.

Install the CLI and run it in a later step:

```yaml
- uses: charliewilco/action-lexicodegen@v1
  with:
    version: v0.1.0

- run: lexicodegen ./lexicons --output ./output/swift
```

Or install and run Lexicodegen in one step:

```yaml
- uses: charliewilco/action-lexicodegen/run@v1
  with:
    version: v0.1.0
    sources: ./lexicons
    output: ./output/swift
```

Pin the `version` input to an explicit Lexicodegen release tag so generated Swift changes are tied to an intentional generator upgrade. See [docs/github-actions.md](docs/github-actions.md) for more examples.

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

## Testing

The test suite is organized around generator regression safety:

- unit tests cover config, source loading, schema parsing, IR construction, and small utility behavior
- emitter behavior tests assert focused Swift snippets for generator contracts that should be easy to diagnose
- acceptance tests under `testdata/acceptance` run small lexicon suites through the CLI path, verify stable generated files and API snippets, and typecheck tiny Swift usage fixtures when `swiftc` is available
- the pinned golden snapshot under `testdata/golden/minimal-endpoints` catches generated-output drift against a stable fixture
- the generated Swift compile check verifies the full generated surface with `swiftc`

Run the default suite with:

```bash
go test ./...
```

Inspect statement coverage without enforcing a threshold:

```bash
just coverage
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
- `--help` / `-h`
- `--version`

Notes:

- `swift` is the only supported target
- `both` is accepted as a compatibility alias for `swift`
- unknown flags are rejected
- unknown targets are rejected
- `output.swiftFilePrefix` is currently config-only

To inspect the installed command without generating files:

```bash
lexicodegen --help
lexicodegen --version
```

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

Release tags are the installable version contract for downstream automation such as GitHub Actions. Prefer pinned SemVer tags such as `v0.1.0` over `latest` when another repository needs reproducible generation.

Release flow:

- create and push a semver tag such as `v0.1.0`
- GitHub Actions runs GoReleaser
- GoReleaser uploads release archives to GitHub Releases
- GoReleaser updates `Formula/lexicodegen.rb` in the `charliewilco/homebrew-lexicodegen` tap repository when `HOMEBREW_TAP_GITHUB_TOKEN` is configured

First release:

```bash
git tag -a v0.1.0 -m "Release v0.1.0"
git push origin v0.1.0
```

After the release workflow completes, verify the published binary:

```bash
lexicodegen --version
```

One-time setup:

- create the `charliewilco/homebrew-lexicodegen` tap repository with a `main` branch
- add a `HOMEBREW_TAP_GITHUB_TOKEN` repository secret that can write to the tap repository if Homebrew publishing should happen during release
- the release workflow uses the default `GITHUB_TOKEN` to publish this repository's GitHub Release
- GoReleaser uses `HOMEBREW_TAP_GITHUB_TOKEN` to publish the Homebrew formula to the tap repository; without that secret, the formula is generated locally in `dist/` and the tap upload is skipped

Local release validation:

```bash
goreleaser check
goreleaser release --snapshot --clean
```

If you later move the tap to a different repository, update the `brews[0].repository` values in `.goreleaser.yaml` and provide a token that can write to that repo.
