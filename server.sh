
#!/usr/bin/env bash
set -euo pipefail

# GitHub Repository
OWNER="Saurabh279-sahu"
REPO="My_File_Server"

# PINNED OLD SERVER RELEASE
RELEASE_TAG="v12.0.0"

# Release ZIP Asset
ASSET_NAME="My_File_Server.zip"
SERVER_BASENAME="server_v12.js"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$SCRIPT_DIR/.server-cache"
ZIP_FILE="$CACHE_DIR/$ASSET_NAME"
EXTRACT_DIR="$CACHE_DIR/server_v12"

log() {
    printf '[My File Server] %s\n' "$1"
}

fail() {
    printf '[My File Server] ERROR: %s\n' "$1" >&2
    exit 1
}

# Check Node.js
command -v node >/dev/null 2>&1 || fail "Node.js is not installed."

# Check dependencies
command -v unzip >/dev/null 2>&1 || fail "Install unzip: pkg install unzip"

mkdir -p "$CACHE_DIR"

download() {
    local url="$1"
    local output="$2"

    if command -v curl >/dev/null 2>&1; then
        curl -fL --retry 3 --connect-timeout 15 \
            -o "$output" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -O "$output" "$url"
    else
        fail "Install curl or wget."
    fi
}

find_server() {
    find "$EXTRACT_DIR" -type f \
        -name "$SERVER_BASENAME" -print -quit 2>/dev/null || true
}

SERVER_FILE=""

# Check cached server
if [ -d "$EXTRACT_DIR" ]; then
    SERVER_FILE="$(find_server)"
fi

# Download only if server is missing
if [ -z "$SERVER_FILE" ]; then

    log "Old server not found locally."
    log "Downloading pinned release: $RELEASE_TAG"

    TMP_ZIP="$ZIP_FILE.tmp"
    TMP_EXTRACT="$CACHE_DIR/server_v12.tmp"

    rm -f "$TMP_ZIP"
    rm -rf "$TMP_EXTRACT"

    # IMPORTANT: Fixed release URL, NOT latest
    ASSET_URL="https://github.com/$OWNER/$REPO/releases/download/$RELEASE_TAG/$ASSET_NAME"

    download "$ASSET_URL" "$TMP_ZIP" || {
        rm -f "$TMP_ZIP"
        fail "Could not download pinned release.
Check release tag and asset filename:
$RELEASE_TAG / $ASSET_NAME"
    }

    # Validate ZIP
    unzip -tq "$TMP_ZIP" >/dev/null 2>&1 || {
        rm -f "$TMP_ZIP"
        fail "Downloaded file is not a valid ZIP."
    }

    mkdir -p "$TMP_EXTRACT"
    unzip -q "$TMP_ZIP" -d "$TMP_EXTRACT"

    FOUND="$(find "$TMP_EXTRACT" -type f \
        -name "$SERVER_BASENAME" -print -quit || true)"

    [ -n "$FOUND" ] || {
        rm -rf "$TMP_EXTRACT" "$TMP_ZIP"
        fail "$SERVER_BASENAME not found inside ZIP."
    }

    rm -rf "$EXTRACT_DIR"
    mv "$TMP_EXTRACT" "$EXTRACT_DIR"
    mv "$TMP_ZIP" "$ZIP_FILE"

    SERVER_FILE="$(find_server)"
fi

[ -f "$SERVER_FILE" ] || fail "Server file not found."

log "Pinned server release: $RELEASE_TAG"
log "Server found successfully."
log "Starting My File Server..."
log "Default port: 1234"

echo

exec node "$SERVER_FILE" "$@"
