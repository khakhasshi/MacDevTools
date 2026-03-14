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

# UI language (default: English)
LANG_CONFIG_FILE="${HOME}/.macdevtools_lang"
LANG_UI="en"
if [ -f "$LANG_CONFIG_FILE" ]; then
    saved_lang="$(tr -d '[:space:]' < "$LANG_CONFIG_FILE" 2>/dev/null || true)"
    case "$saved_lang" in
        en|zh|ja) LANG_UI="$saved_lang" ;;
    esac
fi

# i18n helper
t() {
    local key="$1"
    case "$LANG_UI:$key" in
        en:app_title) echo "Terminal Toolkit" ;;
        zh:app_title) echo "终端工具集" ;;
        ja:app_title) echo "ターミナルツールキット" ;;

        en:subtitle) echo "System Maintenance & Dev Utilities" ;;
        zh:subtitle) echo "系统维护与开发工具" ;;
        ja:subtitle) echo "システム保守と開発ユーティリティ" ;;

        en:category_cache) echo "📦 Cache Cleanup" ;;
        zh:category_cache) echo "📦 缓存清理" ;;
        ja:category_cache) echo "📦 キャッシュクリーンアップ" ;;

        en:category_system) echo "🔧 System Tools" ;;
        zh:category_system) echo "🔧 系统工具" ;;
        ja:category_system) echo "🔧 システムツール" ;;

        en:category_quick) echo "⚡ Quick Actions" ;;
        zh:category_quick) echo "⚡ 快捷操作" ;;
        ja:category_quick) echo "⚡ クイック操作" ;;

        en:menu_help) echo "Help" ;;
        zh:menu_help) echo "帮助" ;;
        ja:menu_help) echo "ヘルプ" ;;

        en:menu_quit) echo "Quit" ;;
        zh:menu_quit) echo "退出" ;;
        ja:menu_quit) echo "終了" ;;

        en:menu_language) echo "Language" ;;
        zh:menu_language) echo "语言" ;;
        ja:menu_language) echo "言語" ;;

        en:lang_status) echo "Language" ;;
        zh:lang_status) echo "当前语言" ;;
        ja:lang_status) echo "現在の言語" ;;

        en:lang_en) echo "English" ;;
        zh:lang_en) echo "英语" ;;
        ja:lang_en) echo "英語" ;;

        en:lang_zh) echo "中文" ;;
        zh:lang_zh) echo "中文" ;;
        ja:lang_zh) echo "中国語" ;;

        en:lang_ja) echo "日本語" ;;
        zh:lang_ja) echo "日语" ;;
        ja:lang_ja) echo "日本語" ;;

        en:prompt_select) echo "Select option" ;;
        zh:prompt_select) echo "请选择" ;;
        ja:prompt_select) echo "選択してください" ;;

        en:prompt_press_enter) echo "Press Enter to return to menu..." ;;
        zh:prompt_press_enter) echo "按回车返回菜单..." ;;
        ja:prompt_press_enter) echo "Enterキーでメニューに戻る..." ;;

        en:running) echo "Running" ;;
        zh:running) echo "执行中" ;;
        ja:running) echo "実行中" ;;

        en:done) echo "Done" ;;
        zh:done) echo "完成" ;;
        ja:done) echo "完了" ;;

        en:script_not_found) echo "Script not found" ;;
        zh:script_not_found) echo "脚本不存在" ;;
        ja:script_not_found) echo "スクリプトが見つかりません" ;;

        en:invalid_option) echo "Invalid option" ;;
        zh:invalid_option) echo "无效选项" ;;
        ja:invalid_option) echo "無効な選択です" ;;

        en:goodbye) echo "Goodbye! 👋" ;;
        zh:goodbye) echo "再见！👋" ;;
        ja:goodbye) echo "さようなら！👋" ;;

        en:unknown_command) echo "Unknown command" ;;
        zh:unknown_command) echo "未知命令" ;;
        ja:unknown_command) echo "不明なコマンド" ;;

        en:run_help_tip) echo "Run 'tool help' for usage" ;;
        zh:run_help_tip) echo "运行 'tool help' 查看用法" ;;
        ja:run_help_tip) echo "使い方は 'tool help' を実行してください" ;;

        en:language_title) echo "UI Language" ;;
        zh:language_title) echo "界面语言" ;;
        ja:language_title) echo "UI言語" ;;

        en:language_changed) echo "Language switched" ;;
        zh:language_changed) echo "语言已切换" ;;
        ja:language_changed) echo "言語を切り替えました" ;;

        en:language_invalid) echo "Invalid language choice" ;;
        zh:language_invalid) echo "语言选项无效" ;;
        ja:language_invalid) echo "言語の選択が無効です" ;;

        en:help_usage) echo "Usage" ;;
        zh:help_usage) echo "用法" ;;
        ja:help_usage) echo "使い方" ;;

        en:help_menu_tip) echo "Run 'tool' without arguments for interactive menu" ;;
        zh:help_menu_tip) echo "不带参数运行 'tool' 可进入交互菜单" ;;
        ja:help_menu_tip) echo "引数なしで 'tool' を実行すると対話メニューを開きます" ;;

        en:menu_item_1) echo "Homebrew Cache Cleanup" ;;
        zh:menu_item_1) echo "Homebrew 缓存清理" ;;
        ja:menu_item_1) echo "Homebrew キャッシュクリーンアップ" ;;
        en:menu_item_2) echo "pip Cache Cleanup" ;;
        zh:menu_item_2) echo "pip 缓存清理" ;;
        ja:menu_item_2) echo "pip キャッシュクリーンアップ" ;;
        en:menu_item_3) echo "npm/pnpm/yarn Cache Cleanup" ;;
        zh:menu_item_3) echo "npm/pnpm/yarn 缓存清理" ;;
        ja:menu_item_3) echo "npm/pnpm/yarn キャッシュクリーンアップ" ;;
        en:menu_item_4) echo "Xcode Cache Cleanup" ;;
        zh:menu_item_4) echo "Xcode 缓存清理" ;;
        ja:menu_item_4) echo "Xcode キャッシュクリーンアップ" ;;
        en:menu_item_5) echo "Docker Cache Cleanup" ;;
        zh:menu_item_5) echo "Docker 缓存清理" ;;
        ja:menu_item_5) echo "Docker キャッシュクリーンアップ" ;;
        en:menu_item_6) echo "Go Module Cache Cleanup" ;;
        zh:menu_item_6) echo "Go 模块缓存清理" ;;
        ja:menu_item_6) echo "Go モジュールキャッシュクリーンアップ" ;;
        en:menu_item_7) echo "Cargo (Rust) Cache Cleanup" ;;
        zh:menu_item_7) echo "Cargo (Rust) 缓存清理" ;;
        ja:menu_item_7) echo "Cargo (Rust) キャッシュクリーンアップ" ;;
        en:menu_item_8) echo "Ruby Gems Cache Cleanup" ;;
        zh:menu_item_8) echo "Ruby Gems 缓存清理" ;;
        ja:menu_item_8) echo "Ruby Gems キャッシュクリーンアップ" ;;
        en:menu_item_9) echo "Steam Download Cache Cleanup" ;;
        zh:menu_item_9) echo "Steam 下载缓存清理" ;;
        ja:menu_item_9) echo "Steam ダウンロードキャッシュクリーンアップ" ;;
        en:menu_item_10) echo "Apple TV Cache Cleanup" ;;
        zh:menu_item_10) echo "Apple TV 缓存清理" ;;
        ja:menu_item_10) echo "Apple TV キャッシュクリーンアップ" ;;
        en:menu_item_11) echo "Maven Local Repository Cleanup" ;;
        zh:menu_item_11) echo "Maven 本地仓库清理" ;;
        ja:menu_item_11) echo "Maven ローカルリポジトリクリーンアップ" ;;
        en:menu_item_12) echo "Gradle Cache Cleanup" ;;
        zh:menu_item_12) echo "Gradle 缓存清理" ;;
        ja:menu_item_12) echo "Gradle キャッシュクリーンアップ" ;;
        en:menu_item_13) echo "Network Connection Check" ;;
        zh:menu_item_13) echo "网络连接检查" ;;
        ja:menu_item_13) echo "ネットワーク接続チェック" ;;
        en:menu_item_14) echo "DNS Nameserver IPv4 Lookup" ;;
        zh:menu_item_14) echo "DNS NS IPv4 查询" ;;
        ja:menu_item_14) echo "DNS NS IPv4 ルックアップ" ;;
        en:menu_item_15) echo "Port Usage Killer" ;;
        zh:menu_item_15) echo "端口占用查杀" ;;
        ja:menu_item_15) echo "ポート使用プロセス終了" ;;
        en:menu_item_16) echo "Busy Build Simulator" ;;
        zh:menu_item_16) echo "繁忙构建模拟器" ;;
        ja:menu_item_16) echo "ビジービルドシミュレーター" ;;
        en:menu_item_17) echo "Log File Cleanup" ;;
        zh:menu_item_17) echo "日志文件清理" ;;
        ja:menu_item_17) echo "ログファイルクリーンアップ" ;;
        en:menu_item_18) echo "Disk Usage Analyzer" ;;
        zh:menu_item_18) echo "磁盘占用分析" ;;
        ja:menu_item_18) echo "ディスク使用量分析" ;;
        en:menu_item_19) echo "Package Outdated Checker" ;;
        zh:menu_item_19) echo "过期包检查" ;;
        ja:menu_item_19) echo "古いパッケージ確認" ;;
        en:menu_item_20) echo "SSL Certificate Checker" ;;
        zh:menu_item_20) echo "SSL 证书检查" ;;
        ja:menu_item_20) echo "SSL 証明書チェック" ;;
        en:menu_item_21) echo "Traceroute (Formatted + Latency Spike Marking)" ;;
        zh:menu_item_21) echo "Traceroute（格式化+延迟异常跳标注）" ;;
        ja:menu_item_21) echo "Traceroute（整形表示+遅延スパイク表示）" ;;
        en:menu_item_22) echo "Wi-Fi Details" ;;
        zh:menu_item_22) echo "Wi-Fi 详情" ;;
        ja:menu_item_22) echo "Wi-Fi 詳細" ;;
        en:menu_item_23) echo "System Information Summary" ;;
        zh:menu_item_23) echo "系统信息总览" ;;
        ja:menu_item_23) echo "システム情報サマリー" ;;
        en:menu_item_24) echo "Top Processes (CPU/Memory)" ;;
        zh:menu_item_24) echo "进程排行（CPU/内存）" ;;
        ja:menu_item_24) echo "上位プロセス（CPU/メモリ）" ;;
        en:menu_action_all) echo "Clean All Caches" ;;
        zh:menu_action_all) echo "清理所有缓存" ;;
        ja:menu_action_all) echo "全キャッシュをクリーン" ;;
        en:menu_action_ports) echo "List All Listening Ports" ;;
        zh:menu_action_ports) echo "列出全部监听端口" ;;
        ja:menu_action_ports) echo "リッスン中ポート一覧" ;;
        en:menu_action_common_ports) echo "Check Common Ports" ;;
        zh:menu_action_common_ports) echo "检查常用端口" ;;
        ja:menu_action_common_ports) echo "よく使うポートを確認" ;;

        *) echo "$key" ;;
    esac
}

