#Backup of All Mysql databases to a single backup file

#Variables
DATESTAMP=$(date +"%F")
TIMESTAMP=$(date +"%T")
MONGODUMP="/usr/bin/mongodump"
TMP="/backup/mongo/tmp/"
DATABASE_TAR_FILE="DB_Backups_$DATESTAMP.tar"
BACKUP_DIR="/backup/mongo/$DATESTAMP"
LOG_FILE=$BACKUP_DIR/backup_$DATESTAMP.log

#Sort out directories
mkdir -p "$BACKUP_DIR/"
rm -rf $TMP/*
touch $LOG_FILE
echo "Starting backup at $TIMESTAMP"

#LOcal DB Backups####
$MONGODUMP --host $MONGODB_HOST --port $MONGODB_PORT --out $BACKUP_DIR

#Local Files backups and tarball DB backup

tar -cvf $TMP/$DATABASE_TAR_FILE $BACKUP_DIR

################ UPLOAD to SFTP Server  ################
echo "Starting  ftp at $TIMESTAMP" >> $LOG_FILE

SSHPASS=$SFTP_PASSWORD sshpass -e sftp -oBatchMode=no -b - $SFTP_USERNAME@$SFTP_SERVER
 << !
   cd $SFTP_UPLOAD_DIR
   put $TMP/$DATABASE_TAR_FILE
   bye
!

#Remove Local Backups
rm -rf $BACKUP_DIR