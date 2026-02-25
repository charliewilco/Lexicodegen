# Lexicon to OpenAPI Generator

A tool to generate OpenAPI specifications from Lexicon schema files.

## Setup

Install dependencies:

```bash
bun install
```

## Tasks

List available tasks:

```bash
just help
```

Format sources and generated artifacts:

```bash
just format
```

Refresh lexicons:

```bash
just lexicons
```

Generate OpenAPI output:

```bash
just generate
```

Convert JSON output to YAML:

```bash
yq -Poy ./output/openapi.json > ./output/openapi.yaml
```
