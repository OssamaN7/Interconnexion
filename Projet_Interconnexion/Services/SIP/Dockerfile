FROM kathara/quagga

# Copier le script de démarrage dans l'image
COPY commands.sh /commands.sh

# Rendre le script exécutable
RUN chmod +x /commands.sh && \
	apt-get update && \
	apt-get install -y sudo && \
	apt-get install -y build-essential && \
	apt-get install -y wget && \
	apt-get install -y curl && \
	apt-get install -y subversion && \
        apt-get install -y libxml2-dev libsqlite3-dev libncurses5-dev libssl-dev && \
        apt-get install -y libjansson-dev libedit-dev uuid-dev

# Copier le répertoire Asterisk extrait dans l'image Docker
COPY asterisk-20.11.0 /tmp/asterisk-20.11.0

# Compiler et installer Asterisk
RUN cd /tmp/asterisk-20.11.0 && \
    ./configure && \
    make && \
    make install && \
    make samples

# Supprimer les fichiers temporaires pour garder l'image propre
RUN rm -rf /tmp/asterisk-20.11.0

# Exposer les ports nécessaires pour SIP
EXPOSE 5060/udp
EXPOSE 5060/tcp
EXPOSE 10000-20000/udp

# Copier les fichiers de configuration d'Asterisk
COPY sip.conf /etc/asterisk/sip.conf
COPY extensions.conf /etc/asterisk/extensions.conf
COPY pjsip.conf /etc/asterisk/pjsip.conf


# Assurer que le fichier de configuration est accessible
RUN chmod 755 /etc/asterisk/sip.conf /etc/asterisk/extensions.conf

# Définir le point d'entrée pour démarrer le service Asterisk
ENTRYPOINT ["/commands.sh"]

