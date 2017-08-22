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

        ssh -t admin@${result} bash -c "' 

        #On se connecte par ssh à chaque ip dans la variable result
        
        scp ssl.patch admin@${result}:/home/xavier #On envoie le fichier de patch par ssh dans /home/xavier
       
        #on renome le fichier
        sudo mv ssl.patch ssl.py -y

        #on envoie le patch dans le bon répertoire
        sudo mv ssl.py /usr/lib/python2.7/ssl.py 

        #on envoie la commande /etc/*release pour connaitre la version de la distribution installée. On stocke le résultat dans version
        version=$(cat /etc/*-release | grep "^NAME")

        #En fontion de la distribution on envoie telles ou telles commandes

        if [[$version == *"ubuntu"*]] || [[$version == *"debian"*]]; then
                sudo apt-get update && sudo apt-get upgrade -y #update & upgrade de tous les paquets présents sur la machine
                sudo apt-get install python-openssl -y #installation de python-openssl
        fi

        if [[$version == *"centos"]] || [[$version == *"redhat"]] || [[$version == *"fedora"]] || [[$version == *"macos"]]; then
                sudo yum update && yum upgrade -y
                sudo yum install python-openssl -y
        fi

        if [[$version == *"alpine"]]

                sudo apk update && apk upgrade -y
                sudo apk add python-openssl
        fi

        '"

done < $1


#################################################################
########################## End Script ###########################

exec 2>&4 # restaurer la valeur de stderr
exec 4>&- # fermer le FD 4

exit 0
