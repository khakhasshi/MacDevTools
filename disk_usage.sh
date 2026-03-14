#!/bin/bash

# Disk Usage Analyzer
# Find the largest files and directories to identify disk hogs

set -e

echo "💾 Disk Usage Analyzer"
echo "======================"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
GRAY='\033[0;90m'
NC='\033[0m'

PLATFORM="$(uname -s)"

# ── 1. Overall disk status ────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}📊 Disk Overview:${NC}"
if [[ "$PLATFORM" == "Darwin" ]]; then
    df -h / | awk 'NR==2 {
        printf "   Filesystem : %s\n", $1
        printf "   Total      : %s\n", $2
        printf "   Used       : %s\n", $3
        printf "   Available  : %s\n", $4
        printf "   Use%%       : %s\n", $5
    }'
    # Show all mounted volumes
    echo ""
    echo "   All Volumes:"
    df -h | grep -E "^/dev" | awk '{printf "   %-30s %6s used  %6s free  %s\n", $1, $3, $4, $5}'
else
    df -h --output=source,size,used,avail,pcent,target | head -1
    df -h --output=source,size,used,avail,pcent,target | grep -E "^/dev" | head -10
fi

# ── 2. Home directory breakdown ───────────────────────────────────────────────

echo ""
echo -e "${BOLD}🏠 Home Directory Breakdown (~):${NC}"
echo "   (scanning top-level directories...)"
echo ""

if [[ "$PLATFORM" == "Darwin" ]]; then
    # macOS: use -x to stay on same filesystem, skip special dirs
    du -sh "$HOME"/* 2>/dev/null \
        | sort -rh \
        | head -20 \
        | awk '{printf "   %6s  %s\n", $1, $2}'
else
    du -sh --exclude=proc "$HOME"/*/ 2>/dev/null \
        | sort -rh \
        | head -20 \
        | awk '{printf "   %6s  %s\n", $1, $2}'
fi

# ── 3. Top 20 largest files under home ────────────────────────────────────────

echo ""
echo -e "${BOLD}📄 Top 20 Largest Files in ~:${NC}"
echo "   (this may take a moment...)"
echo ""

find "$HOME" -xdev -type f -not -path "*/.Trash/*" \
    2>/dev/null \
    | xargs du -sh 2>/dev/null \
    | sort -rh \
    | head -20 \
    | awk '{printf "   %6s  %s\n", $1, $2}'

# ── 4. Known dev cache hotspots ───────────────────────────────────────────────

echo ""
echo -e "${BOLD}🧰 Developer Cache Hotspots:${NC}"

hotspots=(
    "$HOME/.cargo"
    "$HOME/.gradle"
    "$HOME/.m2"
    "$HOME/go"
    "$HOME/.cache"
    "$HOME/.npm"
    "$HOME/.pnpm-store"
    "$HOME/.pyenv"
    "$HOME/.rbenv"
    "$HOME/.sdkman"
)

if [[ "$PLATFORM" == "Darwin" ]]; then
    hotspots+=(
        "$HOME/Library/Caches"
        "$HOME/Library/Developer/Xcode/DerivedData"
        "$HOME/Library/Developer/CoreSimulator/Caches"
        "$HOME/Library/Logs"
    )
fi

any_found=false
for d in "${hotspots[@]}"; do
    if [ -d "$d" ]; then
        SZ=$(du -sh "$d" 2>/dev/null | cut -f1)
        printf "   ${CYAN}%6s${NC}  %s\n" "$SZ" "$d"
        any_found=true
    fi
done

if ! $any_found; then
    echo "   (no known hotspot directories found)"
fi

# ── 5. Large files in /tmp ────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}🗑️  Temporary Files (/tmp):${NC}"
if [ -d "/tmp" ]; then
    TMP_SIZE=$(du -sh /tmp 2>/dev/null | cut -f1)
    echo "   /tmp size: $TMP_SIZE"
    LARGE_TMP=$(find /tmp -maxdepth 2 -type f -size +10M 2>/dev/null | head -10)
    if [ -n "$LARGE_TMP" ]; then
        echo "   Large files (>10M):"
        echo "$LARGE_TMP" | while read -r f; do
            SZ=$(du -sh "$f" 2>/dev/null | cut -f1)
            printf "   %6s  %s\n" "$SZ" "$f"
        done
    else
        echo "   No large files (>10M) in /tmp"
    fi
fi

# ── 6. macOS: ~/Downloads quick summary ──────────────────────────────────────

if [[ "$PLATFORM" == "Darwin" ]]; then
    DOWNLOADS="$HOME/Downloads"
    if [ -d "$DOWNLOADS" ]; then
        echo ""
        echo -e "${BOLD}📥 Downloads Folder:${NC}"
        SZ=$(du -sh "$DOWNLOADS" 2>/dev/null | cut -f1)
        COUNT=$(find "$DOWNLOADS" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
        echo "   Size: $SZ   Files: $COUNT"
        echo "   Top 10 largest:"
        find "$DOWNLOADS" -maxdepth 1 -type f 2>/dev/null \
            | xargs du -sh 2>/dev/null \
            | sort -rh \
            | head -10 \
            | awk '{printf "   %6s  %s\n", $1, $2}'
    fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "✅ Analysis complete!"
echo ""
echo "💡 Tips:"
echo "   - 'tool brew'    Clean Homebrew cache"
echo "   - 'tool node'    Clean npm/pnpm/yarn cache"
echo "   - 'tool cargo'   Clean Rust/Cargo cache"
echo "   - 'tool gradle'  Clean Gradle cache"
echo "   - 'tool maven'   Clean Maven local repository"
echo "   - 'tool all'     Clean all known caches at once"
if [[ "$PLATFORM" == "Darwin" ]]; then
    echo "   - 'tool xcode'   Clean Xcode DerivedData"
fi
