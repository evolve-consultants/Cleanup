# SQL Server Command Line Tools
FROM ubuntu:16.04

# apt-get and system utilities
RUN apt-get update && apt-get install -y \
	curl apt-transport-https debconf-utils \
    && rm -rf /var/lib/apt/lists/*

# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

#install mongo tools for mongo database backups amd restores
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
RUN apt-get update
RUN apt-get install mongodb-org-tools

#install mysql client for mysql backups / restores
RUN apt-get update
RUN apt-get install -y mysql-client

#install cron
RUN apt-get update && apt-get install cron
RUN apt-get install -y openssh-client
RUN apt-get install sshpass
#setup environment variables to none and CRON entries to create
ENV RANCHER_URL=**None** \
    RANCHER_ACCESS_KEY=**None** \
    RANCHER_SECRET_KEY=**None** \
    DB_SERVER=**None** \
    DB_USER=**None** \
    DB_PASSWORD=**None** \
    MONGODB_USER=**None** \
    MONGODB_PASSWORD=**None** \
    MONGODB_HOST=**None** \
    MONGODB_PORT=**None** \
    SFTP_SERVER=**None** \
    SFTP_USERNAME=**None** \
    SFTP_PASSWORD=**None** \
    SFTP_UPLOAD_DIR=**None** \
    MYSQL_USER=**None** \
    MYSQL_PASSWORD=**None** \
    MYSQL_HOST=**None** \
    MYSQL_PORT=**NONE**
#example  CRON_MINUTE="* * * * * root echo Hello minute"

# Copy required files
COPY ./rancher_stack_removal.sh /rancher_stack_removal.sh
COPY ./database_removal.sql /database_removal.sql
COPY ./rancher /rancher
COPY ./start.sh /start.sh
COPY ./backup_mongo.sh /backup_mongo.sh
COPY ./backup_mysql.sh /backup_mysql.sh
COPY ./backup_mssql.sh /backup_mssql.sh
#Setup permissions on scripts
RUN chmod +x /rancher_stack_removal.sh
RUN chmod +x /rancher
RUN chmod +x /database_removal.sql
RUN chmod +x /start.sh
RUN chmod +x /backup_mongo.sh
RUN chmod +x /backup_mysql.sh
RUN chmod +x /backup_mssql.sh
#Create Backup Dir
RUN mkdir /backup
RUN mkdir /backup/mongo
RUN mkdir /backup/mongo/tmp
RUN mkdir /backup/mysql
RUN mkdir /backup/mysql/tmp
RUN mkdir /backup/mssql
RUN mkdir /backup/mssql/tmp
#Remove carraige returns fromm scripts from windows to linux
RUN sed -i -e 's/\r$//' /start.sh
RUN sed -i -e 's/\r$//' /rancher_stack_removal.sh
RUN sed -i -e 's/\r$//' /backup_mysql.sh
RUN sed -i -e 's/\r$//' /backup_mongo.sh
RUN sed -i -e 's/\r$//' /backup_mssql.sh
#set cron to run in forground
CMD /start.sh && cron -f