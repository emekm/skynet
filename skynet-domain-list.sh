#!/bin/sh
# skynet-domain-list.sh
# Mise à jour automatique des whitelist/blacklist Skynet depuis domaines

### Configuration ###
# Liste des domaines à whitelister
WHITELIST_DOMAINS=(
    "line.diatunnel.link"
)

# Liste des domaines à blacklister (vide pour l'instant)
BLACKLIST_DOMAINS=(
    # exemple : "bad.example.com"
)

### Fonctions ###
resolve_ip() {
    DOMAIN="$1"
    IP=$(ping -c 1 -W 1 "$DOMAIN" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
    echo "$IP"
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

### Traitement Whitelist ###
log "Début de la mise à jour des whitelists"
for DOMAIN in "${WHITELIST_DOMAINS[@]}"; do
    IP=$(resolve_ip "$DOMAIN")
    if [ -n "$IP" ]; then
        log "Whitelist: $DOMAIN → $IP"
        skynet whitelist add "$IP"
    else
        log "Échec résolution whitelist: $DOMAIN"
    fi
done

### Traitement Blacklist ###
log "Début de la mise à jour des blacklists"
for DOMAIN in "${BLACKLIST_DOMAINS[@]}"; do
    IP=$(resolve_ip "$DOMAIN")
    if [ -n "$IP" ]; then
        log "Blacklist: $DOMAIN → $IP"
        skynet blacklist add "$IP"
    else
        log "Échec résolution blacklist: $DOMAIN"
    fi
done

log "Mise à jour terminée"
exit 0
