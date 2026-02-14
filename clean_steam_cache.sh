#!/bin/bash

# Steam Download Cache Cleanup Script
# Cleans Steam download/app/http/depot caches on macOS

set -e

STEAM_DIR="$HOME/Library/Application Support/Steam"
DOWNLOADING_DIR="$STEAM_DIR/steamapps/downloading"
APP_CACHE="$STEAM_DIR/appcache"
HTTP_CACHE="$STEAM_DIR/httpcache"
DEPOT_CACHE="$STEAM_DIR/depotcache"
LOGS_DIR="$STEAM_DIR/logs"

printf "\n🕹️  Steam Download Cache Cleanup\n"
printf "===============================\n\n"

# Ensure Steam is installed
if [ ! -d "$STEAM_DIR" ]; then
    echo "❌ Steam directory not found at: $STEAM_DIR"
    echo "   Please ensure Steam is installed for this user."
    exit 1
fi

# Advise user to quit Steam before cleaning
if pgrep -f "[S]team" >/dev/null 2>&1; then
    echo "⚠️  Steam appears to be running. Please quit Steam before cleaning."
    read -p "Proceed anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

clean_dir() {
    local path="$1"
    local label="$2"
    if [ -d "$path" ]; then
        local size
        size=$(du -sh "$path" 2>/dev/null | cut -f1)
        echo "   → Cleaning $label ($size)"
        rm -rf "${path:?}"/* 2>/dev/null || true
    else
        echo "   → $label not found, skipping"
    fi
}

echo "📦 Targets:"
clean_dir "$DOWNLOADING_DIR" "Steam downloading cache"
clean_dir "$APP_CACHE" "Steam app cache"
clean_dir "$HTTP_CACHE" "Steam HTTP cache"
clean_dir "$DEPOT_CACHE" "Steam depot cache"
clean_dir "$LOGS_DIR" "Steam logs (optional)"

# Remove leftover partial downloads marker files
PARTIALS=$(find "$STEAM_DIR/steamapps" -maxdepth 1 -name "*.part" 2>/dev/null)
if [ -n "$PARTIALS" ]; then
    echo "   → Removing partial download markers"
    find "$STEAM_DIR/steamapps" -maxdepth 1 -name "*.part" -delete 2>/dev/null || true
fi

printf "\n✅ Steam cache cleanup complete.\n"
printf "💡 Tip: Restart Steam and resume downloads if needed.\n\n"
