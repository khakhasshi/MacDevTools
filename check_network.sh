#!/bin/bash

# Network Connection Check Script
# Diagnose network connection issues

set -e

echo "🌐 Network Connection Check Tool"
echo "================================="

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check results
pass() { echo -e "   ${GREEN}✓${NC} $1"; }
fail() { echo -e "   ${RED}✗${NC} $1"; }
warn() { echo -e "   ${YELLOW}⚠${NC} $1"; }

# 1. Check network interface
echo ""
echo "📡 Network Interface Status:"
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    ACTIVE_IF=$(route get default 2>/dev/null | grep interface | awk '{print $2}')
    if [ -n "$ACTIVE_IF" ]; then
        pass "Active interface: $ACTIVE_IF"
        IP=$(ipconfig getifaddr "$ACTIVE_IF" 2>/dev/null)
        if [ -n "$IP" ]; then
            pass "Local IP: $IP"
        fi
    else
        fail "No active network interface found"
    fi
else
    # Linux
    ACTIVE_IF=$(ip route | grep default | awk '{print $5}' | head -1)
    if [ -n "$ACTIVE_IF" ]; then
        pass "Active interface: $ACTIVE_IF"
        IP=$(ip addr show "$ACTIVE_IF" | grep "inet " | awk '{print $2}' | cut -d/ -f1)
        if [ -n "$IP" ]; then
            pass "Local IP: $IP"
        fi
    else
        fail "No active network interface found"
    fi
fi

# 2. Check gateway connection
echo ""
echo "🚪 Gateway Connection:"
if [[ "$(uname)" == "Darwin" ]]; then
    GATEWAY=$(route -n get default 2>/dev/null | grep gateway | awk '{print $2}')
else
    GATEWAY=$(ip route | grep default | awk '{print $3}' | head -1)
fi

if [ -n "$GATEWAY" ]; then
    echo "   Gateway address: $GATEWAY"
    if ping -c 1 -W 2 "$GATEWAY" &> /dev/null; then
        pass "Gateway reachable"
    else
        fail "Gateway unreachable"
    fi
else
    fail "Default gateway not found"
fi

# 3. DNS check
echo ""
echo "🔍 DNS Resolution:"

# Get DNS servers
if [[ "$(uname)" == "Darwin" ]]; then
    DNS_SERVERS=$(scutil --dns | grep "nameserver\[" | awk '{print $3}' | head -3)
else
    DNS_SERVERS=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}' | head -3)
fi

if [ -n "$DNS_SERVERS" ]; then
    echo "   DNS servers:"
    echo "$DNS_SERVERS" | while read -r dns; do
        if [ -n "$dns" ]; then
            if ping -c 1 -W 2 "$dns" &> /dev/null; then
                pass "$dns (reachable)"
            else
                warn "$dns (unreachable)"
            fi
        fi
    done
else
    warn "No DNS server configuration found"
fi

# DNS resolution test
echo "   DNS resolution test:"
TEST_DOMAINS=("google.com" "baidu.com" "github.com")
for domain in "${TEST_DOMAINS[@]}"; do
    if host "$domain" &> /dev/null || nslookup "$domain" &> /dev/null; then
        RESOLVED_IP=$(host "$domain" 2>/dev/null | grep "has address" | head -1 | awk '{print $4}')
        if [ -n "$RESOLVED_IP" ]; then
            pass "$domain → $RESOLVED_IP"
        else
            pass "$domain (resolved)"
        fi
    else
        fail "$domain (resolution failed)"
    fi
done

# 4. Internet connection test
echo ""
echo "🌍 Internet Connection:"

# Ping test
PING_TARGETS=("8.8.8.8" "1.1.1.1" "223.5.5.5")
PING_NAMES=("Google DNS" "Cloudflare" "Alibaba DNS")
nnfor i in "${!PING_TARGETS[@]}"; do
    target="${PING_TARGETS[$i]}"
    name="${PING_NAMES[$i]}"
    if ping -c 1 -W 3 "$target" &> /dev/null; then
        LATENCY=$(ping -c 1 "$target" 2>/dev/null | grep "time=" | sed 's/.*time=\([0-9.]*\).*/\1/')
        pass "$name ($target): ${LATENCY}ms"
    else
        fail "$name ($target): unreachable"
    fi
