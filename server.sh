#!/usr/bin/env bash
set -euo pipefail

# My File Server - one-command launcher
# Repository:
#   https://github.com/Saurabh279-sahu/My_File_Server
#
# Usage:
#   bash server.sh
#
# The protected server is intentionally distributed through the latest
# GitHub Release instead of being stored in the public repository.

OWNER="Saurabh279-sahu"
REPO="My_File_Server"
ASSET_NAME="My-File-Server-Protected.zip"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$SCRIPT_DIR/.server-cache"
ZIP_FILE="$CACHE_DIR/$ASSET_NAME"
EXTRACT_DIR="$CACHE_DIR/protected"
SERVER_FILE="$EXTRACT_DIR/release/server_v9_protected.js"

log() {
  printf '[My File Server] %s\n' "$1"
}

fail() {
  printf '[My File Server] ERROR: %s\n' "$1" >&2
  exit 1
}

command -v node >/dev/null 2>&1 || fail "Node.js is not installed or not in PATH."

mkdir -p "$CACHE_DIR"

# curl is preferred. wget is supported as a fallback.
download() {
  local url="$1"
  local output="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fL --retry 3 --connect-timeout 15 -o "$output" "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$output" "$url"
  else
    fail "Neither curl nor wget is installed."
  fi
}

# GitHub's stable "latest release asset" URL does not require API access.
# This also avoids a hard-coded version, so future releases work automatically.
ASSET_URL="https://github.com/$OWNER/$REPO/releases/latest/download/$ASSET_NAME"

# Use a cached protected server if it already exists. Otherwise download it.
if [ ! -f "$SERVER_FILE" ]; then
  log "Protected server not found locally."
  log "Downloading the latest protected release..."

  TMP_ZIP="$ZIP_FILE.tmp"
  rm -f "$TMP_ZIP"

  if ! download "$ASSET_URL" "$TMP_ZIP"; then
    rm -f "$TMP_ZIP"
    fail "Could not download the latest release asset.
Check that a GitHub Release exists and its asset is named:
  $ASSET_NAME"
  fi

  # Basic ZIP signature check before extraction.
  if ! command -v unzip >/dev/null 2>&1; then
    rm -f "$TMP_ZIP"
    fail "'unzip' is required to extract the protected release."
  fi

  if ! unzip -tq "$TMP_ZIP" >/dev/null 2>&1; then
    rm -f "$TMP_ZIP"
    fail "Downloaded release asset is not a valid ZIP file."
  fi

  rm -rf "$EXTRACT_DIR"
  mkdir -p "$EXTRACT_DIR"
  unzip -q "$TMP_ZIP" -d "$EXTRACT_DIR"
  mv "$TMP_ZIP" "$ZIP_FILE"
fi

[ -f "$SERVER_FILE" ] || fail "Protected server file was not found after installation."

log "Starting protected server..."
log "Default port: 1234"
echo

# Forward any user-supplied arguments to the protected server.
exec node "$SERVER_FILE" "$@"
