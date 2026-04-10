#!/bin/bash

set -euo pipefail

OUTPUT_DIR="${1:-./output/swift}"

if ! command -v swiftc >/dev/null 2>&1; then
	echo "swiftc is not installed or not on PATH" >&2
	exit 1
fi

if [ ! -d "$OUTPUT_DIR" ]; then
	echo "Swift output directory not found: $OUTPUT_DIR" >&2
	exit 1
fi

swift_files=()
while IFS= read -r file; do
	swift_files+=("$file")
done < <(find "$OUTPUT_DIR" -type f -name "*.swift" | sort)

if [ ${#swift_files[@]} -eq 0 ]; then
	echo "No Swift files found in $OUTPUT_DIR" >&2
	exit 1
fi

echo "Typechecking ${#swift_files[@]} Swift files from $OUTPUT_DIR"
swiftc -typecheck "${swift_files[@]}"
echo "Swift typecheck passed"