show_current_lang() {
    case "$LANG_UI" in
        en) echo "English" ;;
        zh) echo "中文" ;;
        ja) echo "日本語" ;;
        *) echo "English" ;;
    esac
}

set_language() {
    echo ""
    echo -e "${BOLD}$(t language_title)${NC}"
    echo "  1) English"
    echo "  2) 中文"
    echo "  3) 日本語"
    echo ""
    read -p "Select [1-3]: " lang_choice
    case "$lang_choice" in
        1|en|EN|En|e|E) LANG_UI="en" ;;
        2|zh|ZH|Zh|z|Z|cn|CN|Cn) LANG_UI="zh" ;;
        3|ja|JA|Ja|j|J|jp|JP|Jp) LANG_UI="ja" ;;
        *)
            echo -e "${RED}✗ $(t language_invalid)${NC}"
            return
            ;;
    esac
    printf "%s\n" "$LANG_UI" > "$LANG_CONFIG_FILE" 2>/dev/null || true
    echo -e "${GREEN}✓ $(t language_changed): $(show_current_lang)${NC}"
}

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
        echo -e "${WHITE}${BOLD}              🛠️  $(t app_title) v1.3  |  macOS${NC}"
    else
        echo -e "${WHITE}${BOLD}              🛠️  $(t app_title) v1.3  |  Linux${NC}"
    fi
    echo -e "${GRAY}              $(t subtitle)${NC}"
    echo -e "${GRAY}              $(t lang_status): $(show_current_lang)${NC}"
    echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Show main menu
