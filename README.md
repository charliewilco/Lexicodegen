# Lexicodegen

Generate Swift models and API client surface from AT Protocol lexicons using a Bun-based CLI.

If you come back to this repo after a long pause, this README is the source of truth for how the repo behaves today.

## Current build status

As of 2026-04-09, the primary local verification suite is green:

- `bun run build` passes and emits `dist/main.mjs`.
- `bun test` passes.
- `bun run typecheck` passes.
- `bunx biome check .` passes.
- `bun run verify:swift` regenerates `./output/swift` and typechecks the generated Swift with `swiftc`.

Treat `bun run verify:swift` as the clearest end-to-end generation signal, because it exercises the actual generated files instead of only validating emitter unit tests.

## Why this exists

`lexicon-openapi-generator` evolved from an OpenAPI-first implementation into a Swift-first workflow:

- Input is one or more lexicon sources: local files, HTTP JSON, or tarball archive URLs.
- Output is Swift code for:
	- model structs and enums
	- endpoint request and response types
	- subscription client methods backed by `AsyncThrowingStream`
	- shared helper files: `Models.swift` and `Endpoints.swift`
- Optional OpenAPI output is no longer part of the active path.

## Current output

- Generated Swift files are written to `output/swift` by default.
- Files are namespace-grouped, for example:
	- `AppBskyActor.generated.swift`
	- `AppBskyFeed.generated.swift`
- Shared helper files are emitted as:
	- `Models.swift`
	- `Endpoints.swift`

## Project layout

- `main.ts`: CLI entrypoint (`load config -> load lexicons -> build IR -> emit Swift`)
- `lib/config.ts`: argument and config parsing
- `lib/lexicon-loader.ts`: source loading (`local`, `http`, `git-archive`)
- `lib/lexicon-ir.ts`: namespace-agnostic intermediate representation
- `lib/emitter/swift.ts`: Swift code generation
- `lib/utils.ts`: reusable helpers and compatibility utilities
- `templates/swift/*.ejs`: EJS templates used by the emitter
- `lexicons/`: checked-in lexicon JSON inputs
- `output/swift/`: generated Swift output
- `scripts/get-lexicons.sh`: pulls the default upstream lexicon tarball
- `scripts/check-swift-compile.sh`: typechecks generated Swift with `swiftc`
- `.github/workflows/`: CI and daily regeneration automation

## Installation

```bash
bun install
```

## How to run the generator

The repo’s day-to-day entrypoint is the source file:

```bash
bun run ./main.ts ./lexicons --output ./output/swift
```

The package also declares a `lexicodegen` bin in `package.json`. If you install or link the package with Bun, that command resolves to `main.ts`.

```bash
bun link
lexicodegen ./lexicons --output ./output/swift
```

`bun run build` bundles `main.ts` to `dist/main.mjs` and is part of the verification pipeline, but the commands in this README use the source entrypoint because that is the path exercised by local development and project automation today.

There is currently no dedicated CLI `--help` output. Use the supported flags and examples below as the authoritative reference.

## Verify generated Swift

Use the dedicated verification command when you want a clear answer to whether the generated Swift compiles:

```bash
bun run verify:swift
```

or:

```bash
just verify-swift
```

If `output/swift` is already up to date and you only want to rerun the compiler check:

```bash
bun run check:swift
```

That runs `swiftc -typecheck` across every `.swift` file in `output/swift`.

## Usage

### Basic usage

Preferred local invocation:

```bash
bun run ./main.ts <source1> [source2 ...] [--source <source>] [--output <swift-output-dir>]
```

If the package has been linked or installed with Bun:

```bash
lexicodegen <source1> [source2 ...] [--source <source>] [--output <swift-output-dir>]
```

Examples:

```bash
bun run ./main.ts ./lexicons ./frontpage-lexicons --output ./output/swift
bun run ./main.ts ./lexicons https://example.com/namespace.json --output ./output/swift
bun run ./main.ts --source local:./leaflet --source https://example.com/namespace.json --output ./output/swift
```

### Source input types

- Local folder or file:
	- `./lexicons`
	- `local:./lexicons`
- HTTP URL:
	- `https://...` for a JSON lexicon document or JSON array of lexicon documents
- Git archive URL:
	- `git-archive:https://github.com/org/repo/archive/refs/heads/main.tar.gz`
	- `stripPath` can be set in config to narrow the extracted scan root

`branch` is accepted by the config type for `git-archive` sources but is not currently used during loading. Point `url` at the exact archive ref you want to fetch.

### `--source` and positional args

- Positional arguments are accepted as source entries.
- `--source` arguments are also accepted.
- Both are merged; `--source` entries are processed first, then positional sources.
- If no source is provided by flags or positionals, the default source `./lexicons` is used.

## Supported flags

Current CLI flags supported by `loadGeneratorConfig`:

