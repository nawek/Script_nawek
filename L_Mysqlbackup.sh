# Script By Jessy
# 30-12-2019
# source :https://www.kinamo.fr/fr/support/faq/mysql-backup-automatique-base-de-donnees
# script a placer dans : /usr/sbin/local
# Une fois le script placé, ne pas oublier  "chmod 755 mysqlbackup.sh" & d'ajouter le script dans la crontab & de relancer ce service.
# Configuration de base: datestamp e.g. YYYYMMDD

#!/bin/bash



DATE=$(date +"%Y%m%d")

# Dossier où sauvegarder les backups (créez le d'abord!)

BACKUP_DIR="/backup/mysql"

# Identifiants MySQL

MYSQL_USER="root"
MYSQL_PASSWORD="YOURSECUREPASSWORD"

# Commandes MySQL (aucune raison de modifier ceci)

MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump

# Bases de données MySQL à ignorer

SKIPDATABASES="Database|information_schema|performance_schema|mysql"

# Nombre de jours à garder les dossiers (seront effacés après X jours)

RETENTION=14

# ---- NE RIEN MODIFIER SOUS CETTE LIGNE ------------------------------------------
#
# Create a new directory into backup directory location for this date

mkdir -p $BACKUP_DIR/$DATE

# Retrieve a list of all databases

databases=`$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "($SKIPDATABASES)"`

# Dumb the databases in seperate names and gzip the .sql file

for db in $databases; do
echo $db
$MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --skip-lock-tables --events --databases $db | gzip > "$BACKUP_DIR/$DATE/$db.sql.gz"
done

# Remove files older than X days

find $BACKUP_DIR/* -mtime +$RETENTION -delete
