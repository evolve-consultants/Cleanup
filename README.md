This Docker image allows defining cron jobs via environment variables and logs the cron output to the Docker logs.
Modified from morbz/docker-cron image but included specific scripts to remove Rancher stacks and mssql databases

## Features ##
- Cron jobs can be defined via environment variables
- Cron logs can be viewed in the Docker logs

## Usage ##
When using this image you can define cron jobs via `CRON_*` environment variables. Every enviroment variable that starts with `CRON_` will be added as a cron entry. The standard and error logs of the cron command can be viewed in the Docker logs.

### Docker Compose ###
Here is a sample docker-compose file that will start 2 cron jobs:

```yaml
version: '3'
services:
  cron:
    image: evolveuk/docker-cron
    environment:
      - CRON_MINUTE=* * * * * root echo "Hello minute"
      - CRON_HOUR=0 * * * * root echo "Hello hour"
```

This will print `Hello minute` every minute and `Hello hour` every full hour to the Docker logs.

# Rancher-Stack-Removal
Script to remove Rancher stacks containing the word "Review-"
Env vars required
CRON_RANCHER_REMOVE=0 23 * * * root . /env.sh /rancher_stack_removal.sh
RANCHER_URL=
RANCHER_ACCESS_KEY=
RANCHER_SECRET_KEY=

#MSSQL Database removal
Will remove ALL other db's expect for listed exceptions
Env vars required-
CRON_DATABASE_REMOVE=5 23 * * * root . /env.sh; sqlcmd -S $DB_SERVER -U $DB_USER -P $DB_PASSWORD -i database_removal.sql
DB_SERVER=
DB_USER=
DB_PASSWORD=

#MSSQL Database backup
Will backup ALL db's from a specified host tar locallay and SFTP to a server
This Requires a volume mounting from /var/opt/mssql/data on the mssql docker container
Env vars required-
CRON_MSSQL_BACKUP=10 23 * * * root . /env.sh; /backup_mssql.sh
DB_SERVER=
DB_USER=
DB_PASSWORD=
SFTP_SERVER=
SFTP_USERNAME=
SFTP_PASSWORD=
SFTP_UPLOAD_DIR=

#MonoDB backups
This will backup mongo db's from a specified host tar locallay and SFTP to a server
Env vars required-
CRON_MONGO_BACKUP=10 23 * * * root . /env.sh; /backup_mongo.sh
MONGODB_USER=
MONGODB_PASSWORD=
MONGODB_HOST=
MONGODB_PORT=
SFTP_SERVER=
SFTP_USERNAME=
SFTP_PASSWORD=
SFTP_UPLOAD_DIR=

#MYSQL backups
This will backup All mysql db's from a specified host tar locallay and SFTP to a server
Env vars required-
CRON_MYSQL_BACKUP=15 23 * * * root . /env.sh; /backup_mysql.sh
MYSQL_USER=
MYSQL_PASSWORD=
MYSQL_HOST=
MYSQL_PORT=
SFTP_SERVER=
SFTP_USERNAME=
SFTP_PASSWORD=
SFTP_UPLOAD_DIR=

#Files backups
This will backup directory of local mounted filesystem / docker volume tar locallay and SFTP to a server
Env vars required-
CRON_FILES_BACKUP=15 23 * * * root . /env.sh; /backup_files.sh
REMOTE_BACKUP_DIR=
SFTP_SERVER=
SFTP_USERNAME=
SFTP_PASSWORD=
SFTP_UPLOAD_DIR=