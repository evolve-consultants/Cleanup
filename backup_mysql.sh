#Backup of All Mysql databases to a single backup file

#Variables
DATESTAMP=$(date +"%F")
TIMESTAMP=$(date +"%T")
MYSQLDUMP="/usr/bin/mysqldump"
MYSQL="/usr/bin/mysql"
TMP="/backup/mysql/tmp/"
DATABASE_TAR_FILE="DB_Backups_$DATESTAMP.tar"
BACKUP_DIR="/backup/mysql/$DATESTAMP"
LOG_FILE=$BACKUP_DIR/backup_$DATESTAMP.log

#Sort out directories
mkdir -p "$BACKUP_DIR/"
rm -rf $TMP/*
touch $LOG_FILE
echo "Starting backup at $TIMESTAMP"

#####ADD HERE TO CONNECT TO A REMOTE HOST########
#LOcal DB Backups####
databases=`$MYSQL -u $MYSQL_USER -p $MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT -e "SHOW DATABASES;" | gr
ep -Ev "(Database|information_schema|performance_schema)"`

for db in $databases; do
  $MYSQLDUMP -u $MYSQL_USER -p $MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT --databases $db | gzip > "$BACKUP_DIR/$db.sql.gz"
done

#Local Files backups and tarball DB backup
tar -cvf $TMP/$DATABASE_TAR_FILE $BACKUP_DIR

################ UPLOAD to SFTP Server  ################
echo "Starting  ftp at $TIMESTAMP" >> $LOG_FILE

SSHPASS=$SFTP_PASSWORD sshpass -e sftp -oBatchMode=no -b - $SFTP_USERNAME@$SFTP_SERVER
 << !
   cd $SFTP_UPLOAD_DIR
   put $TMP/$DATABASE_TAR_FILE
   put $TMP/$APPLICATION_TAR_FILE
   bye
!

#Remove Local Backups
rm -rf $BACKUP_DIR