#!/bin/bash

# MacDevTools - Terminal Toolkit
# Global command entry point

# Script directory (resolve symlinks to find actual install path)
SCRIPT_PATH="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_PATH" ]; do
    DIR="$(cd -P "$(dirname "$SCRIPT_PATH")" >/dev/null 2>&1 && pwd)"
    SCRIPT_PATH="$(readlink "$SCRIPT_PATH")"
    [[ $SCRIPT_PATH != /* ]] && SCRIPT_PATH="$DIR/$SCRIPT_PATH"
done
TOOL_DIR="$(cd -P "$(dirname "$SCRIPT_PATH")" >/dev/null 2>&1 && pwd)"

# Locate scripts if not co-located with tool (handles Homebrew/system install)
find_scripts_dir() {
    local base="$1"
    local candidates=(
        "$base"
        "${base%/bin}/libexec"
        "/usr/local/lib/shelltools"
        "/opt/homebrew/lib/shelltools"
        "/usr/lib/shelltools"
        "/usr/share/shelltools"
        "/opt/macdevtools/lib/shelltools"
    )
    for dir in "${candidates[@]}"; do
        if [ -f "$dir/clean_brew_cache.sh" ]; then
            echo "$dir"
            return
        fi
    done
    echo "$base"
}

TOOL_DIR="$(find_scripts_dir "$TOOL_DIR")"

# Platform detection
PLATFORM="$(uname -s)"   # Darwin | Linux

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
ORANGE='\033[38;5;208m'
PINK='\033[38;5;213m'
TEAL='\033[38;5;44m'
BOLD='\033[1m'
NC='\033[0m'

# Clear screen
clear_screen() {
    clear
}

# ASCII Art Logo
show_logo() {
    local palette=(${TEAL} ${CYAN} ${BLUE} ${PURPLE} ${PINK} ${ORANGE})
    local idx=0

    if [[ "$PLATFORM" == "Darwin" ]]; then
        local logo_lines=(
"    __  ___           ____           ______            __    "
"   /  |/  /___ ______/ __ \\___ _   _/_  __/___  ____  / /____"
"  / /|_/ / __ \`/ ___/ / / / _ \\ | / // / / __ \\/ __ \\/ / ___/"
" / /  / / /_/ / /__/ /_/ /  __/ |/ // / / /_/ / /_/ / (__  ) "
"/_/  /_/\\__,_/\\___/_____/\\___/|___//_/  \\____/\\____/_/____/  "
"        / /_  __  __       / (_)___ _____  ____ _            "
"       / __ \\/ / / /  __  / / / __ \`/ __ \\/ __ \`/            "
"      / /_/ / /_/ /  / /_/ / / /_/ / / / / /_/ /             "
"     /_.___/\\__, /   \\____/_/\\__,_/_/ /_/\\__, /              "
"           /____/                       /____/               "
        )
        for line in "${logo_lines[@]}"; do
            echo -e "${palette[$((idx % ${#palette[@]}))]}${line}${NC}"
            idx=$((idx + 1))
        done
    else
        local logo_lines=(
"    __    _                     ____               ______            __    "
"   / /   (_)___  __  ___  __   / __ \\___ _   __   /_  __/___  ____  / /____"
"  / /   / / __ \\/ / / / |/_/  / / / / _ \\ | / /    / / / __ \\/ __ \\/ / ___/"
" / /___/ / / / / /_/ />  <   / /_/ /  __/ |/ /    / / / /_/ / /_/ / (__  ) "
"/_____/_/_/ /_/\\__,_/_/|_|  /_____/\\___/|___/    /_/  \\____/\\____/_/____/  "
"            / /_  __  __       / (_)___ _____  ____ _                      "
"           / __ \\/ / / /  __  / / / __ \`/ __ \\/ __ \`/                      "
"          / /_/ / /_/ /  / /_/ / / /_/ / / / / /_/ /                       "
"         /_.___/\\__, /   \\____/_/\\__,_/_/ /_/\\__, /                        "
"               /____/                       /____/                         "
        )
        for line in "${logo_lines[@]}"; do
            echo -e "${palette[$((idx % ${#palette[@]}))]}${line}${NC}"
            idx=$((idx + 1))
        done
    fi

    echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if [[ "$PLATFORM" == "Darwin" ]]; then
        echo -e "${WHITE}${BOLD}              🛠️  Terminal Toolkit v1.2  |  macOS${NC}"
    else
        echo -e "${WHITE}${BOLD}              🛠️  Terminal Toolkit v1.2  |  Linux${NC}"
    fi
    echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Show main menu
show_menu() {
    local macos_tag=""
    if [[ "$PLATFORM" != "Darwin" ]]; then
        macos_tag=" ${GRAY}(macOS only)${NC}"
    fi

    echo -e "${ORANGE}${BOLD}  📦 Cache Cleanup${NC}"
    echo -e "     ${TEAL}1)${NC} ${WHITE}Homebrew Cache Cleanup${NC}"
    echo -e "     ${TEAL}2)${NC} ${WHITE}pip Cache Cleanup${NC}"
    echo -e "     ${TEAL}3)${NC} ${WHITE}npm/pnpm/yarn Cache Cleanup${NC}"
    echo -e "     ${TEAL}4)${NC} ${WHITE}Xcode Cache Cleanup${macos_tag}"
    echo -e "     ${TEAL}5)${NC} ${WHITE}Docker Cache Cleanup${NC}"
    echo -e "     ${TEAL}6)${NC} ${WHITE}Go Module Cache Cleanup${NC}"
    echo -e "     ${TEAL}7)${NC} ${WHITE}Cargo (Rust) Cache Cleanup${NC}"
    echo -e "     ${TEAL}8)${NC} ${WHITE}Ruby Gems Cache Cleanup${NC}"
    echo -e "     ${TEAL}9)${NC} ${WHITE}Steam Download Cache Cleanup${NC}"
    echo -e "     ${TEAL}10)${NC} ${WHITE}Apple TV Cache Cleanup${macos_tag}"
    echo -e "     ${TEAL}11)${NC} ${WHITE}Maven Local Repository Cleanup${NC}"
    echo -e "     ${TEAL}12)${NC} ${WHITE}Gradle Cache Cleanup${NC}"
    echo ""
    echo -e "${PINK}${BOLD}  🔧 System Tools${NC}"
    echo -e "     ${TEAL}13)${NC} ${WHITE}Network Connection Check${NC}"
    echo -e "     ${TEAL}14)${NC} ${WHITE}DNS Nameserver IPv4 Lookup${NC}"
    echo -e "     ${TEAL}15)${NC} ${WHITE}Port Usage Killer${NC}"
    echo -e "     ${TEAL}16)${NC} ${WHITE}Busy Build Simulator${NC}"
    echo -e "     ${TEAL}17)${NC} ${WHITE}Log File Cleanup${NC}"
    echo -e "     ${TEAL}18)${NC} ${WHITE}Disk Usage Analyzer${NC}"
    echo -e "     ${TEAL}19)${NC} ${WHITE}Package Outdated Checker${NC}"
    echo -e "     ${TEAL}20)${NC} ${WHITE}SSL Certificate Checker${NC}"
    echo ""
    echo -e "${YELLOW}${BOLD}  ⚡ Quick Actions${NC}"
    echo -e "     ${TEAL}a)${NC} ${WHITE}Clean All Caches${NC}"
    echo -e "     ${TEAL}l)${NC} ${WHITE}List All Listening Ports${NC}"
    echo -e "     ${TEAL}c)${NC} ${WHITE}Check Common Ports${NC}"
    echo ""
    echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "     ${TEAL}h)${NC} ${WHITE}Help${NC}    ${TEAL}q)${NC} ${WHITE}Quit${NC}"
    echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Run script
run_script() {
    local script=$1
    local script_path="$TOOL_DIR/$script"
    
    if [ -f "$script_path" ]; then
        echo ""
        echo -e "${CYAN}▶ Running $script${NC}"
        echo ""
        bash "$script_path"
        echo ""
        echo -e "${GREEN}✓ Done${NC}"
    else
        echo -e "${RED}✗ Script not found: $script_path${NC}"
    fi
    
    echo ""
    read -p "Press Enter to return to menu..."
}

# Clean all caches
clean_all() {
    echo ""
    echo -e "${YELLOW}⚠️  About to clean all caches, this may take some time${NC}"
    echo ""
    read -p "Continue? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled"
        return
    fi
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Homebrew
    if command -v brew &> /dev/null; then
        echo -e "\n${YELLOW}[1/10] Cleaning Homebrew...${NC}"
        brew cleanup -s 2>/dev/null || true
    fi
    
    # pip
    if command -v pip3 &> /dev/null; then
        echo -e "\n${YELLOW}[2/10] Cleaning pip...${NC}"
        pip3 cache purge 2>/dev/null || true
    fi
    
    # npm
    if command -v npm &> /dev/null; then
        echo -e "\n${YELLOW}[3/10] Cleaning npm...${NC}"
        npm cache clean --force 2>/dev/null || true
    fi
    
    # pnpm
    if command -v pnpm &> /dev/null; then
        echo -e "\n${YELLOW}[4/10] Cleaning pnpm...${NC}"
        pnpm store prune 2>/dev/null || true
    fi
    
    # yarn
    if command -v yarn &> /dev/null; then
        echo -e "\n${YELLOW}[5/10] Cleaning yarn...${NC}"
        yarn cache clean 2>/dev/null || true
    fi
    
    # Go
    if command -v go &> /dev/null; then
        echo -e "\n${YELLOW}[6/10] Cleaning Go...${NC}"
        go clean -cache 2>/dev/null || true
    fi
    
    # Cargo
    if command -v cargo &> /dev/null; then
        echo -e "\n${YELLOW}[7/10] Cleaning Cargo...${NC}"
        CARGO_REGISTRY="$HOME/.cargo/registry"
        rm -rf "$CARGO_REGISTRY/cache"/* 2>/dev/null || true
        rm -rf "$CARGO_REGISTRY/src"/* 2>/dev/null || true
    fi

    # Maven
    M2_SNAP="$HOME/.m2/repository"
    if [ -d "$M2_SNAP" ]; then
        echo -e "\n${YELLOW}[8/10] Cleaning Maven snapshots...${NC}"
        find "$M2_SNAP" -name "_remote.repositories" -delete 2>/dev/null || true
        find "$M2_SNAP" -name "*.lastUpdated" -delete 2>/dev/null || true
        find "$M2_SNAP" -name "*.part" -delete 2>/dev/null || true
    fi

    # Gradle
    GRADLE_HOME="${GRADLE_USER_HOME:-$HOME/.gradle}"
    if [ -d "$GRADLE_HOME" ]; then
        echo -e "\n${YELLOW}[9/10] Cleaning Gradle build cache...${NC}"
        rm -rf "$GRADLE_HOME"/caches/build-cache-* 2>/dev/null || true
        find "$GRADLE_HOME/daemon" -name "*.log" -delete 2>/dev/null || true
    fi

    # Xcode DerivedData (macOS only)
    if [[ "$(uname -s)" == "Darwin" ]]; then
        DERIVED_DATA="$HOME/Library/Developer/Xcode/DerivedData"
        if [ -d "$DERIVED_DATA" ]; then
            echo -e "\n${YELLOW}[10/10] Cleaning Xcode DerivedData...${NC}"
            rm -rf "$DERIVED_DATA"/* 2>/dev/null || true
        fi
    fi
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ All caches cleaned!${NC}"
    echo ""
    read -p "Press Enter to return to menu..."
}

# Show help
show_help() {
    clear_screen
    show_logo
    echo -e "${WHITE}Usage${NC}"
    echo ""
    echo -e "  ${CYAN}tool${NC}              Launch interactive menu"
    echo -e "  ${CYAN}tool brew${NC}         Clean Homebrew cache"
    echo -e "  ${CYAN}tool pip${NC}          Clean pip cache"
    echo -e "  ${CYAN}tool node${NC}         Clean npm/pnpm/yarn cache"
    echo -e "  ${CYAN}tool xcode${NC}        Clean Xcode cache ${GRAY}(macOS only)${NC}"
    echo -e "  ${CYAN}tool docker${NC}       Clean Docker cache"
    echo -e "  ${CYAN}tool steam${NC}        Clean Steam download cache"
    echo -e "  ${CYAN}tool appletv${NC}      Clean Apple TV cache ${GRAY}(macOS only)${NC}"
    echo -e "  ${CYAN}tool go${NC}           Clean Go cache"
    echo -e "  ${CYAN}tool cargo${NC}        Clean Cargo cache"
    echo -e "  ${CYAN}tool gem${NC}          Clean Ruby Gems cache"
    echo -e "  ${CYAN}tool maven${NC}        Clean Maven local repository"
    echo -e "  ${CYAN}tool gradle${NC}       Clean Gradle cache"
    echo -e "  ${CYAN}tool network${NC}      Network connection check"
    echo -e "  ${CYAN}tool dns <domain>${NC} Lookup domain nameserver IPv4"
    echo -e "  ${CYAN}tool port [port]${NC}  Port usage killer"
    echo -e "  ${CYAN}tool busy [seconds]${NC} Fake busy compile/build logs"
    echo -e "  ${CYAN}tool logs${NC}         Clean log files"
    echo -e "  ${CYAN}tool disk${NC}         Analyze disk usage"
    echo -e "  ${CYAN}tool outdated${NC}     Check outdated packages"
    echo -e "  ${CYAN}tool ssl <domain>${NC} Check SSL certificate"
    echo -e "  ${CYAN}tool all${NC}          Clean all caches"
    echo -e "  ${CYAN}tool help${NC}         Show help"
    echo ""
    read -p "Press Enter to return to menu..."
}

# CLI mode
cli_mode() {
    case "$1" in
        brew)
            bash "$TOOL_DIR/clean_brew_cache.sh"
            ;;
        pip)
            bash "$TOOL_DIR/clean_pip_cache.sh"
            ;;
        node|npm)
            bash "$TOOL_DIR/clean_node_cache.sh"
            ;;
        xcode)
            bash "$TOOL_DIR/clean_xcode_cache.sh"
            ;;
        docker)
            bash "$TOOL_DIR/clean_docker_cache.sh"
            ;;
        steam)
            bash "$TOOL_DIR/clean_steam_cache.sh"
            ;;
        appletv|tv)
            bash "$TOOL_DIR/clean_appletv_cache.sh"
            ;;
        dns)
            shift
            bash "$TOOL_DIR/dns_lookup.sh" "$@"
            ;;
        go)
            bash "$TOOL_DIR/clean_go_cache.sh"
            ;;
        cargo|rust)
            bash "$TOOL_DIR/clean_cargo_cache.sh"
            ;;
        gem|ruby)
            bash "$TOOL_DIR/clean_gem_cache.sh"
            ;;
        maven|mvn)
            bash "$TOOL_DIR/clean_maven_cache.sh"
            ;;
        gradle)
            bash "$TOOL_DIR/clean_gradle_cache.sh"
            ;;
        network|net)
            bash "$TOOL_DIR/check_network.sh"
            ;;
        port)
            shift
            bash "$TOOL_DIR/port_killer.sh" "$@"
            ;;
        busy|fakebuild|work)
            shift
            bash "$TOOL_DIR/fake_busy_build.sh" "$@"
            ;;
        logs|log)
            bash "$TOOL_DIR/clean_logs.sh"
            ;;
        disk)
            bash "$TOOL_DIR/disk_usage.sh"
            ;;
        outdated|update|updates)
            bash "$TOOL_DIR/pkg_outdated.sh"
            ;;
        ssl)
            shift
            bash "$TOOL_DIR/ssl_check.sh" "$@"
            ;;
        all)
            clean_all
            ;;
        help|-h|--help)
            echo ""
            echo "MacDevTools - Terminal Toolkit"
            echo ""
            echo "Usage: tool [command] [args]"
            echo ""
            echo "Commands:"
            echo "  brew      Clean Homebrew cache"
            echo "  pip       Clean pip cache"
            echo "  node      Clean npm/pnpm/yarn cache"
            echo "  xcode     Clean Xcode cache"
            echo "  docker    Clean Docker cache"
            echo "  go        Clean Go cache"
            echo "  cargo     Clean Cargo cache"
            echo "  gem       Clean Ruby Gems cache"
            echo "  maven     Clean Maven local repository"
            echo "  gradle    Clean Gradle cache"
            echo "  network   Network connection check"
            echo "  port      Port usage killer"
            echo "  busy      Fake busy compile/build logs"
            echo "  logs      Clean log files"
            echo "  disk      Analyze disk usage"
            echo "  outdated  Check outdated packages"
            echo "  ssl       Check SSL certificate"
            echo "  all       Clean all caches"
            echo "  help      Show help"
            echo ""
            echo "Run 'tool' without arguments for interactive menu"
            echo ""
            ;;
        *)
            echo "Unknown command: $1"
            echo "Run 'tool help' for usage"
            exit 1
            ;;
    esac
}

# Interactive mode
interactive_mode() {
    while true; do
        clear_screen
        show_logo
        show_menu
        
        read -p "Select option: " -n 2 choice
        echo ""
        
        case $choice in
            1)
                run_script "clean_brew_cache.sh"
                ;;
            2)
                run_script "clean_pip_cache.sh"
                ;;
            3)
                run_script "clean_node_cache.sh"
                ;;
            4)
                run_script "clean_xcode_cache.sh"
                ;;
            5)
                run_script "clean_docker_cache.sh"
                ;;
            6)
                run_script "clean_go_cache.sh"
                ;;
            7)
                run_script "clean_cargo_cache.sh"
                ;;
            8)
                run_script "clean_gem_cache.sh"
                ;;
            9)
                run_script "clean_steam_cache.sh"
                ;;
            10)
                run_script "clean_appletv_cache.sh"
                ;;
            11)
                run_script "clean_maven_cache.sh"
                ;;
            12)
                run_script "clean_gradle_cache.sh"
                ;;
            13)
                run_script "check_network.sh"
                ;;
            14)
                echo ""
                read -p "Enter domain to lookup (leave empty to input interactively): " domain
                echo ""
                if [ -n "$domain" ]; then
                    bash "$TOOL_DIR/dns_lookup.sh" "$domain"
                else
                    bash "$TOOL_DIR/dns_lookup.sh"
                fi
                echo ""
                read -p "Press Enter to return to menu..."
                ;;
            15)
                echo ""
                read -p "Enter port number (or press Enter for interactive mode): " port
                if [ -n "$port" ]; then
                    bash "$TOOL_DIR/port_killer.sh" "$port"
                else
                    bash "$TOOL_DIR/port_killer.sh"
                fi
                echo ""
                read -p "Press Enter to return to menu..."
                ;;
            16)
                echo ""
                read -p "How many seconds to simulate? (default 45): " secs
                if [ -n "$secs" ]; then
                    bash "$TOOL_DIR/fake_busy_build.sh" build "$secs"
                else
                    bash "$TOOL_DIR/fake_busy_build.sh"
                fi
                echo ""
                read -p "Press Enter to return to menu..."
                ;;
            17)
                run_script "clean_logs.sh"
                ;;
            18)
                run_script "disk_usage.sh"
                ;;
            19)
                run_script "pkg_outdated.sh"
                ;;
            20)
                echo ""
                read -p "Enter domain(s) to check (e.g. github.com example.com:8443): " domains
                echo ""
                if [ -n "$domains" ]; then
                    bash "$TOOL_DIR/ssl_check.sh" $domains
                else
                    bash "$TOOL_DIR/ssl_check.sh"
                fi
                echo ""
                read -p "Press Enter to return to menu..."
                ;;
            a|A)
                clean_all
                ;;
            l|L)
                echo ""
                bash "$TOOL_DIR/port_killer.sh" -l
                echo ""
                read -p "Press Enter to return to menu..."
                ;;
            c|C)
                echo ""
                bash "$TOOL_DIR/port_killer.sh" -c
                echo ""
                read -p "Press Enter to return to menu..."
                ;;
            h|H)
                show_help
                ;;
            q|Q)
                echo ""
                echo -e "${GREEN}Goodbye! 👋${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# Main entry
if [ $# -eq 0 ]; then
    interactive_mode
else
    cli_mode "$@"
fi
