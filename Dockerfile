FROM alpine:latest

ENV Rancher_URL=**None** \
    RANCHER_ACCESS_KEY=**None** \
    RANCHER_SECRET_KEY=**None** \
   
    
# Copy script which should be run
COPY ./myawesomescript /usr/local/bin/myawesomescript
#make script executable
RUN chmod +x /usr/local/bin/myawesomescript
# Run the cron every evening at 11 oclock
RUN echo '23  00  *  *  *    /usr/local/bin/myawesomescript' > /etc/crontabs/root
#set cron to run at log level 2 and in forground
CMD ['crond', '-l 2', '-f']
