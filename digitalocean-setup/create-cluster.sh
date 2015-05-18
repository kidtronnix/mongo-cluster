#!/bin/sh
source config.sh
DATE="$(date '+%Y%m%d%H%M%S')"
OUTPUT="cluster_${DATE}.json"

if [ "$#" -ne 2 ]
then
	echo "Usage error: ./create-cluster.sh [# mongo] [# mongos]"
	exit -1
fi

echo "Creating $1 mongo servers..."
touch "cluster_${DATE}.json"
echo "{ \"mongo-servers\": [ " >> "${OUTPUT}"
# create mongo servers, ie combined config, shard and replication servers
for i in $(seq $1)
do
   curl -s -L -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $api_key" -d "{\"name\":\"mongo$i\",\"region\":\"nyc3\",\"size\":\"512mb\",\"image\":\"centos-6-5-x64\",\"ssh_keys\":[\"$key_fingerprint\"],\"backups\":false,\"ipv6\":true,\"user_data\":null,\"private_networking\":null}" 'https://api.digitalocean.com/v2/droplets' >> "${OUTPUT}"
  if [ $i -ne $1 ]
  then
    echo ", " >> "${OUTPUT}"
  fi
done

echo "Creating $2 mongos servers..."
echo "], \"mongos-servers\": [ " >> "${OUTPUT}"
# create mongos servers, ie query routers
for i in $(seq $2)
do
   curl -s -L -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $api_key" -d "{\"name\":\"mongos$i\",\"region\":\"nyc3\",\"size\":\"512mb\",\"image\":\"centos-6-5-x64\",\"ssh_keys\":[\"$key_fingerprint\"],\"backups\":false,\"ipv6\":true,\"user_data\":null,\"private_networking\":null}" 'https://api.digitalocean.com/v2/droplets' >> "${OUTPUT}"
   if [ $i -ne $2 ]
   then
     echo ", " >> "${OUTPUT}"
   fi
done
echo "] }" >> "${OUTPUT}"

echo "Cluster created! Check ${OUTPUT} for details."
