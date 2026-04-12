# Repository Guidelines

## Project Structure & Module Organization
- `cmd/lexicodegen/main.go`: CLI entrypoint (`load -> IR -> target emitters`) for Swift generation.
- `internal/config`: CLI/config parsing, defaults, normalization, and validation.
- `internal/source`: source loading (`local`, `http`, `git-archive`) and filtering.
- `internal/schema`: raw normalized schema model plus Indigo-backed lexicon validation.
- `internal/ir`: namespace-agnostic intermediate representation (IR).
- `internal/swiftgen`: Swift emitter (primary output for model workflows).
- `internal/util`: shared helpers and endpoint checks.
- `lexicons/`: source lexicon JSON files (fetched/updated from upstream or configured sources).
- `output/swift/`: generated Swift artifacts.
- `testdata/golden/full/`: golden-output parity snapshot for generated Swift.
- `scripts/get-lexicons.sh`: pulls lexicon files used as generation input.

## Build, Test, and Development Commands
- `just help`: list available project tasks.
- `go test ./...`: run the Go test suite, including golden-output parity checks.
- `go build -o ./lexicodegen ./cmd/lexicodegen`: build the CLI binary.
- `gofmt -w ./cmd ./internal`: format Go sources.
- `just format`: run `gofmt` on source files.
- `just lint`: verify Go formatting is clean.
- `just lexicons`: refresh local lexicon snapshots.
- `just generate`: regenerate Swift models from local lexicons.
- Current baseline as of `2026-04-11`:
  - `go test ./...` passes.
  - `go build -o ./lexicodegen ./cmd/lexicodegen` passes.
  - `./lexicodegen ./lexicons --output ./output/swift` passes.
  - `bash ./scripts/check-swift-compile.sh ./output/swift` passes when `swiftc` is available on PATH.
- Optional checks:
  - `test -z "$(gofmt -l ./cmd ./internal)"` for formatting verification.
  - `go test ./...` for regression coverage.
  - `bash ./scripts/check-swift-compile.sh ./output/swift` for generated Swift compilation.

## Coding Style & Naming Conventions
- Language: Go for generator logic, generated output in Swift.
- Formatting: `gofmt`, with tabs as the Go standard formatter emits.
- Keep generator modules focused by concern (`config`, `source`, `schema`, `ir`, `swiftgen`).
- Use descriptive camelCase / PascalCase names consistent with Go conventions and keep package names lowercase.
- Avoid broad refactors when making generator-specific fixes; keep changes narrow and reviewable.

## Testing Guidelines
- Unit tests use Go’s built-in test runner under `internal/**`.
- Validate feature changes by running:
  1. `go test ./...`
  2. `go build -o ./lexicodegen ./cmd/lexicodegen`
  3. `./lexicodegen ./lexicons --output ./output/swift`
  4. `bash ./scripts/check-swift-compile.sh ./output/swift`
- Repository status note:
  - The baseline is green as of `2026-04-11`, but rerun the relevant checks instead of assuming it stayed green.
  - If your change is documentation-only, you can skip checks; otherwise, report exactly what you ran.
- For end-to-end generation checks:
  1. `./lexicodegen ./lexicons --output ./output/swift`
  2. `bash ./scripts/check-swift-compile.sh ./output/swift`
- For feature work, include at least one concrete verification example in the PR description (e.g., a generated schema path).

## Commit & Pull Request Guidelines
- Follow conventional-style prefixes used in history: `fix:`, `chore:`, `refactor:`.
- Keep commits scoped to one concern (e.g., `fix: convert permission-set definitions`).
- PRs should include:
  - what changed and why,
  - commands run for validation,
  - notable output diffs (paths or schema IDs),
  - linked issue/context when applicable.
