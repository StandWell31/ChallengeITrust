!/bin/bash

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

grep -vi windows ipsTest.csv | tr -d '"' > ips_sans_windows.csv #Modif Test ici
#rm ips.csv
cut -d',' -f1 ips_sans_windows.csv > ips_only.csv

for ip in $"{ips_only.csv[*]}"
        do
                HOSTS=192.168.21.133 ############################# PROBLEME ICI PAS DE RECUP VAR DU TAB #############################################

                USERNAME=xavier
                SCRIPT="touch test"

                for HOSTNAME in ${HOSTS} ;
                        do
                                sshpass -p "root" ssh -o StrictHostKeyChecking=no  -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
                done
done

rm ips_sans_windows.csv ips_only.csv


#################################################################
########################## End Script ###########################

exec 2>&4 # restaurer la valeur de stderr
exec 4>&- # fermer le FD 4

exit 0