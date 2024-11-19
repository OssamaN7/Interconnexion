#!/bin/bash

function display_banner {
    echo -e "\e[1;34m"  
    echo " _ _   _ _____ _____ ____   ____ ___              ____   ___  _   _ ____  _____ ____  "
    echo "(_) \ | |_   _| ____|  _ \ / ___/ _ \        __ _|  _ \ / _ \| | | |  _ \| ____|___ \ "
    echo " | |  \| | | | |  _| | |_) | |  | | | |_____ / _\` | |_) | | | | | | | |_) |  _|   __) |"
    echo " | | |\  | | | | |___|  _ <| |__| |_| |_____| (_| |  _ <| |_| | |_| |  __/| |___ / __/ "
    echo " |_|_| \_| |_| |_____|_| \_\\____\___/       \__, |_| \_\\___/ \___/|_|   |_____|_____|"
    echo "                                             |___/                                      "
    echo -e "\e[0m"  
}

function create_networks {
    echo -e "\e[1;32mCréation des réseaux Docker...\e[0m"
    docker network create --driver=bridge --subnet=120.0.168.0/21 Reseau_Test >/dev/null 2>&1 || echo "Réseau Reseau_Test existe déjà."
    docker network create --driver=bridge --subnet=120.0.176.0/21 Routeurs >/dev/null 2>&1 || echo "Réseau Routeurs existe déjà."
    docker network create --driver=bridge --subnet=120.0.160.0/21 Services >/dev/null 2>&1 || echo "Réseau Services existe déjà."
    echo -e "\e[1;32mRéseaux créés ou déjà existants.\e[0m"
}

function start_system {
    create_networks
    
    echo -e "\e[1;32mDémarrage des conteneurs...\e[0m"
    
    # Démarrage des machines
    for i in 1 2 3; do
        docker build -t machine${i}_image ProjetInterconnexion/Reseau_Test/machine${i} >/dev/null 2>&1 || { 
            echo -e "\e[1;31mErreur lors de la construction de l'image machine$i\e[0m"; exit 1; 
        }
        ip=$((i + 1))
        docker run -dit --privileged --name machine${i} --network Reseau_Test --ip 120.0.168.${ip} machine${i}_image >/dev/null 2>&1 || { 
            echo -e "\e[1;31mErreur lors du démarrage du conteneur machine$i\e[0m"; exit 1; 
        }
    done

    # Routeur du réseau Test
    docker build -t routeur_test_image ProjetInterconnexion/Reseau_Test/routeur_reseau >/dev/null 2>&1 || { 
        echo -e "\e[1;31mErreur lors de la construction de l'image du routeur réseau Test\e[0m"; exit 1; 
    }
    docker run -dit --privileged --name routeur_test --network Reseau_Test --ip 120.0.168.40 routeur_test_image >/dev/null 2>&1 || { 
        echo -e "\e[1;31mErreur lors du démarrage du routeur Test\e[0m"; exit 1; 
    }
    docker network connect --ip 120.0.176.14 Routeurs routeur_test || { 
        echo -e "\e[1;31mErreur lors de la connexion de routeur_test au réseau Routeurs\e[0m"; exit 1; 
    }

    # Services
    k=3
	for service in DNS WEB; do
	    lowercase_service=${service,,}  # Convertir en minuscules
	    docker build -t ${lowercase_service}_image ProjetInterconnexion/Services/${service} >/dev/null 2>&1 || { 
	        echo -e "\e[1;31mErreur lors de la construction de l'image $service\e[0m"; exit 1; 
	    }
	    docker run -dit --privileged --name $lowercase_service --network Services --ip 120.0.160.${k} ${lowercase_service}_image >/dev/null 2>&1 || { 
	        echo -e "\e[1;31mErreur lors du démarrage du service $service\e[0m"; exit 1; 
	    }
	    k=$((k + 1))
	done

    # Autres routeurs
    # Convertir en minuscules
    docker build -t routeur_services_image ProjetInterconnexion/Routeurs/Routeur_Services >/dev/null 2>&1 || { 
	   echo -e "\e[1;31mErreur lors de la construction de l'image $routeur\e[0m"; exit 1; 
	}
	docker run -dit --privileged --name routeur_services --network Services --ip 120.0.160.40 routeur_services_image >/dev/null 2>&1 || { 
	   echo -e "\e[1;31mErreur lors du démarrage du routeur $routeur\e[0m"; exit 1; 
    }
	   
    docker network connect --ip 120.0.176.13 Routeurs routeur_services 

    echo -e "\e[1;32mTous les conteneurs et réseaux ont été démarrés avec succès.\e[0m"
}

function launch_machines {
    echo -e "\e[1;34mLancement des terminaux pour chaque conteneur...\e[0m"
    
    # Récupérer la liste des conteneurs Docker en cours d'exécution
    containers=$(docker ps --format "{{.Names}}")
    
    # Lancer un terminal pour chaque conteneur
    for container in $containers; do
        gnome-terminal --title="$container" -- bash -c "docker exec -it $container bash; exit" &
    done
    
    echo -e "\e[1;32mTous les terminaux ont été ouverts avec succès.\e[0m"
}


function delete_system {
    echo -e "\e[1;31mSuppression de tous les conteneurs et réseaux...\e[0m"
    docker rm -f $(docker ps -a -q) >/dev/null 2>&1
    docker network rm $(docker network ls -q) >/dev/null 2>&1
    echo -e "\e[1;32mTous les conteneurs et réseaux ont été supprimés.\e[0m"
}

while true; do
    display_banner  
    echo -e "\e[1;36mChoisissez une option :\e[0m"
    echo -e "\e[1;36m1) Démarrer le système\e[0m"
    echo -e "\e[1;36m2) Lancer les machines\e[0m"
    echo -e "\e[1;36m3) Supprimer le système\e[0m"
    echo -e "\e[1;36m4) Quitter\e[0m"

    read -p "Entrez votre choix : " choice

    case $choice in
        1) start_system ;;
        2) launch_machines ;;
        3) delete_system ;;
        4) echo -e "\e[1;33mAu revoir!\e[0m"; exit 0 ;;
        *) echo -e "\e[1;31mChoix invalide, veuillez réessayer.\e[0m" ;;
    esac
done
