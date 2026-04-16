# Show available recipes.
help:
	@just --list

# Validate GoReleaser configuration.
release-check:
	goreleaser check

# Build release artifacts locally without publishing.
release-snapshot:
	goreleaser release --snapshot --clean

# Create a semver release tag like `just release-tag 0.1.0`.
release-tag version:
	git tag "v{{version}}"

# Push an existing semver release tag like `just release-push 0.1.0`.
release-push version:
	git push origin "v{{version}}"

hooks-install:
	go tool github.com/evilmartians/lefthook/v2 install

build:
	go build -o ./lexicodegen ./cmd/lexicodegen

# Format Go sources.
format:
	gofmt -w ./cmd ./internal

# Check Go formatting without writing.
lint:
	test -z "$$(gofmt -l ./cmd ./internal)"

# Refresh lexicon JSON files from upstream sources.
lexicons:
	sh ./scripts/get-lexicons.sh

test:
	go test ./...

ci:
	just lint
	just test
	just build

# Generate from installed executable and current local lexicons.
generate:
	go run ./cmd/lexicodegen ./lexicons --output ./output/swift

# Typecheck generated Swift output with swiftc.
swift-check:
	bash ./scripts/check-swift-compile.sh ./output/swift

# Regenerate Swift output, then typecheck it with swiftc.
verify-swift:
	just generate
	just swift-check

# Refresh upstream lexicons, then regenerate.
regenerate: lexicons generate

# Run full generation flow.
all: regenerate
	just swift-check

clean:
	rm -f ./lexicodegen
	rm -rf ./output/swift
