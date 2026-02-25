# Show available recipes.
help:
	@just --list

# Format generated OpenAPI, lexicon JSON files, and TypeScript sources.
format:
	bunx biome format --write ./output/*.json ./lexicons/**/**/**/*.json ./lib/**/*.ts ./main.ts

# Refresh lexicon JSON files from upstream sources.
lexicons:
	sh ./scripts/get-lexicons.sh

# Generate fresh OpenAPI JSON after syncing lexicons.
generate: lexicons
	bun run ./main.ts

# Generate OpenAPI YAML from the generated JSON output.
yaml: generate
	yq -Poy ./output/openapi.json > ./output/openapi.yaml

# Run full generation flow (JSON + YAML), then format all tracked artifacts.
all: yaml
	bunx biome format --write ./output/*.json ./lexicons/**/**/**/*.json ./lib/**/*.ts ./main.ts
