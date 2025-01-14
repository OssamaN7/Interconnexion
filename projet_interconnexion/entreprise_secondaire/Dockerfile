FROM kathara/quagga


# Mettre à jour le système et installer les outils réseau nécessaires
RUN apt-get update && apt-get install -y \
    iproute2 iputils-ping \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY commands.sh /commands.sh

RUN chmod +x /commands.sh && apt-get update 

ENTRYPOINT ["/commands.sh"]
