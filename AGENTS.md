# Repository Guidelines

## Project Structure & Module Organization
- `main.ts`: entrypoint that scans `lexicons/` and generates OpenAPI output.
- `lib/converters/`: schema and endpoint conversion logic (`array.ts`, `object.ts`, `query.ts`, `procedure.ts`, etc.).
- `lib/utils.ts`: shared helpers for lexicon loading and tag calculation.
- `lexicons/`: source lexicon JSON files (fetched/updated from upstream).
- `output/`: generated artifacts (`openapi.json`, optional `openapi.yaml`).
- `scripts/get-lexicons.sh`: pulls lexicon files used as generation input.

## Build, Test, and Development Commands
- `bun install`: install dependencies.
- `just help`: list available project tasks.
- `just format`: run Biome formatting on source and generated files.
- `just lexicons`: refresh local lexicon snapshots.
- `just generate`: refresh lexicons, then regenerate OpenAPI JSON.
- `bun run dev`: run generator in watch mode during converter changes.
- Optional checks:
  - `bunx biome check .` for lint/style checks.
  - `bunx tsc --noEmit` for type-checking (note: current repo has some pre-existing TS issues).

## Coding Style & Naming Conventions
- Language: TypeScript (ESM, strict mode).
- Formatting: Biome (`biome.json`) with tab indentation and double quotes.
- Keep converter modules focused by lexicon/openapi concern (one converter per schema family).
- Use descriptive camelCase function/variable names; keep file names lowercase (`query.ts`, `record.ts`).
- Avoid broad refactors when making generator-specific fixes; keep changes narrow and reviewable.

## Testing Guidelines
- There is no formal test suite yet.
- Validate changes by running:
  1. `just generate`
  2. `just format`
  3. spot-checking `output/openapi.json` for expected schema/endpoint changes.
- For feature work, include at least one concrete verification example in the PR description (e.g., a generated schema path).

## Commit & Pull Request Guidelines
- Follow conventional-style prefixes used in history: `fix:`, `chore:`, `refactor:`.
- Keep commits scoped to one concern (e.g., `fix: convert permission-set definitions`).
- PRs should include:
  - what changed and why,
  - commands run for validation,
  - notable output diffs (paths or schema IDs),
  - linked issue/context when applicable.
