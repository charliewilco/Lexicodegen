# Lexicon to OpenAPI Generator

Generate an OpenAPI 3.1 document from AT Protocol Lexicon JSON files.

This project scans local lexicons under `./lexicons`, converts supported schema and XRPC definition types, and writes a generated OpenAPI document to `./output/openapi.json`.

## What it generates

- OpenAPI version: `3.1.0`
- API title: `AT Protocol XRPC API`
- Paths: one XRPC endpoint per query/procedure (`/xrpc/{lexicon.id}`)
- Components: converted lexicon definitions under `#/components/schemas/*`
- Security scheme: HTTP bearer auth (`components.securitySchemes.Bearer`)
- Tags: derived from the first 3 segments of each lexicon ID
- Vendor extension: `x-atproto-permission-sets` when permission-set defs exist

## Conversion behavior

Supported lexicon def types:

- `query` -> `GET` operation
- `procedure` -> `POST` operation
- `object`, `record`, `array`, `string`, `token` -> component schemas
- `permission-set` -> component schema plus `x-atproto-permission-sets`

Current behavior and filters:

- `subscription` defs are skipped (not represented in OpenAPI)
- defs whose description starts with `deprecated` are skipped
- defs containing `unspecced` in the identifier are skipped
- deprecated object/query properties are skipped
- refs/unions are mapped to `$ref`/`oneOf`

## Project layout

- `main.ts`: generator entrypoint
- `lib/converters/`: lexicon -> OpenAPI converters
- `lib/utils.ts`: lexicon loading, tagging, helpers
- `lexicons/`: input lexicon JSON files
- `output/`: generated OpenAPI artifacts
- `scripts/get-lexicons.sh`: upstream lexicon refresh script

## Setup

```bash
bun install
```

## Common commands

```bash
# list tasks
just help

# refresh lexicon snapshots
just lexicons

# generate ./output/openapi.json (runs lexicon refresh first)
just generate

# generate YAML from JSON
just yaml

# run full flow (generate + yaml + format)
just all

# format source + generated files
just format

# dev watch mode
bun run dev
```

## Notes

- The generator currently writes JSON only (`./output/openapi.json`); YAML is derived via `just yaml`.
- There is no formal automated test suite in this repo yet.
