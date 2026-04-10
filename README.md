# Lexicodegen

Generate Swift `Codable` models and API client stubs from AT Protocol lexicons using a CLI-first Bun toolchain.

If you come back to this repo after a long pause, this README is the “single source of truth” for how to run, configure, and maintain the project.

## Current build status

As of 2026-04-09, the primary local verification suite is green:

- `bun run build` passes and emits `dist/main.mjs`.
- `bun test` passes.
- `bun run typecheck` passes.
- `bunx biome check .` passes.
- `bun run verify:swift` regenerates `./output/swift` and typechecks all generated Swift with `swiftc`.

Treat `bun run verify:swift` as the clearest Swift generation signal, because it exercises the actual generated files instead of only validating emitter unit tests.

## Why this exists

`lexicon-openapi-generator` evolved from an OpenAPI-first implementation into a **Swift-first** workflow:

- Input is one or more lexicon sources (local files, HTTP, or tarball archive URLs).
- Output is Swift code for:
  - model structs/enums that conform to `Codable`
  - endpoint request/response types
  - central `Endpoints.swift` and `Models.swift` helper files
- Optional OpenAPI output was intentionally removed from the active path.

## Current output

- `output/` contains generated Swift files by default.
- Filenames are namespace-grouped, e.g.:
  - `AppBskyActor.generated.swift`
  - `AppBskyFeed.generated.swift`
- Shared helper files are generated as:
  - `Models.swift`
  - `Endpoints.swift`

## Project layout

- `main.ts`: CLI entrypoint (`load config -> load lexicons -> build IR -> emit Swift`)
- `lib/config.ts`: argument + config parsing
- `lib/lexicon-loader.ts`: source loading (`local`, `http`, `git-archive`)
- `lib/lexicon-ir.ts`: namespace-agnostic intermediate representation
- `lib/emitter/swift.ts`: Swift code generation
- `templates/swift/*.ejs`: EJS templates used by the emitter
- `lib/utils.ts`: reusable helpers, filtering helpers, and compatibility utilities
- `lexicons/`: checked-in lexicon JSON inputs
- `output/`: generated Swift output
- `.github/workflows/`: CI and daily regeneration automation
- `scripts/get-lexicons.sh`: pulls the default Bluesky lexicon tarball

## Installation

```bash
bun install
```

## Build the binary

```bash
bun run build
```

This compiles a single-file executable at:

```bash
./dist/main.mjs
```

Current state: this command passes.

## Install executable globally

If you want `lexicodegen` available from any terminal session, install the package globally after building the binary:

```bash
bun run build
bun install -g .
```

Verify:

```bash
lexicodegen --help
```

For local development, you can also use `bun link`:

```bash
bun link
lexicodegen ./lexicons --output ./output/swift
```

Notes:

- `bun install -g .` expects an executable at `./lexicodegen` in the installed package.
- Re-run `bun run build` and re-install globally when the CLI behavior changes.

## Development mode

You can run the generator directly from source:

```bash
bun run ./main.ts ./lexicons --output ./output/swift
```

## Verify generated Swift

Use the dedicated verification command when you want a clear answer to whether the generated Swift actually compiles:

```bash
bun run verify:swift
```

or:

```bash
just verify-swift
```

If `./output/swift` is already up to date and you only want to rerun the compiler check, use:

```bash
bun run check:swift
```

This runs `swiftc -typecheck` across every `.swift` file in `./output/swift`.

## Usage

### Basic usage

```bash
./lexicodegen <source1> [source2 ...] [--source <source>] [--output <swift-output-dir>]
```

Examples:

```bash
./lexicodegen ./lexicons ./frontpage-lexicons --output ./output/swift
./lexicodegen ./lexicons https://example.com/lexicons.tar.gz --output ./output/swift
./lexicodegen --source local:./leaflet --source https://example.com/namespace.json --output ./output/swift
```

### Source input types

- local folder/files:
  - `./lexicons`
  - `local:./lexicons`
- HTTP URL:
  - `https://...` (raw JSON or JSON array expected)
- Git archive URL (prefixed path convention):
  - `git-archive:https://github.com/org/repo/archive/refs/heads/main.tar.gz`
  - Optionally set `stripPath` and `branch` in config for archive handling

### `--source` and positional args

- Positional arguments are accepted as source entries.
- `--source` arguments are accepted as well.
- Both are merged; `--source` entries are processed first, then positional sources.
- If no source is provided by flags/positionals, the config/default source `./lexicons` is used.

## Supported flags

Current CLI flags supported by `loadGeneratorConfig`:

