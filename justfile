# Show available recipes.
help:
	@just --list

build:
	bun build ./main.ts --target bun --outfile ./dist/main.mjs

# Run TypeScript type-checking.
typecheck:
	bunx tsc --noEmit

# Format generated Swift files, lexicon JSON files, and TypeScript sources.
format:
	bunx biome format --write .

# Run Biome checks without writing.
lint:
	bunx biome check .

# Refresh lexicon JSON files from upstream sources.
lexicons:
	sh ./scripts/get-lexicons.sh

test:
	bun test

test-ci:
	bun test --coverage

ci:
	just typecheck
	just lint
	bun test
	bun run build

# Generate from installed executable and current local lexicons.
generate:
	bun ./main.ts ./lexicons --output ./output/swift

# Typecheck generated Swift output with swiftc.
swift-check:
	bun run check:swift

# Regenerate Swift output, then typecheck it with swiftc.
verify-swift:
	bun run verify:swift

# Refresh upstream lexicons, then regenerate.
regenerate: lexicons generate

# Run full generation flow, then format all tracked artifacts.
all: regenerate
	bunx biome format --write .

clean:
	rm -rf ./dist
	rm -rf ./output/swift
