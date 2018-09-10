#!/usr/bin/env bash

set -e

RANCHER_CLI="/usr/local/bin/rancher"


if [ ! -f ${RANCHER_CLI} ]; then
    echo "[ERR] Unable to find \"rancher\" executable. Exiting..."
    exit 1
fi

#Bring down review app stacks
for stack in '$RANCHER_CLI stacks ls -q | grep review-'; do
  $RANCHER_CLI rm -s $stack
  

		
				
