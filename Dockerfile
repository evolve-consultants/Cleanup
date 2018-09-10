FROM alpine:latest

ENV Rancher_URL=**None** \
    RANCHER_ACCESS_KEY=**None** \
    RANCHER_SECRET_KEY=**None** \
   
ENTRYPOINT ["/Entrypoint.sh"]
    
# Copy required files
COPY ./Entrypoint.sh /Entrypoint.sh
COPY ./rancher /rancher
#make files executable
RUN chmod +x /Entrypoint.sh
RUN chmod +x /rancher
# Run the cron every evening at 11 oclock
RUN echo '23  00  *  *  *    /Entrypoint.sh' > /etc/crontabs/root
#set cron to run at log level 2 and in forground
CMD ['crond', '-l 2', '-f']
