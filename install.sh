#!/bin/bash

# MacDevTools Installation Script

# Detect platform
PLATFORM="$(uname -s)"

# Default install paths
if [[ "$PLATFORM" == "Darwin" ]]; then
    PREFIX="${PREFIX:-/usr/local}"
else
    # Linux: try /usr/local first (works for most distros)
    PREFIX="${PREFIX:-/usr/local}"
fi

BINDIR="${BINDIR:-$PREFIX/bin}"
LIBDIR="${LIBDIR:-$PREFIX/lib/shelltools}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Installing MacDevTools..."
if [[ "$PLATFORM" == "Darwin" ]]; then
    echo "Platform: macOS"
else
    echo "Platform: Linux ($PLATFORM)"
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
    chmod +x "$dst"/*.sh
}

install_files "$LIBDIR" 2>/dev/null || { sudo cp clean_*.sh check_network.sh port_killer.sh dns_lookup.sh "$LIBDIR/"; sudo chmod +x "$LIBDIR"/*.sh; }

# Patch TOOL_DIR in the launcher
TOOL_LAUNCHER="$BINDIR/tool"
sed "s|TOOL_DIR=\"\$HOME/ShellTools\"|TOOL_DIR=\"$LIBDIR\"|g" tool > "$TOOL_LAUNCHER" 2>/dev/null || \
    { sudo bash -c "sed 's|TOOL_DIR=\"\$HOME/ShellTools\"|TOOL_DIR=\"$LIBDIR\"|g' tool > \"$TOOL_LAUNCHER\""; }

# Set permissions
chmod +x "$TOOL_LAUNCHER" 2>/dev/null || sudo chmod +x "$TOOL_LAUNCHER"

echo -e "${GREEN}✓ MacDevTools installed successfully!${NC}"
echo ""
echo "Run 'tool' to start."
if [[ "$PLATFORM" != "Darwin" ]]; then
    echo ""
    echo "💡 If '$BINDIR' is not in your PATH, add this to ~/.bashrc or ~/.profile:"
    echo "   export PATH=\"$BINDIR:\$PATH\""
fi
