#!/bin/sh
source config.sh
if [ -f $1 ]
then
	echo "Usage error: ./delete-droplet.sh [droplet ID]"
	exit -1
fi
echo "Deleting droplet $1"
curl -X DELETE -H 'Content-Type: application/json' -H "Authorization: Bearer $api_key" "https://api.digitalocean.com/v2/droplets/$1"