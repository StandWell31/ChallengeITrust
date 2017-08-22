#!/bin/bash


# On stoppe l'execution du script si on accede a une variable unset
set -o nounset

# Declaration des variables

# On definit dans quel fichier seront enregistrées les erreurs

file="errors.log"

if [ -f $file ]
then
        rm $file
fi

exec 4>&2     # sauvegarder stderr
exec 2>>errors.log     #rediriger stderr vers le fichier

############################ Script #############################
#################################################################

while read line
do
        # On supprime les host windows
        tmp=$(echo $line | grep -vi "windows")
        # On filtre les IPs
        result=$(echo $tmp | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')

        ssh -t xavier@${result} bash -c "'
        touch test
        scp ssl.patch xavier@${result}:/home/xavier
        sudo su

        version=$(cat /etc/*-release | grep "^NAME" | grep -oi "ubuntu" || grep -oi "debian" || grep -oi "centos" || grep -oi "redhat" || grep -oi "macos" |$

        case $version in  "ubuntu" | "debian")
        apt-get update && apt-get upgrade -y
        apt-get install python-openssl -y
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
