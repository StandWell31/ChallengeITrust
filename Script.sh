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

echo test
rm test2
echo toto

exec 2>&4 # restaurer la valeur de stderr
exec 4>&- # fermer le FD 4

exit 0
