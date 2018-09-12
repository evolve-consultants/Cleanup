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

RUN apt-get update && apt-get install cron

ENV Rancher_URL=**None** \
    RANCHER_ACCESS_KEY=**None** \
    RANCHER_SECRET_KEY=**None** \
    DB_SERVER=**None** \
    DB_USER=**None** \
    DB_PASSWORD=**None**

# Copy required files
COPY ./rancher_stack_removal.sh /rancher_stack_removal.sh
COPY ./database_removal.sql /database_removal.sql
COPY ./rancher /rancher
COPY ./crontab /var/spool/cron/crontabs/root
#make files executable
RUN chmod +x /rancher_stack_removal.sh
RUN chmod +x /rancher
RUN chmod +x /database_removal.sql
RUN touch /var/log/cron.log

#set cron to run at log level 2 and in forground
CMD ["crond","-f"]