# GitHub Actions

Use [`charliewilco/action-lexicodegen`](https://github.com/charliewilco/action-lexicodegen) when a repository needs to install or run Lexicodegen in GitHub Actions.

The action version and the Lexicodegen version are separate:

- `charliewilco/action-lexicodegen@v1` pins the action interface.
- `version: v0.1.0` pins the Lexicodegen CLI release used to generate Swift.

Pinning the CLI version is recommended. It makes generated Swift diffs reproducible and turns generator upgrades into intentional pull requests.

## Install Lexicodegen

Use the root action when a workflow needs `lexicodegen` on `PATH` for later steps:

```yaml
jobs:
  generate:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - uses: charliewilco/action-lexicodegen@v1
        with:
          version: v0.1.0

      - run: lexicodegen ./lexicons --output ./output/swift
```

## Install and Run Lexicodegen

Use the `/run` action when a workflow should install and invoke Lexicodegen in one step:

```yaml
jobs:
  generate:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - uses: charliewilco/action-lexicodegen/run@v1
        with:
          version: v0.1.0
          sources: ./lexicons
          output: ./output/swift
```

Multiple sources can be passed as newline-separated input:

```yaml
- uses: charliewilco/action-lexicodegen/run@v1
  with:
    version: v0.1.0
    sources: |
      ./lexicons
      git-archive:https://github.com/example/lexicons/archive/refs/heads/main.tar.gz
    output: ./output/swift
```

## Config Files

When a repository has a checked-in Lexicodegen config file, prefer passing the config path:

```yaml
- uses: charliewilco/action-lexicodegen/run@v1
  with:
    version: v0.1.0
    config: ./lexicodegen.toml
```

If `config` is set, the run action invokes:

```bash
lexicodegen --config ./lexicodegen.toml
```

The `sources` and `output` inputs are ignored in config mode because the config file owns those settings.

## Extra Arguments

Use `extra-args` for additional CLI flags such as prefix filters:

```yaml
- uses: charliewilco/action-lexicodegen/run@v1
  with:
    version: v0.1.0
    sources: ./lexicons
    output: ./output/swift
    extra-args: --allow-prefix app.bsky --deny-deprecated
```

For more complex command construction, use the install action and run `lexicodegen` directly in a shell step.

## Generated Output Checks

A common downstream workflow is to regenerate Swift, then fail if the checked-in generated output changed:

```yaml
jobs:
  generated-swift:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - uses: charliewilco/action-lexicodegen/run@v1
        with:
          version: v0.1.0
          config: ./lexicodegen.toml

      - run: git diff --exit-code
```

Use `macos-latest` if the workflow also typechecks generated Swift with Apple toolchains. The installer itself supports Linux and macOS runners for `amd64` and `arm64`.
