#!/bin/bash

# 
# only works on running containers, since volume size is based on executing the du command on all volumes from within the container
#

containers=$(docker ps --format '{{.Names}}|{{.ID}}' | sort)

for container in $containers; do

  id=$(echo $container | cut -d\| -f2)
  name=$(echo $container | cut -d\| -f1)

  ip=$(docker inspect -f '{{.Name}} {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id)


  echo $ip

done


