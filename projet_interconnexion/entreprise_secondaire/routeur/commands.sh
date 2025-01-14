#!/bin/bash

# Activer le routage IP
echo 1 > /proc/sys/net/ipv4/ip_forward

# Ajouter une route vers le sous-réseau de l'entreprise principale
ip route add 120.0.35.0/24 via 120.0.34.1

# Garder le conteneur actif
tail -f /dev/null
