#!/bin/bash

# On stoppe l'execution du script si on accede a une variable unset
set -o nounset

# Declaration des variables

# On definit dans quel fichier seront enregistrées les erreurs

file="monfichier.log"

if [ -f $file ] ;
        then rm $file
fi

exec 4>&2     # sauvegarder stderr
exec 2>>monfichier.log     #rediriger stderr vers le fichier

############################ Script #############################
#################################################################

grep -vi windows ips.csv | tr -d '"' > ips_sans_windows.csv
#rm ips.csv
cut -d',' -f1 ips_sans_windows.csv > ips_only.csv

USERNAME=xavier
HOSTS="192.168.21.130"
SCRIPT="touch test"
for HOSTNAME in ${HOSTS} ; do
        sshpass -p "root" ssh -o StrictHostKeyChecking=no  -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
done

rm ips_sans_windows.csv ips_only.csv


#################################################################
########################## End Script ###########################

exec 2>&4 # restaurer la valeur de stderr
exec 4>&- # fermer le FD 4

exit 0
