#!/bin/bash

# MacDevTools Installation Script

PREFIX="${PREFIX:-/usr/local}"
BINDIR="${BINDIR:-$PREFIX/bin}"
LIBDIR="${LIBDIR:-$PREFIX/lib/shelltools}"

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

echo "Installing MacDevTools..."

# Create directories
mkdir -p "$BINDIR"
mkdir -p "$LIBDIR"

cp clean_*.sh "$LIBDIR/"
cp check_network.sh "$LIBDIR/"
cp port_killer.sh "$LIBDIR/"
cp dns_lookup.sh "$LIBDIR/"

sed "s|TOOL_DIR=\"\$HOME/ShellTools\"|TOOL_DIR=\"$LIBDIR\"|g" tool > "$BINDIR/tool"

# Set permissions
chmod +x "$BINDIR/tool"
chmod +x "$LIBDIR"/*.sh

echo -e "${GREEN}✓ MacDevTools installed successfully!${NC}"
echo ""
echo "Run 'tool' to start."
