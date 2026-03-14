#!/bin/bash

# MacDevTools Installation Script

set -e

# Detect kernel/architecture
KERNEL_NAME="$(uname -s)"
ARCH_NAME="$(uname -m)"

# Default install prefix by kernel/arch (can still be overridden by env)
if [[ -z "${PREFIX:-}" ]]; then
    case "$KERNEL_NAME" in
        Darwin)
            # Apple Silicon commonly uses /opt/homebrew, Intel uses /usr/local.
            if [[ "$ARCH_NAME" == "arm64" ]] && [[ -d "/opt/homebrew" ]]; then
                PREFIX="/opt/homebrew"
            else
                PREFIX="/usr/local"
            fi
            ;;
        Linux)
            PREFIX="/usr/local"
            ;;
        *)
            echo "Warning: unsupported kernel '$KERNEL_NAME', fallback to /usr/local"
            PREFIX="/usr/local"
            ;;
    esac
fi

BINDIR="${BINDIR:-$PREFIX/bin}"
LIBDIR="${LIBDIR:-$PREFIX/lib/shelltools}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Installing MacDevTools..."
if [[ "$KERNEL_NAME" == "Darwin" ]]; then
    echo "Platform: macOS ($ARCH_NAME)"
else
    echo "Platform: $KERNEL_NAME ($ARCH_NAME)"
fi
echo "  BINDIR  = $BINDIR"
echo "  LIBDIR  = $LIBDIR"
echo ""

# Create directories (may need sudo if PREFIX is system-wide)
mkdir -p "$BINDIR" 2>/dev/null || { echo -e "${YELLOW}⚠  mkdir failed, trying with sudo...${NC}"; sudo mkdir -p "$BINDIR"; }
mkdir -p "$LIBDIR" 2>/dev/null || sudo mkdir -p "$LIBDIR"

# Copy scripts
install_files() {
    local dst="$1"
    cp clean_*.sh "$dst/"
    cp check_network.sh "$dst/"
    cp port_killer.sh "$dst/"
    cp dns_lookup.sh "$dst/"
    cp fake_busy_build.sh "$dst/"
    chmod +x "$dst"/*.sh
}

install_files "$LIBDIR" 2>/dev/null || { sudo cp clean_*.sh check_network.sh port_killer.sh dns_lookup.sh fake_busy_build.sh "$LIBDIR/"; sudo chmod +x "$LIBDIR"/*.sh; }

# Install launcher (tool resolves script dir dynamically at runtime)
TOOL_LAUNCHER="$BINDIR/tool"
cp tool "$TOOL_LAUNCHER" 2>/dev/null || sudo cp tool "$TOOL_LAUNCHER"

# Set permissions
chmod +x "$TOOL_LAUNCHER" 2>/dev/null || sudo chmod +x "$TOOL_LAUNCHER"

echo -e "${GREEN}✓ MacDevTools installed successfully!${NC}"
echo ""
echo "Run 'tool' to start."
if [[ "$KERNEL_NAME" != "Darwin" ]]; then
    echo ""
    echo "💡 If '$BINDIR' is not in your PATH, add this to ~/.bashrc or ~/.profile:"
    echo "   export PATH=\"$BINDIR:\$PATH\""
fi
