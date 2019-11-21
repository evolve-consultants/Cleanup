#Backup of All Mysql databases to a single backup file
#Requires a local volume mounting to the MSSQL server /var/opt/mssql/data

#Variables
DATESTAMP=$(date +"%F")
TIMESTAMP=$(date +"%T")
SQLCMD="/opt/mssql-tools/bin/sqlcmd"
TMP="/backup/mssql/tmp/"
DATABASE_TAR_FILE="DB_MSSQL_Backups_$DATESTAMP.tar"
DB_BACKUP_DIR="/var/opt/mssql/data"
BACKUP_DIR="/backup/mssql/$DATESTAMP"

#Sort out directories
mkdir -p "$BACKUP_DIR/"
rm -rf $TMP/*
echo "Starting backup at $TIMESTAMP"

#LOcal DB Backups####
databases=`$SQLCMD -S $DB_SERVER -U $DB_USER -P $DB_PASSWORD -Q "EXEC sp_msForEachDB 'PRINT ''?'''" | grep -Ev "(master|tempdb|msdb)"`

for db in $databases; do
  $SQLCMD -S $DB_SERVER -U $DB_USER -P $DB_PASSWORD -Q "BACKUP DATABASE [$db] TO DISK='$DB_BACKUP_DIR/$db.bak'"
done

#Move backups locally and tarball DB backup
mv $DB_BACKUP_DIR/*.bak $BACKUP_DIR
tar -cvf $TMP/$DATABASE_TAR_FILE $BACKUP_DIR
gzip $TMP/$DATABASE_TAR_FILE 

SSHPASS=$SFTP_PASSWORD sshpass -e sftp -oBatchMode=no -oStrictHostKeyChecking=no -oPort=$SFTP_PORT -b - $SFTP_USERNAME@$SFTP_SERVER << !
   cd $SFTP_UPLOAD_DIR
   put $TMP/$DATABASE_TAR_FILE.gz
   bye
!

#Remove Local Backups
rm -rf $BACKUP_DIR