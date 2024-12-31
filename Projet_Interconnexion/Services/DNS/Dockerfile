FROM ubuntu/bind9
RUN apt-get update && apt-get install -y bind9utils dnsutils
COPY named.conf /etc/bind/named.conf
COPY named.conf.options /etc/bind/named.conf.options
COPY named.conf.local /etc/bind/named.conf.local
COPY domainn7.fr.zone /etc/bind/zones/domaine1.fr.zone

COPY commands.sh /commands.sh
RUN chmod +x /commands.sh
ENTRYPOINT ["/commands.sh"]