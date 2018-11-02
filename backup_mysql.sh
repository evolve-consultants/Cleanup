#Backup of All Mysql databases to a single backup file

#Variables
DATESTAMP=$(date +"%F")
TIMESTAMP=$(date +"%T")
MYSQLDUMP="/usr/bin/mysqldump"
MYSQL="/usr/bin/mysql"
TMP="/backup/mysql/tmp/"
DATABASE_TAR_FILE="DB_MYSQL_Backups_$DATESTAMP.tar"
BACKUP_DIR="/backup/mysql/$DATESTAMP"

#Sort out directories
mkdir -p "$BACKUP_DIR/"
rm -rf $TMP/*
echo "Starting backup at $TIMESTAMP"

#LOcal DB Backups####
databases=`$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`

for db in $databases; do
  $MYSQLDUMP -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT --databases $db | gzip > "$BACKUP_DIR/$db.sql.gz"
done

#Local Files backups and tarball DB backup
tar -cvf $TMP/$DATABASE_TAR_FILE $BACKUP_DIR

SSHPASS=$SFTP_PASSWORD sshpass -e sftp -oBatchMode=no -oStrictHostKeyChecking=no -b - $SFTP_USERNAME@$SFTP_SERVER << !
   cd $SFTP_UPLOAD_DIR
   put $TMP/$DATABASE_TAR_FILE
   bye
!

#Remove Local Backups
rm -rf $BACKUP_DIR