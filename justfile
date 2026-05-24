# Show available recipes.
help:
	@just --list

hooks-install:
	go tool github.com/evilmartians/lefthook/v2 install

build:
	go build -o ./lexicodegen ./cmd/lexicodegen

# Format Go sources.
format:
	gofmt -w ./cmd ./internal

# Check Go formatting without writing.
lint:
	test -z "$(gofmt -l ./cmd ./internal)"

# Refresh lexicon JSON files from upstream sources.
lexicons:
	sh ./scripts/get-lexicons.sh

test:
	go test ./...

coverage:
	go test ./... -coverprofile=/tmp/lexicodegen-cover.out -covermode=atomic
	go tool cover -func=/tmp/lexicodegen-cover.out

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
regenerate: lexicons generate format-lexicons

format-lexicons:
	npx prettier --write ./lexicons/**/**/**/*.json

# Run full generation flow.
all: regenerate
	just swift-check

clean:
	rm -f ./lexicodegen
	rm -rf ./output/swift
