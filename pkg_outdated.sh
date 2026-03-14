#!/bin/bash

# Package Outdated Checker
# Summarize outdated packages across all installed package managers

set -e

echo "📦 Package Outdated Checker"
echo "==========================="

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m'

pass()  { echo -e "   ${GREEN}✓${NC} $1"; }
fail()  { echo -e "   ${RED}✗${NC} $1"; }
warn()  { echo -e "   ${YELLOW}⚠${NC} $1"; }
info()  { echo -e "   ${GRAY}→${NC} $1"; }

TOTAL_OUTDATED=0

# ── Homebrew ─────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}🍺 Homebrew:${NC}"
if command -v brew &> /dev/null; then
    info "Fetching updates (brew update)..."
    brew update --quiet 2>/dev/null || true
    BREW_OUT=$(brew outdated 2>/dev/null)
    COUNT=$(echo "$BREW_OUT" | grep -c '.' 2>/dev/null || echo 0)
    if [ "$COUNT" -gt 0 ]; then
        warn "$COUNT outdated formula(e):"
        echo "$BREW_OUT" | while read -r line; do
            echo "      $line"
        done
        TOTAL_OUTDATED=$((TOTAL_OUTDATED + COUNT))
    else
        pass "All Homebrew packages up to date"
    fi
    # Casks
    CASK_OUT=$(brew outdated --cask 2>/dev/null)
    CASK_COUNT=$(echo "$CASK_OUT" | grep -c '.' 2>/dev/null || echo 0)
    if [ "$CASK_COUNT" -gt 0 ]; then
        warn "$CASK_COUNT outdated cask(s):"
        echo "$CASK_OUT" | while read -r line; do
            echo "      $line"
        done
        TOTAL_OUTDATED=$((TOTAL_OUTDATED + CASK_COUNT))
    else
        pass "All Homebrew casks up to date"
    fi
else
    info "Homebrew not installed, skipping"
fi

# ── pip / pip3 ────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}🐍 Python (pip):${NC}"
PIP_CMD=""
if command -v pip3 &> /dev/null; then PIP_CMD="pip3"
elif command -v pip &> /dev/null; then PIP_CMD="pip"; fi

if [ -n "$PIP_CMD" ]; then
    PIP_OUT=$($PIP_CMD list --outdated --format=columns 2>/dev/null | tail -n +3)
    COUNT=$(echo "$PIP_OUT" | grep -c '.' 2>/dev/null || echo 0)
    if [ "$COUNT" -gt 0 ]; then
        warn "$COUNT outdated package(s):"
        echo "$PIP_OUT" | head -20 | while read -r line; do
            echo "      $line"
        done
        [ "$COUNT" -gt 20 ] && echo "      ... and $((COUNT - 20)) more"
        TOTAL_OUTDATED=$((TOTAL_OUTDATED + COUNT))
    else
        pass "All pip packages up to date"
    fi
else
    info "pip not installed, skipping"
fi

# ── npm (global) ──────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}🟢 npm (global packages):${NC}"
if command -v npm &> /dev/null; then
    NPM_OUT=$(npm outdated -g --parseable 2>/dev/null || true)
    COUNT=$(echo "$NPM_OUT" | grep -c '.' 2>/dev/null || echo 0)
    if [ "$COUNT" -gt 0 ]; then
        warn "$COUNT outdated global package(s):"
        echo "$NPM_OUT" | while IFS=: read -r _ current wanted latest _; do
            echo "      current=$current  wanted=$wanted  latest=$latest"
        done
        TOTAL_OUTDATED=$((TOTAL_OUTDATED + COUNT))
    else
        pass "All global npm packages up to date"
    fi
else
    info "npm not installed, skipping"
fi

# ── pnpm (global) ─────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}🟦 pnpm (global packages):${NC}"
if command -v pnpm &> /dev/null; then
    PNPM_OUT=$(pnpm outdated -g 2>/dev/null || true)
    if [ -n "$PNPM_OUT" ]; then
        COUNT=$(echo "$PNPM_OUT" | grep -c '.' 2>/dev/null || echo 0)
        warn "$COUNT outdated global pnpm package(s):"
        echo "$PNPM_OUT" | head -20 | while read -r line; do
            echo "      $line"
        done
        TOTAL_OUTDATED=$((TOTAL_OUTDATED + COUNT))
    else
        pass "All global pnpm packages up to date"
    fi