done

# 5. HTTP/HTTPS connection test
echo ""
echo "🔗 HTTP/HTTPS Connection:"

check_url() {
    local url=$1
    local name=$2
    local timeout=5
    
    if command -v curl &> /dev/null; then
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout $timeout "$url" 2>/dev/null)
        TIME=$(curl -s -o /dev/null -w "%{time_total}" --connect-timeout $timeout "$url" 2>/dev/null)
        if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 400 ]; then
            pass "$name: HTTP $HTTP_CODE (${TIME}s)"
        else
            fail "$name: HTTP $HTTP_CODE"
        fi
    else
        if wget -q --spider --timeout=$timeout "$url" 2>/dev/null; then
            pass "$name: accessible"
        else
            fail "$name: inaccessible"
        fi
    fi
}

check_url "http://www.google.com" "Google"
check_url "http://www.baidu.com" "Baidu"
check_url "https://github.com" "GitHub"
check_url "https://api.github.com" "GitHub API"

# 6. Common development services check
echo ""
echo "🛠️  Development Services:"

# npm registry
if curl -s --connect-timeout 3 "https://registry.npmjs.org" &> /dev/null; then
    pass "npm registry"
else
    fail "npm registry"
fi

# PyPI
if curl -s --connect-timeout 3 "https://pypi.org" &> /dev/null; then
    pass "PyPI"
else
    fail "PyPI"
fi

# Docker Hub
if curl -s --connect-timeout 3 "https://hub.docker.com" &> /dev/null; then
    pass "Docker Hub"
else
    fail "Docker Hub"
fi

# 7. Port check (common ports)
echo ""
echo "🔌 Local Port Listening:"
COMMON_PORTS=(22 80 443 3000 3306 5432 6379 8080 27017)
PORT_NAMES=("SSH" "HTTP" "HTTPS" "Dev Server" "MySQL" "PostgreSQL" "Redis" "Alt HTTP" "MongoDB")

for i in "${!COMMON_PORTS[@]}"; do
    port="${COMMON_PORTS[$i]}"
    name="${PORT_NAMES[$i]}"
    if lsof -i ":$port" &> /dev/null || netstat -an 2>/dev/null | grep -q "LISTEN.*:$port"; then
        warn "$port ($name): in use"
    fi
done

# 8. Network speed test (optional)
echo ""
read -p "Run network speed test? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "📶 Network Speed Test:"
    
    if command -v speedtest-cli &> /dev/null; then
        speedtest-cli --simple
    elif command -v curl &> /dev/null; then
        echo "   → Download test (10MB)..."
        SPEED=$(curl -s -w "%{speed_download}" -o /dev/null "http://speedtest.tele2.net/10MB.zip" 2>/dev/null)
        SPEED_MB=$(echo "scale=2; $SPEED / 1048576" | bc 2>/dev/null || echo "$SPEED")
        echo "   Download speed: ${SPEED_MB} MB/s"
    else
        warn "speedtest-cli not installed, skipping speed test"
        if [[ "$(uname -s)" == "Darwin" ]]; then
            echo "   Install: brew install speedtest-cli"
        else
            echo "   Install: pip3 install speedtest-cli  or  apt install speedtest-cli"
        fi
    fi
fi

# 9. Network diagnostic summary
echo ""
echo "================================="
echo "📋 Diagnostic Summary:"

# Simple connectivity summary
if ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
    pass "Internet connection OK"
else
    fail "Internet connection issue"
fi

if host google.com &> /dev/null; then
    pass "DNS resolution OK"
else
    fail "DNS resolution issue"
fi

if curl -s --connect-timeout 3 "https://github.com" &> /dev/null; then
    pass "HTTPS connection OK"
else
    warn "HTTPS connection may be restricted"
fi

echo ""
echo "💡 Tips:"
if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "   - networksetup -listallhardwareports  List all network interfaces"
else
    echo "   - ip link show                        List all network interfaces"
    echo "   - nmcli device status                 Show network device status"
fi
echo "   - netstat -an | grep LISTEN           View listening ports"
echo "   - traceroute google.com               Trace route to destination"
