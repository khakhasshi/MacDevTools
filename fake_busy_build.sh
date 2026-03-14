#!/bin/bash

# Fake Busy Build Simulator
# Pretend to compile/build with realistic logs for focus mode.

set -e

MODE="${1:-build}"
DURATION="${2:-45}"

if [[ "$MODE" =~ ^[0-9]+$ ]]; then
    DURATION="$MODE"
    MODE="build"
fi

if ! [[ "$DURATION" =~ ^[0-9]+$ ]]; then
    echo "Usage: $0 [build|compile|test] [seconds]"
    echo "Example: $0 build 60"
    exit 1
fi

if [ "$DURATION" -lt 10 ]; then
    DURATION=10
fi
if [ "$DURATION" -gt 600 ]; then
    DURATION=600
fi

case "$MODE" in
    build|compile|test)
        ;;
    *)
        echo "Unknown mode: $MODE"
        echo "Supported modes: build, compile, test"
        exit 1
        ;;
esac

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

phases=(
    "Resolving dependencies"
    "Generating build graph"
    "Compiling source units"
    "Linking binaries"
    "Running smoke tests"
    "Optimizing artifacts"
    "Packaging outputs"
)

units=(core api cli worker cache net io parser runtime)
exts=(c cpp rs go ts py)

printf "\n${CYAN}🛠️  Busy Build Simulator${NC}\n"
printf "${GRAY}Mode: %s | Duration: %ss${NC}\n\n" "$MODE" "$DURATION"

start_ts=$(date +%s)
end_ts=$((start_ts + DURATION))
line_no=1

while [ "$(date +%s)" -lt "$end_ts" ]; do
    now=$(date +%s)
    elapsed=$((now - start_ts))
    percent=$((elapsed * 100 / DURATION))

    phase_idx=$((RANDOM % ${#phases[@]}))
    unit_idx=$((RANDOM % ${#units[@]}))
    ext_idx=$((RANDOM % ${#exts[@]}))

    ts=$(date +"%H:%M:%S")
    file="${units[$unit_idx]}_${line_no}.${exts[$ext_idx]}"

    if [ "$percent" -ge 100 ]; then
        percent=99
    fi

    echo -e "${GRAY}[${ts}]${NC} ${BLUE}[${percent}%]${NC} ${YELLOW}${phases[$phase_idx]}${NC} -> ${file}"

    line_no=$((line_no + 1))
    sleep 1

done

echo ""
echo -e "${GREEN}✓ Build finished successfully${NC}"
echo -e "${CYAN}Summary:${NC}"
echo "  - Mode: $MODE"
echo "  - Duration: ${DURATION}s"
echo "  - Output: 0 errors, 0 warnings"
echo "  - Artifact: dist/app-$(date +%Y%m%d-%H%M).tar.gz"
echo ""
