# SQL Server Command Line Tools
FROM ubuntu:16.04
MAINTAINER SQL Server Engineering Team

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

CMD /bin/bash 

ENV Rancher_URL=**None** \
    RANCHER_ACCESS_KEY=**None** \
    RANCHER_SECRET_KEY=**None** \
    DB_SERVER=**None** \
    DB_USER=**None** \
    DB_PASSWORD=**None** \

# Copy required files
#COPY ./rancherstackremove.sh /rancherstackremove.sh
#COPY from databaseremove.sql=databaseremove.sql
#COPY rancher /rancher
#make files executable
#RUN chmod +x /rancher_stack_remove.sh
#RUN chmod +x /rancher
#RUN chmod +x /database_removal.sql
# Run the cron every evening at 11 oclock
RUN echo '23  00  *  *  *    /rancher_stack_remove.sh' > /etc/crontabs/root
RUN echo '23  05  *  *  *    /database_removal.sql' > /etc/crontabs/root
#set cron to run at log level 2 and in forground
CMD ['crond', '-l 2', '-f']
