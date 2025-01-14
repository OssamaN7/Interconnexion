FROM kathara/quagga

# Mettre à jour les paquets et installer des outils de base
RUN apt-get update && apt-get install -y \
    sudo \
    vim \
    git \
    curl \
    net-tools \
    iputils-ping \
    openssh-server \
    isc-dhcp-server \
    wget \
    busybox

# Corriger les sources APT si nécessaire
RUN sed -i 's/archive.ubuntu.com/mirrors.edge.kernel.org/g' /etc/apt/sources.list && apt-get update

# Créer un utilisateur avec des privilèges sudo
RUN useradd -ms /bin/bash user && echo "user:user" | chpasswd && adduser user sudo

# Configurer SSH
RUN mkdir /var/run/sshd && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Configurer DHCP
COPY dhcpd.conf /etc/dhcp/dhcpd.conf
RUN mkdir -p /var/lib/dhcp
EXPOSE 67/udp

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires
COPY . /app

# Installer les dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Exposer le port
EXPOSE 8000

# Commande pour démarrer l'application
CMD ["python", "app.py"]
WORKDIR /home/user

# Garder le conteneur actif
CMD ["/bin/bash"]
