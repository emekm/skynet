#!/bin/sh

# Liste des domaines à whitelist (séparés par espaces)
WHITELIST_DOMAINS="line.diatunnel.link","109.234.160.5","128.116.122.4"
#iptv, o2switch, roblox

# Liste des domaines à blacklist (vide pour l'instant)
BLACKLIST_DOMAINS=""

whitelist_domain() {
    DOMAIN=$1
    IP=$(ping -c 1 $DOMAIN | awk -F'[()]' '/PING/{print $2}')
    if [ -n "$IP" ]; then
        logger -t Skynet-Whitelist "Whitelisting $DOMAIN ($IP)"
        /jffs/scripts/firewall whitelist ip $IP
    else
        logger -t Skynet-Whitelist "Failed to resolve $DOMAIN"
    fi
}

blacklist_domain() {
    DOMAIN=$1
    IP=$(ping -c 1 $DOMAIN | awk -F'[()]' '/PING/{print $2}')
    if [ -n "$IP" ]; then
        logger -t Skynet-Blacklist "Blacklisting $DOMAIN ($IP)"
        /jffs/scripts/firewall blacklist ip $IP
    else
        logger -t Skynet-Blacklist "Failed to resolve $DOMAIN"
    fi
}

for DOMAIN in $WHITELIST_DOMAINS
do
    whitelist_domain $DOMAIN
done

for DOMAIN in $BLACKLIST_DOMAINS
do
    blacklist_domain $DOMAIN
done
