#!/bin/bash

# Gradle Cache Cleanup Script
# Clean Gradle caches, build outputs, and daemon files

set -e

echo "🐘 Gradle Cache Cleanup Tool"
echo "============================"

# Check if Gradle is installed (optional; ~/.gradle can exist without gradle on PATH)
if command -v gradle &> /dev/null; then
    GRADLE_VERSION=$(gradle --version 2>/dev/null | grep "^Gradle" | head -1)
    echo "   $GRADLE_VERSION"
else
    echo "   (gradle not on PATH — cleaning ~/.gradle directly)"
fi

GRADLE_HOME="${GRADLE_USER_HOME:-$HOME/.gradle}"

if [ ! -d "$GRADLE_HOME" ]; then
    echo ""
    echo "   ℹ️  No Gradle home found at $GRADLE_HOME"
    echo "   Nothing to clean."
    exit 0
fi

# Show size before
echo ""
echo "📊 Current Gradle Cache Status:"
BEFORE=$(du -sh "$GRADLE_HOME" 2>/dev/null | cut -f1)
echo "   GRADLE_HOME     : $GRADLE_HOME"
echo "   Total size      : $BEFORE"

# Individual subdirectory sizes
for subdir in caches daemon wrapper jdks; do
    d="$GRADLE_HOME/$subdir"
    [ -d "$d" ] && printf "   %-16s: %s\n" "$subdir" "$(du -sh "$d" 2>/dev/null | cut -f1)"
done

# ── 1. Build cache ────────────────────────────────────────────────────────────

echo ""
echo "🧹 Cleaning build cache (~/.gradle/caches/build-cache*)..."
BUILD_CACHE="$GRADLE_HOME/caches/build-cache-1"
BUILD_CACHE_ALT="$GRADLE_HOME/caches/build-cache-*"
if ls -d $BUILD_CACHE_ALT 2>/dev/null | head -1 | grep -q .; then
    SZ=$(du -sh $BUILD_CACHE_ALT 2>/dev/null | awk '{sum += $1} END {print sum}' || echo "?")
    echo "   → Removing build cache..."
    rm -rf $BUILD_CACHE_ALT 2>/dev/null || true
    echo "   ✓ Build cache removed"
else
    echo "   (no build-cache directory found)"
fi

# ── 2. Module/dependency cache (older versions) ───────────────────────────────

echo ""
echo "🧹 Cleaning old module caches (~/.gradle/caches/<version>)..."
CACHES_DIR="$GRADLE_HOME/caches"
if [ -d "$CACHES_DIR" ]; then
    # List version-numbered cache dirs (e.g. 7.6, 8.0, 8.4)
    OLD_CACHES=$(find "$CACHES_DIR" -maxdepth 1 -type d -name "[0-9]*" 2>/dev/null | sort -V | head -n -1)
    OLD_COUNT=$(echo "$OLD_CACHES" | grep -c '.' 2>/dev/null || echo 0)
    echo "   Found $OLD_COUNT old versioned cache dir(s)"
    if [ "$OLD_COUNT" -gt 0 ]; then
        echo "$OLD_CACHES" | while read -r d; do
            SZ=$(du -sh "$d" 2>/dev/null | cut -f1)
            echo "      $d  ($SZ)"
        done
        read -p "   Remove old version caches? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "$OLD_CACHES" | xargs rm -rf 2>/dev/null || true
            echo "   ✓ Old version caches removed"
        else
            echo "   Skipped"
        fi
    fi
fi

# ── 3. Module files (jars) – files not accessed in >60 days ──────────────────

echo ""
MODULES_DIR="$GRADLE_HOME/caches/modules-2/files-2.1"
if [ -d "$MODULES_DIR" ]; then
    MODULES_SIZE=$(du -sh "$MODULES_DIR" 2>/dev/null | cut -f1)
    OLD_COUNT=$(find "$MODULES_DIR" -name "*.jar" -atime +60 2>/dev/null | wc -l | tr -d ' ')
    echo "🧹 Module artifact cache ($MODULES_SIZE)  —  $OLD_COUNT JAR(s) unused >60 days"
    if [ "$OLD_COUNT" -gt 0 ]; then
        read -p "   Delete unused JARs (>60 days)? Next build will re-download them. (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            find "$MODULES_DIR" -name "*.jar" -atime +60 -delete 2>/dev/null || true
            find "$GRADLE_HOME/caches/modules-2" -empty -type d -delete 2>/dev/null || true
            echo "   ✓ Unused JAR artifacts removed"
        else
            echo "   Skipped"
        fi
    fi
