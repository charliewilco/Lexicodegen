#!/bin/bash

URL="${1:-https://codeload.github.com/bluesky-social/atproto/tar.gz/main}"
DEST_PATH="${2:-lexicons}"
TAR_PATH="${3:-atproto-main/lexicons}"

# Delete existing files in the destination folder to remove out-of-date lexicons
rm -rf "$DEST_PATH"/*
mkdir -p "$DEST_PATH"

# Download and extract the specified path
curl -L "$URL" | tar -xz --strip=2 --directory "$DEST_PATH" "$TAR_PATH"

echo "Copied lexicons to $DEST_PATH."
