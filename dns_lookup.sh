#!/bin/bash

# DNS Nameserver IPv4 Lookup
# Query domain NS records and resolve their IPv4 addresses

set -e

if ! command -v dig >/dev/null 2>&1; then
    echo "❌ dig is required (install bind-utils)."
    exit 1
fi

domain="$1"
if [ -z "$domain" ]; then
    read -p "Enter domain to lookup: " domain
fi

if [ -z "$domain" ]; then
    echo "❌ No domain provided, aborting."
    exit 1
fi

# Normalize domain if a full URL is provided (strip scheme, path, port)
domain="${domain#*://}"
domain="${domain%%/*}"
domain="${domain%%:*}"
domain="${domain// /}"

if [[ ! $domain == *.* ]]; then
    echo "❌ Invalid domain: $domain"
    exit 1
fi

printf "\n🌐 DNS Nameserver IPv4 Lookup\n"
printf "=============================\n"
printf "Domain: %s\n\n" "$domain"

# Show NS records
ns_list=$(dig +short NS "$domain")
if [ -z "$ns_list" ]; then
    # Fallback: try parent zone if a subdomain was provided
    candidate="$domain"
    while [[ "$candidate" == *.* ]]; do
        candidate="${candidate#*.}"
        [ -z "$candidate" ] && break
        ns_list=$(dig +short NS "$candidate")
        if [ -n "$ns_list" ]; then
            echo "ℹ️  No NS found for $domain, using parent zone: $candidate"
            domain="$candidate"
            break
        fi
    done
fi

if [ -z "$ns_list" ]; then
    echo "❌ No NS records found. Please check the domain."
    exit 1
fi

echo "📜 NS records:"
idx=1
while IFS= read -r ns; do
    echo "  $idx) $ns"
    idx=$((idx+1))
done <<< "$ns_list"

echo "\n🔍 Resolve each NS IPv4:"
while IFS= read -r ns; do
    ipv4s=$(dig +short A "$ns" | grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$' || true)
    if [ -n "$ipv4s" ]; then
        echo "  - $ns"
        echo "$ipv4s" | sed 's/^/      → /'
    else
        echo "  - $ns (no IPv4 found)"
    fi
    ipv6s=$(dig +short AAAA "$ns" | head -n 1 || true)
    if [ -n "$ipv6s" ]; then
        echo "      (IPv6) $ipv6s"
    fi
    echo ""
done <<< "$ns_list"

echo "✅ Done"