show_menu() {
    local macos_tag=""
    if [[ "$PLATFORM" != "Darwin" ]]; then
        macos_tag=" ${GRAY}(macOS only)${NC}"
    fi

    echo -e "${ORANGE}${BOLD}  $(t category_cache)${NC}"
    echo -e "     ${TEAL}1)${NC} ${WHITE}$(t menu_item_1)${NC}"
    echo -e "     ${TEAL}2)${NC} ${WHITE}$(t menu_item_2)${NC}"
    echo -e "     ${TEAL}3)${NC} ${WHITE}$(t menu_item_3)${NC}"
    echo -e "     ${TEAL}4)${NC} ${WHITE}$(t menu_item_4)${macos_tag}"
    echo -e "     ${TEAL}5)${NC} ${WHITE}$(t menu_item_5)${NC}"
    echo -e "     ${TEAL}6)${NC} ${WHITE}$(t menu_item_6)${NC}"
    echo -e "     ${TEAL}7)${NC} ${WHITE}$(t menu_item_7)${NC}"
    echo -e "     ${TEAL}8)${NC} ${WHITE}$(t menu_item_8)${NC}"
    echo -e "     ${TEAL}9)${NC} ${WHITE}$(t menu_item_9)${NC}"
    echo -e "     ${TEAL}10)${NC} ${WHITE}$(t menu_item_10)${macos_tag}"
    echo -e "     ${TEAL}11)${NC} ${WHITE}$(t menu_item_11)${NC}"
    echo -e "     ${TEAL}12)${NC} ${WHITE}$(t menu_item_12)${NC}"
    echo ""
    echo -e "${PINK}${BOLD}  $(t category_system)${NC}"
    echo -e "     ${TEAL}13)${NC} ${WHITE}$(t menu_item_13)${NC}"
    echo -e "     ${TEAL}14)${NC} ${WHITE}$(t menu_item_14)${NC}"
    echo -e "     ${TEAL}15)${NC} ${WHITE}$(t menu_item_15)${NC}"
    echo -e "     ${TEAL}16)${NC} ${WHITE}$(t menu_item_16)${NC}"
    echo -e "     ${TEAL}17)${NC} ${WHITE}$(t menu_item_17)${NC}"
    echo -e "     ${TEAL}18)${NC} ${WHITE}$(t menu_item_18)${NC}"
    echo -e "     ${TEAL}19)${NC} ${WHITE}$(t menu_item_19)${NC}"
    echo -e "     ${TEAL}20)${NC} ${WHITE}$(t menu_item_20)${NC}"
    echo -e "     ${TEAL}21)${NC} ${WHITE}$(t menu_item_21)${NC}"
    echo -e "     ${TEAL}22)${NC} ${WHITE}$(t menu_item_22)${macos_tag}"
    echo -e "     ${TEAL}23)${NC} ${WHITE}$(t menu_item_23)${NC}"
    echo -e "     ${TEAL}24)${NC} ${WHITE}$(t menu_item_24)${NC}"
    echo ""
    echo -e "${YELLOW}${BOLD}  $(t category_quick)${NC}"
    echo -e "     ${TEAL}a)${NC} ${WHITE}$(t menu_action_all)${NC}"
    echo -e "     ${TEAL}l)${NC} ${WHITE}$(t menu_action_ports)${NC}"
    echo -e "     ${TEAL}c)${NC} ${WHITE}$(t menu_action_common_ports)${NC}"
    echo -e "     ${TEAL}g)${NC} ${WHITE}$(t menu_language)${NC}"
    echo ""
    echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "     ${TEAL}h)${NC} ${WHITE}$(t menu_help)${NC}    ${TEAL}q)${NC} ${WHITE}$(t menu_quit)${NC}"
    echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Run script
run_script() {
    local script=$1
    local script_path="$TOOL_DIR/$script"
    
    if [ -f "$script_path" ]; then
        echo ""
        echo -e "${CYAN}▶ $(t running) $script${NC}"
        echo ""
        bash "$script_path"
        echo ""
        echo -e "${GREEN}✓ $(t done)${NC}"
    else
        echo -e "${RED}✗ $(t script_not_found): $script_path${NC}"
    fi
    
    echo ""
    read -p "$(t prompt_press_enter)"
}

# Clean all caches
clean_all() {
    echo ""
    echo -e "${YELLOW}⚠️  $(t menu_action_all), this may take some time${NC}"
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
    echo -e "${GREEN}✓ $(t menu_action_all)!${NC}"
    echo ""
    read -p "$(t prompt_press_enter)"
}

# Show help
show_help() {
    clear_screen
    show_logo
    echo -e "${WHITE}$(t help_usage)${NC}"
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
    echo -e "  ${CYAN}tool traceroute <host> [max_hops]${NC} Formatted traceroute + RTT spike marking"
    echo -e "  ${CYAN}tool wifi${NC}         Show current Wi-Fi details ${GRAY}(macOS only)${NC}"
    echo -e "  ${CYAN}tool sysinfo${NC}      Show CPU/memory/disk/GPU/OS/battery summary"
    echo -e "  ${CYAN}tool topproc [options]${NC} Show top CPU/memory processes"
    echo -e "  ${CYAN}tool all${NC}          Clean all caches"
    echo -e "  ${CYAN}tool help${NC}         Show help"
    echo ""
    read -p "$(t prompt_press_enter)"
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
        traceroute|trace|tr)
            shift
            bash "$TOOL_DIR/traceroute_wrapper.sh" "$@"
            ;;
        wifi)
            bash "$TOOL_DIR/wifi_info.sh"
            ;;
        sysinfo|system|info)
            bash "$TOOL_DIR/sysinfo.sh"
            ;;
        topproc|top)
            shift
            bash "$TOOL_DIR/top_processes.sh" "$@"
            ;;
        all)
            clean_all
            ;;
        help|-h|--help)
            echo ""
            echo "MacDevTools - $(t app_title)"
            echo ""
            echo "$(t help_usage): tool [command] [args]"
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
            echo "  traceroute Formatted traceroute + latency spike marking"
            echo "  wifi      Show current Wi-Fi details (macOS only)"
            echo "  sysinfo   Show CPU/memory/disk/GPU/OS/battery summary"
            echo "  topproc   Show top CPU/memory processes"
            echo "  lang      Switch UI language: en|zh|ja"
            echo "  all       Clean all caches"
            echo "  help      Show help"
            echo ""
            echo "$(t help_menu_tip)"
            echo ""
            ;;
        lang)
            shift
            case "$1" in
                en|zh|ja)
                    LANG_UI="$1"
                    printf "%s\n" "$LANG_UI" > "$LANG_CONFIG_FILE" 2>/dev/null || true
                    echo -e "${GREEN}✓ $(t language_changed): $(show_current_lang)${NC}"
                    ;;
                *)
                    set_language
                    ;;
            esac
            ;;
        *)
            echo "$(t unknown_command): $1"
            echo "$(t run_help_tip)"
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
        
        read -p "$(t prompt_select): " -n 2 choice
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
                read -p "$(t prompt_press_enter)"
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
                read -p "$(t prompt_press_enter)"
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
                read -p "$(t prompt_press_enter)"
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
                read -p "$(t prompt_press_enter)"
                ;;
            21)
                echo ""
                read -p "Enter host to trace (hostname or IP): " host
                read -p "Maximum hops (default 30): " max_hops
                echo ""
                if [ -n "$host" ] && [ -n "$max_hops" ]; then
                    bash "$TOOL_DIR/traceroute_wrapper.sh" "$host" "$max_hops"
                elif [ -n "$host" ]; then
                    bash "$TOOL_DIR/traceroute_wrapper.sh" "$host"
                else
                    bash "$TOOL_DIR/traceroute_wrapper.sh"
                fi
                echo ""
                read -p "$(t prompt_press_enter)"
                ;;
            22)
                run_script "wifi_info.sh"
                ;;
            23)
                run_script "sysinfo.sh"
                ;;
            24)
                echo ""
                read -p "Sort by [c]pu or [m]emory? (default: c): " sort_key
                read -p "Top N processes (default: 15): " top_n
                read -p "Watch mode? (y/N): " watch_mode
                echo ""

                topproc_args=()
                if [[ "$sort_key" =~ ^[Mm]$ ]]; then
                    topproc_args+=("-m")
                fi
                if [ -n "$top_n" ]; then
                    topproc_args+=("-n" "$top_n")
                fi
                if [[ "$watch_mode" =~ ^[Yy]$ ]]; then
                    topproc_args+=("-w")
                fi

                bash "$TOOL_DIR/top_processes.sh" "${topproc_args[@]}"
                echo ""
                read -p "$(t prompt_press_enter)"
                ;;
            a|A)
                clean_all
                ;;
            l|L)
                echo ""
                bash "$TOOL_DIR/port_killer.sh" -l
                echo ""
                read -p "$(t prompt_press_enter)"
                ;;
            c|C)
                echo ""
                bash "$TOOL_DIR/port_killer.sh" -c
                echo ""
                read -p "$(t prompt_press_enter)"
                ;;
            g|G)
                set_language
                echo ""
                read -p "$(t prompt_press_enter)"
                ;;
            h|H)
                show_help
                ;;
            q|Q)
                echo ""
                echo -e "${GREEN}$(t goodbye)${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${RED}$(t invalid_option)${NC}"
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