else
    info "pnpm not installed, skipping"
fi

# ── yarn (global) ─────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}🧶 yarn (global packages):${NC}"
if command -v yarn &> /dev/null; then
    YARN_OUT=$(yarn global outdated --no-progress 2>/dev/null | tail -n +4 || true)
    COUNT=$(echo "$YARN_OUT" | grep -c '.' 2>/dev/null || echo 0)
    if [ "$COUNT" -gt 0 ]; then
        warn "$COUNT outdated global yarn package(s):"
        echo "$YARN_OUT" | head -20 | while read -r line; do
            echo "      $line"
        done
        TOTAL_OUTDATED=$((TOTAL_OUTDATED + COUNT))
    else
        pass "All global yarn packages up to date"
    fi
else
    info "yarn not installed, skipping"
fi

# ── gem ───────────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}💎 Ruby Gems:${NC}"
if command -v gem &> /dev/null; then
    GEM_OUT=$(gem outdated 2>/dev/null || true)
    COUNT=$(echo "$GEM_OUT" | grep -c '.' 2>/dev/null || echo 0)
    if [ "$COUNT" -gt 0 ]; then
        warn "$COUNT outdated gem(s):"
        echo "$GEM_OUT" | head -20 | while read -r line; do
            echo "      $line"
        done
        [ "$COUNT" -gt 20 ] && echo "      ... and $((COUNT - 20)) more"
        TOTAL_OUTDATED=$((TOTAL_OUTDATED + COUNT))
    else
        pass "All gems up to date"
    fi
else
    info "gem not installed, skipping"
fi

# ── cargo ─────────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}🦀 Cargo (installed binaries):${NC}"
if command -v cargo &> /dev/null; then
    if command -v cargo-install-update &> /dev/null; then
        CARGO_OUT=$(cargo install-update -l 2>/dev/null | grep "Yes" || true)
        COUNT=$(echo "$CARGO_OUT" | grep -c '.' 2>/dev/null || echo 0)
        if [ "$COUNT" -gt 0 ]; then
            warn "$COUNT outdated crate(s):"
            echo "$CARGO_OUT" | while read -r line; do
                echo "      $line"
            done
            TOTAL_OUTDATED=$((TOTAL_OUTDATED + COUNT))
        else
            pass "All installed crates up to date"
        fi
    else
        info "cargo-install-update not found; install with: cargo install cargo-update"
    fi
else
    info "cargo not installed, skipping"
fi

# ── Go (tools in GOPATH/bin) ──────────────────────────────────────────────────

echo ""
echo -e "${BOLD}🐹 Go toolchain:${NC}"
if command -v go &> /dev/null; then
    GO_VERSION=$(go version | awk '{print $3}')
    pass "Go $GO_VERSION installed"
    info "Note: run 'go install <pkg>@latest' to update individual tools"
else
    info "Go not installed, skipping"
fi

# ── macOS system updates ───────────────────────────────────────────────────────

if [[ "$(uname -s)" == "Darwin" ]]; then
    echo ""
    echo -e "${BOLD}🍎 macOS System Updates:${NC}"
    info "Checking for software updates..."
    SYS_OUT=$(softwareupdate -l 2>/dev/null || true)
    if echo "$SYS_OUT" | grep -q "No new software available"; then
        pass "macOS is up to date"
    elif echo "$SYS_OUT" | grep -q "\*"; then
        warn "System updates available:"
        echo "$SYS_OUT" | grep -E "^\s*[\*\-]" | head -10 | while read -r line; do
            echo "      $line"
        done
    else
        info "Could not determine update status"
    fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "================================="
echo -e "${BOLD}📋 Summary:${NC}"
if [ "$TOTAL_OUTDATED" -eq 0 ]; then
    echo -e "   ${GREEN}✓ Everything is up to date!${NC}"
else
    echo -e "   ${YELLOW}⚠ $TOTAL_OUTDATED outdated package(s) found across all managers${NC}"
fi
echo ""
echo "💡 Quick update commands:"
command -v brew  &>/dev/null && echo "   brew upgrade"
command -v pip3  &>/dev/null && echo "   pip3 list --outdated | awk 'NR>2{print \$1}' | xargs pip3 install -U"
command -v npm   &>/dev/null && echo "   npm update -g"
command -v gem   &>/dev/null && echo "   gem update"
