#!/bin/bash
#Create env list for cron to access and give it executr permissions
printenv | grep -v CRON | sed 's/^\([a-zA-Z0-9_]*\)=\(.*\)$/export \1="\2"/g' > /env.sh
chmod +x /env.sh

cronfile=/etc/cron.d/cron
cat /dev/null > $cronfile
for cronvar in ${!CRON_*}; do
	cronvalue=${!cronvar}
	echo "Installing $cronvar"
	echo "$cronvalue >> /var/log/cron.log 2>&1" >> $cronfile
done
echo >> $cronfile # Newline is required
