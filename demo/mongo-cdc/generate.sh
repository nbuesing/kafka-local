#!/bin/bash

if [ $# -lt 1 ]; then
 COUNT=1
else
 COUNT=$1
 shift
fi

function number() {
  echo $(($RANDOM % $1))
}

function random() {
  echo $(openssl rand -hex 5)
}

for i in $(seq $COUNT); do

        order_id=$(random)
        store_id=$(number 100)
        user_id=$(number 1000)
        quantity=$(number 9999)
        ts=$(date +"%Y-%m-%d %H:%M:%S")

 	echo "creating order order_id=${order_id}, store_id=${store_id}, user_id=${user_id}, quantity=${quantity}, ts=${ts}"

        DOC="{ \"order_id\" : \"${order_id}\"  }"

	#curl -i -H "Content-Type:application/json" -X POST -u "admin:restheart" http://localhost:28080/ABC -d "${DOC}"
	curl -i -H "Content-Type:application/json" -X POST -u "admin:secret" http://localhost:28080/main -d "${DOC}"

#        sleep 0.1

done
