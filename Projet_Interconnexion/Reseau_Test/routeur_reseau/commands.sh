#!/bin/bash
set -e

# Fonction pour ajouter une route avec des tentatives répétées
add_route() {
  local route="$1"
  local gateway="$2"

  until ip route add "$route" via "$gateway"; do
    echo "Tentative d'ajout de la route $route via $gateway..."
    sleep 1
  done

  echo "Route $route via $gateway ajoutée avec succès."
}

# Active le forwarding IP
echo "1" > /proc/sys/net/ipv4/ip_forward

# Ajoute les routes avec vérification

add_route "120.0.160.0/21" "120.0.176.13"

# Garder le conteneur actif
tail -f /dev/null
