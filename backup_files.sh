#Backup of directory of local mounted filesystem / docker volume

#Variables
DATESTAMP=$(date +"%F")
TIMESTAMP=$(date +"%T")
TMP="/backup/files/tmp/"
FILES_TAR_FILE="Files_Backup_$DATESTAMP.tar"
BACKUP_DIR="/backup/files/$DATESTAMP"

#Sort out directories
mkdir -p "$BACKUP_DIR/"
rm -rf $TMP/*
echo "Starting backup at $TIMESTAMP"

#Local Files backups and tarball DB backup
tar -cvf $TMP/$FILES_TAR_FILE $REMOTE_BACKUP_DIR
gzip $TMP/$FILES_TAR_FILE

SSHPASS=$SFTP_PASSWORD sshpass -e sftp -oBatchMode=no -oStrictHostKeyChecking=no -b - $SFTP_USERNAME@$SFTP_SERVER << !
   cd $SFTP_UPLOAD_DIR
   put $TMP/$FILES_TAR_FILE.gz
   bye
!

#Remove Local Backups
rm -rf $BACKUP_DIR