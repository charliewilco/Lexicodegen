# Repository Guidelines

## Project Structure & Module Organization
- `main.ts`: entrypoint (`load -> IR -> target emitters`) for Swift generation.
- `lib/lexicon-ir.ts`: namespace-agnostic intermediate representation (IR).
- `lib/lexicon-loader.ts`: source loading (`local`, `http`, `git-archive`) and filtering.
- `lib/config.ts`: CLI/config parsing and defaults.
- `lib/emitter/swift.ts`: Swift emitter (primary output for model workflows).
- `lib/utils.ts`: shared helpers for tag calculation and legacy compatibility checks.
- `lexicons/`: source lexicon JSON files (fetched/updated from upstream or configured sources).
- `output/`: generated artifacts (`swift/*.generated.swift`, etc.).
- `scripts/get-lexicons.sh`: pulls lexicon files used as generation input.

## Build, Test, and Development Commands
- `bun install`: install dependencies.
- `just help`: list available project tasks.
- `bun test`: run Bun unit tests.
- `bun run typecheck`: typecheck TypeScript with `tsgo` (`@typescript/native-preview`).
- `bunx biome check .`: validate format/lint.
- `just format`: run Biome formatting on source and generated files.
- `just lexicons`: refresh local lexicon snapshots.
- `just generate`: refresh lexicons, then regenerate Swift models.
- `bun run dev`: run generator in watch mode during converter changes.
- Current baseline as of `2026-04-09`:
  - `bun run build` passes.
  - `bun test` passes.
  - `bun run typecheck` passes.
  - `bunx biome check .` passes.
  - `bun run verify:swift` passes when `swiftc` is available on PATH.
- Optional checks:
  - `bunx biome check .` for lint/style checks.
  - `bun run typecheck` for type-checking.
  - `bun test` for regression coverage.
  - `bunx biome format --write .` for formatting after generated file updates.

## Coding Style & Naming Conventions
- Language: TypeScript (ESM, strict mode).
- Formatting: Biome (`biome.json`) with tab indentation and double quotes.
- Keep converter modules focused by lexicon concern (one converter per schema family).
- Use descriptive camelCase function/variable names; keep file names lowercase (`query.ts`, `record.ts`).
- Avoid broad refactors when making generator-specific fixes; keep changes narrow and reviewable.

## Testing Guidelines
- Unit tests use Bun’s built-in test runner with files under `test/*.test.ts`.
- Validate feature changes by running:
  1. `bun test`
  2. `bun run typecheck`
  3. `bunx biome check .`
  4. `bun run build`
- Repository status note:
  - The baseline is green as of `2026-04-09`, but rerun the relevant checks instead of assuming it stayed green.
  - If your change is documentation-only, you can skip checks; otherwise, report exactly what you ran.
- For end-to-end generation checks:
  1. `./lexicodegen ./lexicons --output ./output/swift`
  2. `bunx biome format --write .` if formatting changed
- For feature work, include at least one concrete verification example in the PR description (e.g., a generated schema path).

## Commit & Pull Request Guidelines
- Follow conventional-style prefixes used in history: `fix:`, `chore:`, `refactor:`.
- Keep commits scoped to one concern (e.g., `fix: convert permission-set definitions`).
- PRs should include:
  - what changed and why,
  - commands run for validation,
  - notable output diffs (paths or schema IDs),
  - linked issue/context when applicable.
