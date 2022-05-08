#!/bin/bash

function number() {
  echo $(($RANDOM % $1))
}

function random() {
  echo $(openssl rand -hex 5)
}


while true; do
        order_id=$(random)
 	echo "creating order id=${order_id}"
	docker exec mysql sh -c "echo \"insert into orders values('${order_id}', $(number 1000), $(number 1000), $(number 9999))\" | mysql --user=user --password=userpw MAIN "
        sleep 0.1
done
