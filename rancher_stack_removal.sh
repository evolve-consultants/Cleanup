#!/bin/bash

set -e

RANCHER_CLI="/rancher"


if [ ! -f ${RANCHER_CLI} ]; then
    echo "[ERR] Unable to find \"rancher\" executable. Exiting..."
    exit 1
fi

#Bring down review app stacks
for stack in `$RANCHER_CLI stacks ls | grep review- | awk '{ print $1 }'`
do
$RANCHER_CLI rm -s $stack
done