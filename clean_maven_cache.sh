#!/bin/bash

# Maven Local Repository Cleanup Script
# Clean old snapshots, unused jars, and stale metadata from ~/.m2

set -e

echo "🪶 Maven Cache Cleanup Tool"
echo "==========================="

# Check if Maven is installed (optional; ~/.m2 can exist without mvn on PATH)
if command -v mvn &> /dev/null; then
    MVN_VERSION=$(mvn --version 2>/dev/null | head -1)
    echo "   Maven: $MVN_VERSION"
else
    echo "   (mvn not on PATH — cleaning ~/.m2 directly)"
fi

M2_DIR="$HOME/.m2/repository"

if [ ! -d "$M2_DIR" ]; then
    echo ""
    echo "   ℹ️  No local Maven repository found at $M2_DIR"
    echo "   Nothing to clean."
    exit 0
fi

# Show size before
echo ""
echo "📊 Current Repository Status:"
BEFORE=$(du -sh "$M2_DIR" 2>/dev/null | cut -f1)
ARTIFACT_COUNT=$(find "$M2_DIR" -name "*.jar" 2>/dev/null | wc -l | tr -d ' ')
echo "   Repository size : $BEFORE"
echo "   Total JAR files : $ARTIFACT_COUNT"

# ── 1. SNAPSHOT cleanup ───────────────────────────────────────────────────────

echo ""
echo "🧹 Cleaning SNAPSHOT artifacts..."
SNAP_COUNT=$(find "$M2_DIR" -type d -name "*-SNAPSHOT" 2>/dev/null | wc -l | tr -d ' ')
echo "   Found $SNAP_COUNT SNAPSHOT directories"
if [ "$SNAP_COUNT" -gt 0 ]; then
    read -p "   Delete all SNAPSHOT directories? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        find "$M2_DIR" -type d -name "*-SNAPSHOT" -exec rm -rf {} + 2>/dev/null || true
        echo "   ✓ SNAPSHOT artifacts removed"
    else
        echo "   Skipped"
    fi
fi

# ── 2. Stale resolver files (_remote.repositories, *.lastUpdated) ─────────────

echo ""
echo "🧹 Cleaning resolver metadata files..."
RESOLVER_COUNT=$(find "$M2_DIR" -name "_remote.repositories" -o -name "*.lastUpdated" 2>/dev/null | wc -l | tr -d ' ')
echo "   Found $RESOLVER_COUNT stale metadata files"
if [ "$RESOLVER_COUNT" -gt 0 ]; then
    find "$M2_DIR" -name "_remote.repositories" -delete 2>/dev/null || true
    find "$M2_DIR" -name "*.lastUpdated" -delete 2>/dev/null || true
    echo "   ✓ Resolver metadata deleted"
fi

# ── 3. Corrupted/incomplete downloads (.part files, zero-byte files) ──────────

echo ""
echo "🧹 Removing incomplete downloads..."
PART_COUNT=$(find "$M2_DIR" -name "*.part" 2>/dev/null | wc -l | tr -d ' ')
echo "   Found $PART_COUNT .part files"
find "$M2_DIR" -name "*.part" -delete 2>/dev/null || true

ZERO_COUNT=$(find "$M2_DIR" -name "*.jar" -empty 2>/dev/null | wc -l | tr -d ' ')
echo "   Found $ZERO_COUNT zero-byte JARs"
find "$M2_DIR" -name "*.jar" -empty -delete 2>/dev/null || true
find "$M2_DIR" -name "*.pom" -empty -delete 2>/dev/null || true
echo "   ✓ Incomplete downloads removed"

# ── 4. Old artifacts (not accessed in >90 days) ───────────────────────────────

echo ""
OLD_COUNT=$(find "$M2_DIR" -name "*.jar" -atime +90 2>/dev/null | wc -l | tr -d ' ')
echo "🧹 Old artifacts (not accessed in >90 days): $OLD_COUNT JAR(s)"
if [ "$OLD_COUNT" -gt 0 ]; then
    read -p "   Delete unused JARs (>90 days)? This may cause next build to re-download them. (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        find "$M2_DIR" -name "*.jar" -atime +90 -delete 2>/dev/null || true
        find "$M2_DIR" -name "*.pom" -atime +90 -delete 2>/dev/null || true
        find "$M2_DIR" -type d -empty -delete 2>/dev/null || true
        echo "   ✓ Old artifacts removed"
    else
        echo "   Skipped"
    fi
fi

# ── 5. Maven wrapper cache (optional) ────────────────────────────────────────

WRAPPER_DIR="$HOME/.m2/wrapper"
if [ -d "$WRAPPER_DIR" ]; then
    echo ""
    WRP_SIZE=$(du -sh "$WRAPPER_DIR" 2>/dev/null | cut -f1)
    echo "🧹 Maven wrapper distributions (~/.m2/wrapper): $WRP_SIZE"
    read -p "   Clean old Maven wrapper downloads? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Keep only the most recent version in each dist dir
        find "$WRAPPER_DIR/dists" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
            | sort -V | head -n -1 \
            | xargs rm -rf 2>/dev/null || true
        echo "   ✓ Old wrapper distributions removed"
    else
        echo "   Skipped"
    fi
fi

# ── Show size after ───────────────────────────────────────────────────────────

echo ""
echo "✅ Cleanup complete!"
if [ -d "$M2_DIR" ]; then
    AFTER=$(du -sh "$M2_DIR" 2>/dev/null | cut -f1)
    echo "   Before: $BEFORE   →   After: $AFTER"
fi
echo ""
echo "💡 Tips:"
echo "   - 'mvn dependency:purge-local-repository'  Remove all deps for current project"
echo "   - 'mvn dependency:resolve'                 Re-download all project dependencies"
