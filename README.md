# ChallengeITrust

OS Server : Debian 9.1.0

Syntaxe : ./ITrust.save [nomdutableau]

Fonctionnel : 

- Parse du tableau CSV 
- Filtrage des IP non Windows
- Connexion à chaque IP par ssh
- Envoie d'un fichier "ssl.patch" sur la machine client
- Envoie de n'importe quelle commande sauf celles nécessitant des privilèges

Non fonctionnel : 

- Problème de privilèges pour lancer les commandes sur la machine client (Module PAM ?)
- Sortie erreurs uniquement dans le fichier errors et non à l'écran

Copyright (C) 2017 Xavier Greco - All Rights Reserved
