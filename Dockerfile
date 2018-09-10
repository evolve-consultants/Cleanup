FROM alpine:latest

ENV Rancher_URL=**None** \
    RANCHER_ACCESS_KEY=**None** \
    RANCHER_SECRET_KEY=**None** \
   
    
# Copy required files
COPY ./myawesomescript /usr/local/bin/myawesomescript
COPY ./rancher /usr/local/bin/rancher
#make files executable
RUN chmod +x /usr/local/bin/myawesomescript
RUN chmod +x /usr/local/bin/rancher
# Run the cron every evening at 11 oclock
RUN echo '23  00  *  *  *    /usr/local/bin/myawesomescript' > /etc/crontabs/root
#set cron to run at log level 2 and in forground
CMD ['crond', '-l 2', '-f']
