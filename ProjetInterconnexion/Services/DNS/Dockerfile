FROM kathara/quagga


COPY commands.sh /commands.sh

COPY index.html /var/www/html

RUN chmod +x /commands.sh && apt-get update && apt-get install -y sudo && apt-get install -y bind9 bind9utils bind9-doc

ENTRYPOINT ["/commands.sh"]
