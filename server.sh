#!/usr/bin/env bash
set -euo pipefail

OWNER="Saurabh279-sahu"
REPO="My_File_Server"
ASSET_NAME="My-File-Server-Protected.zip"
SERVER_BASENAME="server_v9_protected.js"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$SCRIPT_DIR/.server-cache"
ZIP_FILE="$CACHE_DIR/$ASSET_NAME"
EXTRACT_DIR="$CACHE_DIR/protected"

log() { printf '[My File Server] %s\n' "$1"; }
fail() { printf '[My File Server] ERROR: %s\n' "$1" >&2; exit 1; }

command -v node >/dev/null 2>&1 || fail "Node.js is not installed or not in PATH."
mkdir -p "$CACHE_DIR"

download() {
  local url="$1" output="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fL --retry 3 --connect-timeout 15 -o "$output" "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$output" "$url"
  else
    fail "Neither curl nor wget is installed."
  fi
}

find_server() {
  find "$EXTRACT_DIR" -type f -name "$SERVER_BASENAME" -print -quit 2>/dev/null || true
}

SERVER_FILE=""
[ -d "$EXTRACT_DIR" ] && SERVER_FILE="$(find_server)"

if [ -z "$SERVER_FILE" ]; then
  log "Protected server not found locally."
  log "Downloading the latest protected release..."

  command -v unzip >/dev/null 2>&1 || fail "'unzip' is required."

  TMP_ZIP="$ZIP_FILE.tmp"
  TMP_EXTRACT="$CACHE_DIR/protected.tmp"
  rm -f "$TMP_ZIP"
  rm -rf "$TMP_EXTRACT"

  ASSET_URL="https://github.com/$OWNER/$REPO/releases/latest/download/$ASSET_NAME"

  download "$ASSET_URL" "$TMP_ZIP" || {
    rm -f "$TMP_ZIP"
    fail "Could not download the latest release asset.
Make sure a published GitHub Release exists and the asset is named:
  $ASSET_NAME"
  }

  unzip -tq "$TMP_ZIP" >/dev/null 2>&1 || {
    rm -f "$TMP_ZIP"
    fail "Downloaded release asset is not a valid ZIP file."
  }

  mkdir -p "$TMP_EXTRACT"
  unzip -q "$TMP_ZIP" -d "$TMP_EXTRACT"

  FOUND="$(find "$TMP_EXTRACT" -type f -name "$SERVER_BASENAME" -print -quit 2>/dev/null || true)"
  [ -n "$FOUND" ] || {
    rm -rf "$TMP_EXTRACT" "$TMP_ZIP"
    fail "$SERVER_BASENAME was not found inside the downloaded ZIP."
  }

  rm -rf "$EXTRACT_DIR"
  mv "$TMP_EXTRACT" "$EXTRACT_DIR"
  mv "$TMP_ZIP" "$ZIP_FILE"
  SERVER_FILE="$(find_server)"
fi

[ -f "$SERVER_FILE" ] || fail "Protected server file was not found."
log "Protected server found."
log "Starting server..."
log "Default port: 1234"
echo

exec node "$SERVER_FILE" "$@"
