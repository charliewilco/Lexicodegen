# Lexicon to OpenAPI Generator

A tool to generate OpenAPI specifications from Lexicon schema files.

To install dependencies:

```bash
bun install
```

To run:

```bash
bun run main.ts
```

then convert to yaml

```bash
yq  -Poy ./output/openapi.json > ./output/openapi.yaml
```
