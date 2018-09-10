FROM alpine

# Copy script which should be run
COPY ./myawesomescript /usr/local/bin/myawesomescript
RUN chmod +x /usr/local/bin/myawesomescript
# Run the cron every eve at 11 oclock
RUN echo '23  00  *  *  *    /usr/local/bin/myawesomescript' > /etc/crontabs/root

CMD ['crond', '-l 2', '-f']
