#!/bin/bash
wa sir t7awa

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


function start_system {
    echo -e "\e[1;32mDémarrage du système...\e[0m"  
    
    
    
    
     # for i in {1..4}; do
        
     #   mkdir -p "machine$i"


    #    wget -O "machine$i/Dockerfile" "https://pastebin.com/raw/US2vraav"


    #    wget -O "machine$i/commands.sh" "https://pastebin.com/raw/$(case $i in
     #       1) echo 'RMLwCzMZ';;
      #      2) echo 'wH0teF3d';;
      #      3) echo 'i4H0cWeD';;
      #      4) echo '7Z5tcyFj';;
       # esac)"


        

        
    #done

   
    docker build -t m1_image machine1 >/dev/null 2>&1 || { echo -e "\e[1;31mErreur lors de la construction de m1_image\e[0m"; exit 1; }
    docker build -t m2_image machine2 >/dev/null 2>&1 || { echo -e "\e[1;31mErreur lors de la construction de m2_image\e[0m"; exit 1; }
    docker build -t m3_image machine3 >/dev/null 2>&1 || { echo -e "\e[1;31mErreur lors de la construction de m3_image\e[0m"; exit 1; }
    docker build -t m4_image machine4 >/dev/null 2>&1 || { echo -e "\e[1;31mErreur lors de la construction de m4_image\e[0m"; exit 1; }


    if ! docker network ls | grep -q "br0"; then
        docker network create --driver=bridge --subnet=1.2.3.0/24 br0 >/dev/null 2>&1
    fi
    if ! docker network ls | grep -q "br1"; then
        docker network create --driver=bridge --subnet=1.2.4.0/24 br1 >/dev/null 2>&1
    fi

    
    docker run -dit --privileged --name m1 --network br0 --ip 1.2.3.5 m1_image >/dev/null 2>&1 || { echo -e "\e[1;31mErreur lors du démarrage de m1\e[0m"; exit 1; }
    docker run -dit --privileged --name m2 --network br0 --ip 1.2.3.2 m2_image >/dev/null 2>&1 || { echo -e "\e[1;31mErreur lors du démarrage de m2\e[0m"; exit 1; }
    docker run -dit --privileged --name m3 --network br1 --ip 1.2.4.5 m3_image >/dev/null 2>&1 || { echo -e "\e[1;31mErreur lors du démarrage de m3\e[0m"; exit 1; }
    docker run -dit --privileged --name m4 --network br1 --ip 1.2.4.2 m4_image >/dev/null 2>&1 || { echo -e "\e[1;31mErreur lors du démarrage de m4\e[0m"; exit 1; }

    
    docker network connect --ip 1.2.3.7 br0 m4 >/dev/null 2>&1

   
    echo -e "\e[1;32mLes conteneurs m1 et m2 sont lancés avec succès sur le réseau br0.\e[0m"  
    echo -e "\e[1;32mLes conteneurs m3 et m4 sont lancés avec succès sur le réseau br1.\e[0m"  
}


function launch_machines {
    for i in {1..4}; do
        gnome-terminal --title="m$i" -- bash -c "docker exec -it m$i bash; exit" &
    done
}


function delete_system {
    echo -e "\e[1;31mSuppression de tous les conteneurs et réseaux...\e[0m"  
    
   
    docker rm -f $(docker ps -a -q) >/dev/null 2>&1
    docker network rm $(docker network ls -q) >/dev/null 2>&1

    echo -e "\e[1;32mTous les conteneurs et réseaux ont été supprimés.\e[0m" 
#    for i in {1..4}; do
#        rm -rf "machine$i"
#    done 
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
        1)
            start_system
            ;;
        2)
            launch_machines
            ;;
        3)
            delete_system
            ;;
        4)
            echo -e "\e[1;33mAu revoir!\e[0m"  
            delete_system
            exit 0
            ;;
        *)
            echo -e "\e[1;31mChoix invalide, veuillez réessayer.\e[0m"  
            ;;
    esac
done