| Flag | Type | Notes |
|---|---|---|
| `--config <path>` | string | JSON or TOML config file |
| `--source <path-or-url>` | string (repeatable) | Add explicit source |
| `--allow-prefix <prefix>` | string (repeatable) | Include only matching namespace prefixes |
| `--deny-prefix <prefix>` | string (repeatable) | Exclude matching namespace prefixes |
| `--deny-unspecced` | boolean | Skip unspecced defs |
| `--deny-deprecated` | boolean | Skip deprecated defs |
| `--output <dir>` | string | Alias for `--swift-output-dir` |
| `--swift-output-dir <dir>` | string | Swift output path |
| `--targets <target>` / `--target <target>` | string | Accepts `swift` or a comma-separated list |

Notes:

- `--targets` currently accepts only `swift`.
- `--targets=both` is treated as `swift` for compatibility.
- Unknown flags are currently ignored rather than rejected, so copy commands carefully.

## Config files (JSON / TOML)

Both config formats are supported:

- `--config path/to/config.json`
- `--config path/to/config.toml`

### Config keys

- `sources`: list of source objects
- `filters`: namespace and type filtering options
- `targets`: array, currently expected to be `["swift"]`
- `output.swiftOutDir`: generated Swift directory

### `sources` schema

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
	"url": "https://..."
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

### JSON example

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
		"allowPrefixes": ["app.bsky", "leaflet", "frontpage"],
		"denyPrefixes": ["com.atproto.lexicon.resolveLexicon"],
		"denyUnspecced": false,
		"denyDeprecated": false
	},
	"targets": ["swift"],
	"output": {
		"swiftOutDir": "./output/swift"
	}
}
```

### TOML example

```toml
targets = ["swift"]

[[sources]]
kind = "local"
path = "./lexicons"
recursive = true

[filters]
allowPrefixes = ["app.bsky", "leaflet", "frontpage"]
denyPrefixes = ["com.atproto.lexicon.resolveLexicon"]
denyUnspecced = false
denyDeprecated = false

[output]
swiftOutDir = "./output/swift"
```

### Config precedence

- CLI flags override config file values for:
	- output path
	- allow and deny prefix filters
	- `deny-unspecced` and `deny-deprecated`
- Source behavior:
	- if any CLI source is provided (`--source` or positional), config and default `sources` are ignored
	- otherwise config or default sources are used
- Targets default to `["swift"]` if nothing is specified

## Supported lexicon definitions

- `query` -> HTTP GET endpoint path under `/xrpc/{lexicon.id}`
- `procedure` -> HTTP POST endpoint path under `/xrpc/{lexicon.id}`
- `subscription` -> streaming endpoint surface in Swift
- `object`, `record`, `array`, `string`, `token`
- `permission-set`
- `union` with a generated `.unknown` fallback

## Everyday commands

### Primary commands

```bash
# list tasks
just help

# run unit tests
bun test

# typecheck + lint/check
bun run typecheck
bunx biome check .

# bundle the CLI
bun run build

# generate from the default local lexicon directory
bun run ./main.ts ./lexicons --output ./output/swift

# regenerate Swift and typecheck the generated output
bun run verify:swift
```

### Just recipes

```bash
just help
just generate
just regenerate
just lexicons
just test
just ci
just swift-check
just verify-swift
just all
```

- `just generate`: runs `bun ./main.ts ./lexicons --output ./output/swift`
- `just regenerate`: refreshes `lexicons/` via `just lexicons`, then regenerates output
- `just lexicons`: pulls default lexicons via `scripts/get-lexicons.sh`
- `just test`: runs the Bun test suite
- `just ci`: runs typecheck, Biome, tests, and build
- `just swift-check`: runs `bun run check:swift`
- `just verify-swift`: regenerates Swift output and typechecks it with `swiftc`
- `just all`: refreshes lexicons, regenerates output, then formats the repo

Current state:

- `bun run build` passes
- `just test` passes
- `just ci` passes
- `just verify-swift` passes when `swiftc` is available on `PATH`

## CI / CD

GitHub Actions is configured for automated checks:

- `.github/workflows/ci.yml`
	- `bun install --frozen-lockfile`
	- `bunx tsc --noEmit`
	- `bunx biome check .`
	- `bun test`
	- `bun run build`
	- `bun run generate`
	- `bun run check:swift`
- `.github/workflows/daily-regenerate.yml`
	- scheduled and manual trigger
	- runs `just all`
	- opens a regeneration PR when changes are detected

Current state:

- The CI workflow reflects the intended verification pipeline.
- CI runs the same local JS/Bun checks plus explicit Swift regeneration and typechecking: `bun run typecheck`, `bunx biome check .`, `bun test`, `bun run build`, and `bun run verify:swift`.

## Troubleshooting

- `Could not load source`:
	- verify the source path or URL is reachable and the payload is valid lexicon JSON
- Empty generation:
	- check filters: `--allow-prefix`, `--deny-prefix`, `--deny-unspecced`, `--deny-deprecated`
- Unexpected file names:
	- filenames are namespace-derived and grouped by generated naming in the output directory
- Tarball source not loading:
	- confirm the URL serves a valid tarball and that lexicon JSON files exist at the extracted path

## Notes

- `scripts/get-lexicons.sh` is currently Bluesky-oriented and still uses `bluesky-social/atproto` defaults
- For non-Bluesky feeds, prefer explicit `--source` entries or config `sources`
- Source handling and output generation defaults are intentionally namespace-agnostic

## License

This project is released under the Unlicense. See `UNLICENSE`.
