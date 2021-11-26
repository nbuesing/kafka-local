#!/bin/sh

DIR=$(dirname $0)

cd $DIR

BIN=$DIR/../../bin

CONNECT=$BIN/connect

alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

$CONNECT available
[ $? -ne 0 ] && echo "connector RESTful API is not yet available, aborting script. wait until connector is ready to run this script." && exit 1

# also done in build.sh
cp -r data/* ../../connect/data

kt --create --replication-factor 3 --partitions 4 --topic datagen.orders
kt --create --replication-factor 3 --partitions 4 --topic users
kt --create --replication-factor 3 --partitions 4 --topic stores


cat > ../../mysql/data/orders.sql <<EOF
drop table if exists \`orders\`;

create table \`orders\` (
    \`order_id\` varchar(256) NOT NULL,
    \`store_id\` varchar(10) NOT NULL,
    \`user_id\` varchar(10) NOT NULL,
    \`quantity\` integer NULL,
    \`address_city\` text NULL,
    \`address_state\` text NULL,
    \`address_zipcode\` integer NULL,

    primary key (\`order_id\`)
);

drop table if exists \`BACKUP\`.\`orders\`;

create table \`BACKUP\`.\`orders\` (
    \`order_id\` varchar(256) NOT NULL,
    \`store_id\` varchar(10) NOT NULL,
    \`user_id\` varchar(10) NOT NULL,
    \`quantity\` integer NULL,
    \`address_city\` text NULL,
    \`address_state\` text NULL,
    \`address_zipcode\` integer NULL,

    primary key (\`order_id\`)
);


EOF
docker exec -it mysql sh -c "cat /data/orders.sql | mysql --user=user --password=userpw MAIN"


$CONNECT create ./connectors/store.json
$CONNECT create ./connectors/user.json

$CONNECT create ./connectors/datagen-order.json
$CONNECT create ./connectors/mysql-order.json
$CONNECT create ./connectors/mysql-cdc.json
