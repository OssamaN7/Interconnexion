FROM kathara/quagga


COPY commands.sh /commands.sh


RUN chmod +x /commands.sh && apt-get update 


ENTRYPOINT ["/commands.sh"]
