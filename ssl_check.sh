#!/bin/bash

# SSL Certificate Checker
# Inspect SSL/TLS certificate details, expiry, and chain for one or more domains

set -e

echo "🔐 SSL Certificate Checker"
echo "=========================="

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
GRAY='\033[0;90m'
NC='\033[0m'

pass() { echo -e "   ${GREEN}✓${NC} $1"; }
fail() { echo -e "   ${RED}✗${NC} $1"; }
warn() { echo -e "   ${YELLOW}⚠${NC} $1"; }

# Check for openssl
if ! command -v openssl &> /dev/null; then
    echo -e "${RED}✗ Error: openssl is not installed${NC}"
    exit 1
fi

# Normalize input: strip scheme, path, and port  →  host  port
parse_target() {
    local raw="$1"
    # strip scheme
    raw="${raw#https://}"
    raw="${raw#http://}"
    # strip path
    raw="${raw%%/*}"
    # extract port if present
    if [[ "$raw" == *:* ]]; then
        HOST="${raw%%:*}"
        PORT="${raw##*:}"
    else
        HOST="$raw"
        PORT="443"
    fi
}

# Check a single domain
check_domain() {
    local HOST="$1"
    local PORT="${2:-443}"

    echo ""
    echo -e "${BOLD}🌐 $HOST (port $PORT)${NC}"
    echo -e "${GRAY}   ─────────────────────────────────────────────${NC}"

    # Fetch certificate
    CERT=$(echo | openssl s_client \
        -connect "${HOST}:${PORT}" \
        -servername "$HOST" \
        -showcerts 2>/dev/null </dev/null)

    if [ -z "$CERT" ]; then
        fail "Could not connect to ${HOST}:${PORT}"
        return 1
    fi

    # Extract leaf certificate
    LEAF_CERT=$(echo "$CERT" | openssl x509 2>/dev/null)

    if [ -z "$LEAF_CERT" ]; then
        fail "Could not parse certificate from ${HOST}:${PORT}"
        return 1
    fi

    # Subject
    SUBJECT=$(echo "$LEAF_CERT" | openssl x509 -noout -subject 2>/dev/null | sed 's/subject=//')
    echo -e "   ${GRAY}Subject   :${NC} $SUBJECT"

    # Issuer
    ISSUER=$(echo "$LEAF_CERT" | openssl x509 -noout -issuer 2>/dev/null | sed 's/issuer=//')
    echo -e "   ${GRAY}Issuer    :${NC} $ISSUER"

    # Validity dates
    NOT_BEFORE=$(echo "$LEAF_CERT" | openssl x509 -noout -startdate 2>/dev/null | sed 's/notBefore=//')
    NOT_AFTER=$(echo "$LEAF_CERT"  | openssl x509 -noout -enddate   2>/dev/null | sed 's/notAfter=//')
    echo -e "   ${GRAY}Valid from:${NC} $NOT_BEFORE"
    echo -e "   ${GRAY}Valid to  :${NC} $NOT_AFTER"

    # Days until expiry
    EXPIRY_EPOCH=$(date -j -f "%b %d %T %Y %Z" "$NOT_AFTER" "+%s" 2>/dev/null || \
                   date -d "$NOT_AFTER" "+%s" 2>/dev/null || echo 0)
    NOW_EPOCH=$(date "+%s")
    DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))

    if [ "$DAYS_LEFT" -lt 0 ]; then
        fail "Certificate EXPIRED ${DAYS_LEFT#-} days ago!"
    elif [ "$DAYS_LEFT" -lt 14 ]; then
        fail "Expires in $DAYS_LEFT days — CRITICAL"
    elif [ "$DAYS_LEFT" -lt 30 ]; then
        warn "Expires in $DAYS_LEFT days — renew soon"
    else
        pass "Expires in $DAYS_LEFT days"
    fi

    # SANs (Subject Alternative Names)
    SANS=$(echo "$LEAF_CERT" | openssl x509 -noout -text 2>/dev/null \
        | grep -A1 "Subject Alternative Name" \
        | tail -1 | sed 's/^\s*//' | sed 's/DNS://g' | tr ',' '\n' \
        | sed 's/^\s*//' | head -10)
    if [ -n "$SANS" ]; then
        echo -e "   ${GRAY}SANs      :${NC}"
        echo "$SANS" | while read -r san; do
            [ -n "$san" ] && echo "      $san"
        done
    fi

    # Serial number
    SERIAL=$(echo "$LEAF_CERT" | openssl x509 -noout -serial 2>/dev/null | sed 's/serial=//')
    echo -e "   ${GRAY}Serial    :${NC} $SERIAL"

    # Key algorithm and size
    KEY_INFO=$(echo "$LEAF_CERT" | openssl x509 -noout -text 2>/dev/null \
        | grep -E "Public Key Algorithm|Public-Key:|RSA Public-Key:" \
        | head -2 | sed 's/^\s*//' | tr '\n' '  ')
    echo -e "   ${GRAY}Key info  :${NC} $KEY_INFO"

    # Signature algorithm
    SIG_ALG=$(echo "$LEAF_CERT" | openssl x509 -noout -text 2>/dev/null \
        | grep "Signature Algorithm" | head -1 | sed 's/.*Signature Algorithm: //')
    echo -e "   ${GRAY}Sig alg   :${NC} $SIG_ALG"

    # TLS protocol version negotiated
    TLS_VER=$(echo | openssl s_client \
        -connect "${HOST}:${PORT}" \
        -servername "$HOST" 2>/dev/null </dev/null \
        | grep "Protocol" | head -1 | awk '{print $3}')
    if [ -n "$TLS_VER" ]; then
        if [[ "$TLS_VER" == "TLSv1.3" ]] || [[ "$TLS_VER" == "TLSv1.2" ]]; then
            pass "TLS version: $TLS_VER"
        else
            warn "TLS version: $TLS_VER (consider upgrading to TLS 1.2+)"
        fi
    fi

    # Certificate chain depth
    CHAIN_COUNT=$(echo "$CERT" | grep -c "BEGIN CERTIFICATE" || echo 0)
    echo -e "   ${GRAY}Chain depth:${NC} $CHAIN_COUNT certificate(s)"

    # Verify certificate chain
    VERIFY=$(echo | openssl s_client \
        -connect "${HOST}:${PORT}" \
        -servername "$HOST" 2>/dev/null </dev/null \
        | grep "Verify return code")
    if echo "$VERIFY" | grep -q "ok"; then
        pass "Chain verification: OK"
    else
        CODE=$(echo "$VERIFY" | sed 's/.*Verify return code: //')
        warn "Chain verification: $CODE"
    fi
}

# ── Argument handling ─────────────────────────────────────────────────────────

if [ $# -eq 0 ]; then
    # Interactive mode
    echo ""
    read -p "Enter domain(s) to check (space-separated, e.g. github.com example.com:8443): " -r INPUT
    if [ -z "$INPUT" ]; then
        echo "No domain provided."
        exit 0
    fi
    TARGETS=($INPUT)
else
    TARGETS=("$@")
fi

# ── Check each target ─────────────────────────────────────────────────────────

CHECKED=0
for target in "${TARGETS[@]}"; do
    parse_target "$target"
    check_domain "$HOST" "$PORT" && CHECKED=$((CHECKED + 1)) || true
done

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "================================="
echo -e "${BOLD}📋 Summary:${NC} $CHECKED domain(s) checked"
echo ""
echo "💡 Tips:"
echo "   - Certificates expiring within 30 days should be renewed"
echo "   - Use Let's Encrypt (certbot) for free auto-renewing certificates"
echo "   - TLS 1.3 is preferred; disable TLS 1.0/1.1 on your servers"
