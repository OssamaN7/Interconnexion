FROM kathara/quagga


COPY commands.sh /commands.sh


RUN chmod +x /commands.sh && apt-get update && apt-get install -y sudo


ENTRYPOINT ["/commands.sh"]
