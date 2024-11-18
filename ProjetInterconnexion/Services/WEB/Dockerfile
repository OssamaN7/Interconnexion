FROM kathara/quagga


COPY commands.sh /commands.sh

COPY index.html /var/www/html

RUN chmod +x /commands.sh && apt-get update && apt-get install -y sudo && apt-get install -y apache2

ENTRYPOINT ["/commands.sh"]
