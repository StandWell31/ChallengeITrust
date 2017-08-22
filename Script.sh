#!/bin/bash


# On stoppe l'execution du script si on accede a une variable unset
set -o nounset

# Declaration des variables

# On definit dans quel fichier seront enregistrées les erreurs

file="errors.log" #Fichier de logs

if [ -f $file ] #Si le fichier existe déjà, on le supprime
then
        rm $file
fi

exec 4>&2     # sauvegarder stderr
exec 2>>errors.log     #rediriger stderr vers le fichier

############################ Script #############################
#################################################################

while read line #Boucle qui lit le tableau ligne par ligne
do
        # On supprime les host windows
        tmp=$(echo $line | grep -vi "windows")
        # On filtre les IPs
        result=$(echo $tmp | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')

        ssh -t admin@${result} bash -c "' #On se connecte par ssh à chaque ip dans la variable result
        scp ssl.patch xavier@${result}:/home/xavier #On envoie le fichier de patch par ssh dans /home/xavier
        mv /home/xavier/ #On envoie le patch dans le bon répertoire
        sudo su #Privilèges root

        #on envoie la commande /etc/*release pour connaitre la version de la distribution installée. On stocke le résultat dans version
        version=$(cat /etc/*-release | grep "^NAME" | grep -oi "ubuntu" || grep -oi "debian" || grep -oi "centos" || grep -oi "redhat" || grep -oi "macos" || grep -io "alpine" || grep -io "fedora"  )

        #En fontion de la distribution on envoie telles ou telles commandes
        case $version in  "ubuntu" | "debian")
        apt-get update && apt-get upgrade -y #update & upgrade de tous les paquets présents sur la machine
        apt-get install python-openssl -y #installation de python-openssl
        ;;

        "centos" | "redhat" | "fedora" | "macos")
        yum update && yum upgrade -y
        yum install python-openssl -y
        ;;

        "alpine")
        apk update && apk upgrade -y
        apk add python-openssl
        ;;

        *)
        esac

        '"

done < $1


#################################################################
########################## End Script ###########################

exec 2>&4 # restaurer la valeur de stderr
exec 4>&- # fermer le FD 4

exit 0
