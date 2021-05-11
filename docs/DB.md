# Database
## Création de la database
Devrait être fait sur une machine virtuelle. \
Créer un utilisateur seulement pour XALT?
### Prérequis :
- mariadb-server
- package python3 mysqlclient
- une installation de XALT
    - Même config[]().py que le client
    - l'option --with-syshostConfig peut être n'importe quoi (ne sera pas utilisé par XALT)

### Étapes de création de la database
1. `mysql_install_db --user=mysql` ou peut-être le nom de l'utilisateur d'XALT?
2. Modifier le fichier `/etc/my.cnf` pour accepter les connections externes
3. Lancer MariaDB
4. Créer la database
```
CREATE DATABASE xalt_<nom_du_cluster>;
GRANT ALL PRIVILEGES ON xalt_<nom_du_cluster>.* To 'xaltUser'@'hostname_du_cluster' IDENTIFIED BY 'mot_de_passe';
GRANT ALL PRIVILEGES ON xalt_<nom_du_cluster>.* To 'xaltUser'@'%' IDENTIFIED BY 'mot_de_passe';
```
5. Créer un fichier de configuration pour qu'XALT puisse se connecter à la database avec 
```
cd $XALT_ETC_DIR; python $XALT_DIR/xalt/xalt/sbin/conf_create.py
``` 
et on répond aux questions selon ce qu'on a entré à l'étape précédente. \
6. Créer les tables avec 
```
python $XALT_DIR/xalt/xalt/sbin/createDB.py --confFn  $XALT_ETC_DIR/xalt_<nom_du_cluster>_db.conf
```

## Connexion du client avec le serveur
Les fichiers JSON sont seulement traités du côté client (on ajoute directement les données contenues dans les JSON à la database), alors que le syslog est traité du côté client (on convertit le syslog en .log) et du côté serveur (on ajoute les données contenues dans le .log à la database)

L'avantage d'utiliser le syslog est qu'on peut recueillir plusieurs entrées de XALT dans un seul .log, ce qui diminue le nombre de fichiers créés. Cependant, le fait d'utiliser le syslog ajoute une certaine complexitée, puisqu'on crée un JSON, on l'envoie dans le syslog, on le récupère dans un .log, puis on l'ajoute à la base de données. Lorsqu'on utilise les fichiers JSON, on ne fait que créer le fichier, puis l'ajouter directement à la base de données.
### Prérequis :
- mariadb-client
- package python3 mysqlclient

### En utilisant les fichiers JSON
1. Créer un utilisateur pour XALT sur le cluster et installer XALT dans son $HOME avec la même configuration que le cluster.
2. Créer un dossier pour contenir les configurations avec 
```
mkdir ~/process_xalt && cd ~/process_xalt; python ~/xalt/xalt/sbin/conf_create.py
```
3. Créer le dossier qui va contenir la reverse map avec
```
mkdir ~/process_xalt/reverseMapD
```
puis générer la reverse map selon la méthode choisie à la section [Structure générale de la xalt_rmapT](#structure-générale-de-la-xalt_rmapt) \
4. Faire un cron job qui permet d'envoyer les JSON à la database. Le script doit être exécuté avec `root` ou un utilisateur aillant accès en lecture et écriture à tous les endroits où les fichiers JSON sont stockés. Exemple de script pour le cron job :
```
#!/bin/bash

# get lock, quit if lock is unavailable
# set trap to clear lock if this script aborts.

~swtools/xalt/xalt/sbin/xalt_file_to_db.py --delete                 \
  --confFn  ~swtools/process_xalt/xalt_<nom_du_cluster>_db.conf    \
  --reverseMapD ~swtools/process_xalt/reverseMapD

# remove lock
```

### En utilisant le syslog