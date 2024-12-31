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
add_route "192.168.32.0/21" "120.0.160.40"
add_route "192.168.32.0/21" "120.0.160.40"

# Garder le conteneur actif
tail -f /dev/null
