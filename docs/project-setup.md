# Project Setup

This document shows how to use `lexicodegen` from another project without depending on this repository layout.

## Recommended Setup

Keep three things in your app repository:

- the `lexicodegen` binary installed on your machine or in CI
- a committed config file such as `lexicodegen.toml`
- a stable lexicon source, either checked into your repo or fetched from a pinned archive URL

That gives you a reproducible generation command instead of a one-off terminal incantation.

## Install the CLI

Use Homebrew after tagged releases are available:

```bash
brew tap charliewilco/lexicodegen
brew install lexicodegen
```

Or install the latest Go-based CLI directly:

```bash
go install github.com/charliewilco/lexicodegen/cmd/lexicodegen@latest
```

If you want to use an unreleased commit, build from a checkout and put the binary on your `PATH` yourself.

## Example App Layout

```text
MyApp/
├── justfile
├── lexicodegen.toml
├── Scripts/
├── Vendor/
│   └── ATProtoLexicons/
└── Sources/
    └── Generated/
        └── ATProto/
```

One reasonable convention is:

- store raw lexicons under `Vendor/ATProtoLexicons`
- write generated Swift under `Sources/Generated/ATProto`
- commit `lexicodegen.toml` so the generation shape is reviewable

## Example Config

Create `lexicodegen.toml` in your project root:

```toml
[[sources]]
kind = "local"
path = "./Vendor/ATProtoLexicons"
recursive = true

[filters]
allowPrefixes = ["app.bsky", "com.atproto"]
denyPrefixes = []
denyUnspecced = false
denyDeprecated = false

targets = ["swift"]

[output]
swiftOutDir = "./Sources/Generated/ATProto"
swiftFilePrefix = ""
```

Then run:

```bash
lexicodegen --config ./lexicodegen.toml
```

## Using a Git Archive Source

If you do not want to check lexicons into your project, point the config at a tarball URL instead:

```toml
[[sources]]
kind = "git-archive"
url = "https://github.com/bluesky-social/atproto/archive/refs/heads/main.tar.gz"
stripPath = "atproto-main/lexicons"

targets = ["swift"]

[output]
swiftOutDir = "./Sources/Generated/ATProto"
swiftFilePrefix = ""
```

That is convenient, but less stable than vendoring lexicons or pinning a release/tag archive URL.

## Add a Project Command

In your app repo's `justfile`, add a small wrapper so generation is easy to remember:

```just
generate-atproto:
	lexicodegen --config ./lexicodegen.toml
```

If you also want a local verification step for generated Swift:

```just
generate-atproto:
	lexicodegen --config ./lexicodegen.toml

verify-atproto:
	lexicodegen --config ./lexicodegen.toml
	swiftc -typecheck Sources/Generated/ATProto/*.swift
```

## Important Path Rule

Config paths such as `sources.path` and `output.swiftOutDir` are resolved relative to the current working directory where you run `lexicodegen`, not relative to the config file location.

In practice, that means the safest habit is to run the command from your project root:

```bash
cd MyApp
lexicodegen --config ./lexicodegen.toml
```

## Typical Workflow

1. update lexicons in your project or bump the archive URL
2. run `lexicodegen --config ./lexicodegen.toml`
3. review the generated Swift diff
4. build or typecheck your app

For flag-level details, see [docs/cli-usage.md](/Users/charliewilco/Developer/Burton/Lexicodegen/docs/cli-usage.md:1) and [docs/toml-config.md](/Users/charliewilco/Developer/Burton/Lexicodegen/docs/toml-config.md:1).
