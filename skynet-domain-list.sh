#!/bin/sh

# Liste des domaines à whitelist (séparés par espaces)
WHITELIST_DOMAINS="line.diatunnel.link"

# Liste des domaines à blacklist (vide pour l'instant)
BLACKLIST_DOMAINS=""

whitelist_domain() {
    DOMAIN=$1
    IP=$(ping -c 1 $DOMAIN | awk -F'[()]' '/PING/{print $2}')
    if [ -n "$IP" ]; then
        logger -t Skynet-Whitelist "Whitelisting $DOMAIN ($IP)"
        /jffs/scripts/firewall whitelist add $IP
    else
        logger -t Skynet-Whitelist "Failed to resolve $DOMAIN"
    fi
}

blacklist_domain() {
    DOMAIN=$1
    IP=$(ping -c 1 $DOMAIN | awk -F'[()]' '/PING/{print $2}')
    if [ -n "$IP" ]; then
        logger -t Skynet-Blacklist "Blacklisting $DOMAIN ($IP)"
        /jffs/scripts/firewall blacklist add $IP
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
