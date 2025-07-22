#!/bin/sh

# Domains to whitelist (space‑separated string)
WHITELIST_DOMAINS="line.diatunnel.link"

# Domains to blacklist (empty for now)
BLACKLIST_DOMAINS=""

# Function to whitelist
whitelist_domain() {
    DOMAIN="$1"
    IP=$(ping -c 1 "$DOMAIN" | awk -F'[()]' '/PING/{print $2}')
    if [ -n "$IP" ]; then
        logger -t Skynet-Whitelist "Whitelisting $DOMAIN ($IP)"
        /jffs/scripts/firewall whitelist add "$IP"
    else
        logger -t Skynet-Whitelist "Failed to resolve $DOMAIN"
    fi
}

# Function to blacklist
blacklist_domain() {
    DOMAIN="$1"
    IP=$(ping -c 1 "$DOMAIN" | awk -F'[()]' '/PING/{print $2}')
    if [ -n "$IP" ]; then
        logger -t Skynet-Blacklist "Blacklisting $DOMAIN ($IP)"
        /jffs/scripts/firewall blacklist add "$IP"
    else
        logger -t Skynet-Blacklist "Failed to resolve $DOMAIN"
    fi
}

# Process whitelist
for DOMAIN in $WHITELIST_DOMAINS; do
    whitelist_domain "$DOMAIN"
done

# Process blacklist
for DOMAIN in $BLACKLIST_DOMAINS; do
    blacklist_domain "$DOMAIN"
done
