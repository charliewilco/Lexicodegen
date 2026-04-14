# TOML Configuration

This document focuses on writing `lexicodegen` configuration files in TOML format.

## Load a TOML Config

```bash
./lexicodegen --config ./lexicodegen.toml
```

Config paths are resolved relative to the current working directory when the command is run.

## Full TOML Example

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

## Top-Level Keys

| Key | Type | Default | Notes |
|---|---|---|---|
| `sources` | `[]LexiconSource` | one local source at `./lexicons` | Replaced by CLI sources when provided |
| `filters` | `GenerationFilter` | empty allow/deny, booleans false | Can be overridden by filter flags |
| `targets` | `[]string` | `["swift"]` | Only `swift` is currently supported |
| `output` | `OutputConfig` | `swiftOutDir = "./output/swift"`, empty prefix | `swiftFilePrefix` is config-only |

## `sources` Entries

Each `[[sources]]` table must set `kind` to one of:

- `"local"` requires `path`
- `"http"` requires `url`
- `"git-archive"` requires `url`

Optional source fields:

- `recursive` (used for local sources; defaults to `true`)
- `stripPath` (used for git archive extraction)
- `branch` (accepted by schema; optional)

Examples:

```toml
[[sources]]
kind = "local"
path = "./lexicons"
recursive = true
```

```toml
[[sources]]
kind = "http"
url = "https://example.com/lexicons.json"
```

```toml
[[sources]]
kind = "git-archive"
url = "https://github.com/org/repo/archive/refs/heads/main.tar.gz"
stripPath = "lexicons"
```

## `filters` Table

```toml
[filters]
allowPrefixes = ["app.bsky"]
denyPrefixes = ["app.bsky.graph"]
denyUnspecced = true
denyDeprecated = true
```

Semantics:

- `allowPrefixes`: include only matching lexicon IDs.
- `denyPrefixes`: exclude matching lexicon IDs.
- `denyUnspecced`: skip unspecced definitions.
- `denyDeprecated`: skip deprecated definitions.

## `targets`

```toml
targets = ["swift"]
```

Notes:

- `"both"` is accepted as an alias for `"swift"`.
- Any unsupported target value will fail validation.

## `output` Table

```toml
[output]
swiftOutDir = "./output/swift"
swiftFilePrefix = "Generated_"
```

- `swiftOutDir` is resolved relative to the command's working directory.
- `swiftFilePrefix` is prepended to generated Swift filenames.
- `swiftFilePrefix` cannot contain path separators (`/` or `\`).

## CLI Override Rules

If you pass corresponding flags, these config values are overridden:

- `sources` overridden by positional sources or `--source`
- `filters.allowPrefixes` overridden by `--allow-prefix`
- `filters.denyPrefixes` overridden by `--deny-prefix`
- `filters.denyUnspecced` overridden by `--deny-unspecced`
- `filters.denyDeprecated` overridden by `--deny-deprecated`
- `output.swiftOutDir` overridden by `--output` or `--swift-output-dir`

`output.swiftFilePrefix` remains config-only.
