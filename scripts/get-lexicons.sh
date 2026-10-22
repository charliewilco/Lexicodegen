#!/bin/sh
set -eu

URL="${1:-https://codeload.github.com/bluesky-social/atproto/tar.gz/main}"
DEST_PATH="${2:-lexicons}"
TAR_PATH="${3:-atproto-main/lexicons}"
BSKY_URL="${BSKY_URL:-https://codeload.github.com/bluesky-social/bsky/tar.gz/main}"
BSKY_TAR_PATH="${BSKY_TAR_PATH:-bsky-main/lexicons}"

case "$DEST_PATH" in
	""|/|.|..) echo "Refusing unsafe lexicon destination: $DEST_PATH" >&2; exit 1 ;;
esac

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM
mkdir -p "$tmp_dir/lexicons"
curl -fsSL "$URL" -o "$tmp_dir/atproto.tar.gz"
tar -xzf "$tmp_dir/atproto.tar.gz" --strip-components=2 --directory "$tmp_dir/lexicons" "$TAR_PATH"

# Explicit archive arguments retain the single-source refresh contract.
if [ "$#" -eq 0 ]; then
	rm -rf "$tmp_dir/lexicons/app" "$tmp_dir/lexicons/chat" "$tmp_dir/lexicons/internal"
	mkdir -p "$tmp_dir/bsky"
	curl -fsSL "$BSKY_URL" -o "$tmp_dir/bsky.tar.gz"
	tar -xzf "$tmp_dir/bsky.tar.gz" --strip-components=2 --directory "$tmp_dir/bsky" "$BSKY_TAR_PATH"
	cp -R "$tmp_dir/bsky/app" "$tmp_dir/bsky/chat" "$tmp_dir/lexicons/"
fi

# Keep the existing snapshots intact when either download or extraction fails.
rm -rf "$DEST_PATH"
mkdir -p "$DEST_PATH"
cp -R "$tmp_dir/lexicons/." "$DEST_PATH/"
echo "Copied lexicons to $DEST_PATH."