fi

# ── 4. Daemon logs and registry ───────────────────────────────────────────────

echo ""
DAEMON_DIR="$GRADLE_HOME/daemon"
if [ -d "$DAEMON_DIR" ]; then
    DAEMON_SIZE=$(du -sh "$DAEMON_DIR" 2>/dev/null | cut -f1)
    LOG_COUNT=$(find "$DAEMON_DIR" -name "*.log" 2>/dev/null | wc -l | tr -d ' ')
    echo "🧹 Gradle Daemon files ($DAEMON_SIZE)  —  $LOG_COUNT log file(s):"
    echo "   → Removing daemon logs and registry..."
    # Stop running daemons first
    if command -v gradle &> /dev/null; then
        gradle --stop 2>/dev/null || true
    fi
    find "$DAEMON_DIR" -name "*.log" -delete 2>/dev/null || true
    find "$DAEMON_DIR" -name "registry.bin*" -delete 2>/dev/null || true
    echo "   ✓ Daemon logs removed"
fi

# ── 5. Wrapper distributions ──────────────────────────────────────────────────

echo ""
WRAPPER_DIR="$GRADLE_HOME/wrapper/dists"
if [ -d "$WRAPPER_DIR" ]; then
    WRAPPER_SIZE=$(du -sh "$WRAPPER_DIR" 2>/dev/null | cut -f1)
    DIST_COUNT=$(find "$WRAPPER_DIR" -maxdepth 1 -type d | tail -n +2 | wc -l | tr -d ' ')
    echo "🧹 Gradle Wrapper distributions ($WRAPPER_SIZE)  —  $DIST_COUNT version(s)"
    if [ "$DIST_COUNT" -gt 1 ]; then
        echo "   Installed versions:"
        find "$WRAPPER_DIR" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort -V | while read -r d; do
            SZ=$(du -sh "$d" 2>/dev/null | cut -f1)
            echo "      $(basename "$d")  ($SZ)"
        done
        read -p "   Remove all but the newest wrapper version? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            find "$WRAPPER_DIR" -maxdepth 1 -mindepth 1 -type d 2>/dev/null \
                | sort -V | head -n -1 | xargs rm -rf 2>/dev/null || true
            echo "   ✓ Old wrapper distributions removed"
        else
            echo "   Skipped"
        fi
    else
        echo "   Only one version installed, nothing to remove"
    fi
fi

# ── 6. Project .gradle directories ───────────────────────────────────────────

echo ""
echo "🧹 Project .gradle directories in ~:"
PROJECT_DIRS=$(find "$HOME" -maxdepth 4 -type d -name ".gradle" \
    -not -path "$GRADLE_HOME" \
    -not -path "*/.git/*" \
    2>/dev/null | head -20)
P_COUNT=$(echo "$PROJECT_DIRS" | grep -c '.' 2>/dev/null || echo 0)
echo "   Found $P_COUNT project .gradle dir(s)"
if [ "$P_COUNT" -gt 0 ] && [ -n "$PROJECT_DIRS" ]; then
    TOTAL_SZ=$(echo "$PROJECT_DIRS" | xargs du -sh 2>/dev/null | awk '{sum+=$1} END{print sum}' || echo "?")
    echo "$PROJECT_DIRS" | while read -r d; do
        SZ=$(du -sh "$d" 2>/dev/null | cut -f1)
        echo "      $d  ($SZ)"
    done
    read -p "   Clean all project .gradle directories? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$PROJECT_DIRS" | xargs rm -rf 2>/dev/null || true
        echo "   ✓ Project .gradle directories removed"
    else
        echo "   Skipped"
    fi
fi

# ── Show size after ───────────────────────────────────────────────────────────

echo ""
echo "✅ Cleanup complete!"
if [ -d "$GRADLE_HOME" ]; then
    AFTER=$(du -sh "$GRADLE_HOME" 2>/dev/null | cut -f1)
    echo "   Before: $BEFORE   →   After: $AFTER"
fi
echo ""
echo "💡 Tips:"
echo "   - './gradlew clean'               Clean current project build outputs"
echo "   - './gradlew --stop'              Stop all running Gradle daemons"
echo "   - 'gradle --info'                 Show build info including cache hits"
