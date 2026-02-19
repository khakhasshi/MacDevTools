#!/bin/bash

# Apple TV App Download Cache Cleanup (macOS only)
# Safely clears Apple TV app caches and temporary download data without touching your media library.

set -e

# This script is macOS-only (Apple TV app does not exist on Linux)
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "⚠️  Apple TV app is macOS-only. Skipping on this platform."
    exit 0
fi

APP_CONTAINER="$HOME/Library/Containers/com.apple.TV/Data/Library"
CACHE_DIR="$APP_CONTAINER/Caches"
TV_CACHE="$CACHE_DIR/com.apple.tv"
TV_DOWNLOADS="$TV_CACHE/Downloads"
TV_CACHES_MISC="$TV_CACHE"
GROUP_CONTAINER="$HOME/Library/Group Containers/2H9XW99HL4.com.apple.TV"
GROUP_CACHE="$GROUP_CONTAINER/Library/Caches"

printf "\n📺 Apple TV Cache Cleanup\n"
printf "========================\n\n"

# Recommend quitting the TV app
if pgrep -f "[T]V$" >/dev/null 2>&1; then
    echo "⚠️  Apple TV app appears to be running. Please quit it before cleaning."
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

clean_dir "$TV_DOWNLOADS" "Apple TV download cache"
clean_dir "$TV_CACHES_MISC" "Apple TV cache"
clean_dir "$GROUP_CACHE" "Apple TV group container cache"

printf "\n✅ Apple TV cache cleanup complete.\n"
printf "💡 Tip: Restart the TV app and re-check downloads if needed.\n\n"