| Flag | Type | Notes |
|---|---|---|
| `--config <path>` | string | JSON or TOML config file. |
| `--source <path-or-url>` | string (repeatable) | Add explicit source. |
| `--allow-prefix <prefix>` | string (repeatable) | Include only matching namespace prefixes. |
| `--deny-prefix <prefix>` | string (repeatable) | Exclude matching namespace prefixes. |
| `--deny-unspecced` | boolean | Skip unspecced defs. |
| `--deny-deprecated` | boolean | Skip deprecated defs. |
| `--output <dir>` | string | Sets Swift output path. Alias for `--swift-output-dir`. |
| `--swift-output-dir <dir>` | string | Swift output path. |
| `--targets <target>` / `--target <target>` | string | Accepts `swift` or comma-separated list. |

Notes:

- `--targets` currently accepts only `"swift"` today.
- `--targets=both` is treated as `swift` for compatibility.
- Source and target names are case-insensitive.

## Config files (JSON / TOML)

Both config formats are supported:

- `--config path/to/config.json`
- `--config path/to/config.toml`

### Config keys

- `sources`: list of source objects
- `filters`: namespace/type filtering options
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
  "stripPath": "some/subfolder",
  "branch": "main"
}
```

`stripPath` and `branch` are used during archive extraction.

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
[[sources]]
kind = "local"
path = "./lexicons"
recursive = true

[filters]
allowPrefixes = ["app.bsky", "leaflet", "frontpage"]
denyPrefixes = ["com.atproto.lexicon.resolveLexicon"]
denyUnspecced = false
denyDeprecated = false

targets = ["swift"]

[output]
swiftOutDir = "./output/swift"
```

### Config precedence

- CLI flags override config file values for:
  - output path
  - allow/deny prefix filters
  - deny-unspecced/deny-deprecated toggles
- Source behavior:
  - if any CLI source is provided (`--source` or positional), config/default `sources` are ignored.
  - otherwise config/default sources are used.
- Targets default to `["swift"]` if nothing is specified.

## Supported lexicon definitions

- `query` -> HTTP GET endpoint path under `/xrpc/{lexicon.id}`
- `procedure` -> HTTP POST endpoint path under `/xrpc/{lexicon.id}`
- `object`, `record`, `array`, `string`, `token`
- `permission-set`
- `union` (mapped to Swift enum with `.unknown` fallback)
- `subscription` defs are intentionally skipped (non-HTTP protocol semantics)

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

# build one-file executable
bun run build

# generate directly from local/default source
./lexicodegen ./lexicons --output ./output/swift
```

### Just recipes

```bash
just help
just generate
just regenerate
just lexicons
just test
just ci
just verify-swift
```

- `just generate`: runs the built executable on the local `./lexicons` input
- `just regenerate`: refreshes `./lexicons` (via `just lexicons`) and regenerates output
- `just lexicons`: pulls default lexicons via `scripts/get-lexicons.sh`
- `just test`: runs Bun test suite
- `just ci`: runs typecheck + lint + tests + build
- `just verify-swift`: regenerates Swift output and typechecks it with `swiftc`

Current state:

- `just build` equivalent (`bun run build`) passes
- `just test` passes
- `just ci` passes
- `just verify-swift` passes when `swiftc` is available on PATH

## CI / CD

GitHub Actions is configured for automated checks:

- `.github/workflows/ci.yml`
  - Typecheck
  - Biome checks
  - Bun tests
  - Compile executable
  - Generate Swift output
  - Typecheck generated Swift with `swiftc`
- `.github/workflows/daily-regenerate.yml`
  - Scheduled + manual trigger
  - Runs `just all` and opens a regeneration PR when changes are detected

Current state:

- The CI workflow reflects the intended verification pipeline.
- The workflow is expected to match the local green verification path: `bun run typecheck`, `bunx biome check .`, `bun test`, `bun run build`, and `bun run verify:swift`.

## Troubleshooting

- `Could not load source`:
  - verify source path/url is reachable and JSON lexicon shape is valid.
- Empty generation:
  - check filters (`--allow-prefix`, `--deny-prefix`, `--deny-unspecced`, `--deny-deprecated`).
- Unexpected file names:
  - filenames are namespace-derived and grouped by generated naming in output directory.
- Tarball source not loading:
  - confirm the URL serves a valid tarball and that lexicon JSON files exist at extracted path.

## Notes

- `scripts/get-lexicons.sh` is currently Bluesky-oriented and still uses `bluesky-social/atproto` defaults.
- For non-Bluesky feeds (Leaflet / Frontpage / Teal.fm), prefer `--source` or config `sources` entries.
- Source handling and output generation defaults are intentionally namespace-agnostic.
