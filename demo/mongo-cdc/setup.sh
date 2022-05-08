#!/bin/sh

DIR=$(dirname $0)
cd $DIR
BIN=$DIR/../../bin
CONNECT=$BIN/connect

alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

$CONNECT available
[ $? -ne 0 ] && echo "connector RESTful API is not yet available, aborting script. wait until connector is ready to run this script." && exit 1

kt --create --replication-factor 3 --partitions 4 --topic mysql_main.MAIN.users
kt --create --replication-factor 3 --partitions 4 --topic mysql_main.MAIN.stores
kt --create --replication-factor 3 --partitions 4 --topic mysql_main.MAIN.orders

cat > ../../mysql/data/schema.sql <<EOF
drop table if exists \`orders\`;
create table \`orders\` (
    \`order_id\` varchar(10) NOT NULL,
    \`store_id\` varchar(10) NOT NULL,
    \`user_id\` varchar(10) NOT NULL,
    \`quantity\` integer NULL,
    primary key (\`order_id\`)
);
drop table if exists \`stores\`;
create table \`stores\` (
    \`store_id\` varchar(10) NOT NULL,
    \`store_name\` varchar(400) NOT NULL,
    primary key (\`store_id\`)
);
drop table if exists \`users\`;
create table \`users\` (
    \`user_id\` varchar(10) NOT NULL,
    \`user_name\` varchar(400) NOT NULL,
    primary key (\`user_id\`)
);
EOF
docker exec -it mysql sh -c "cat /data/schema.sql | mysql --user=user --password=userpw MAIN"


$CONNECT create ./connectors/mysql-cdc.json
$CONNECT status ./connectors/mysql-cdc.json
