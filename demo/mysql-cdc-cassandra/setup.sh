#!/bin/sh

DIR=$(dirname $0)
cd $DIR
BIN=$DIR/../../bin
CONNECT=$BIN/connect

alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

$CONNECT available
[ $? -ne 0 ] && echo "connector RESTful API is not yet available, aborting script. wait until connector is ready to run this script." && exit 1

#
echo ""
echo "Setup : Starting" 
echo ""
#

#
echo ""
echo "Kafka: Create Topics"
echo ""
#
kt --create --replication-factor 3 --partitions 4 --topic mysql_main.MAIN.users
kt --create --replication-factor 3 --partitions 4 --topic mysql_main.MAIN.stores
kt --create --replication-factor 3 --partitions 4 --topic mysql_main.MAIN.orders
kt --create --replication-factor 3 --partitions 4 --topic ORDERS_ENRICHED

#
echo ""
echo "MySql : Create Tables"
echo ""
#
cat > ../../mysql/data/schema.sql <<EOF
drop table if exists \`orders\`;
create table \`orders\` (
    \`order_id\` varchar(10) NOT NULL,
    \`store_id\` varchar(10) NOT NULL,
    \`user_id\` varchar(10) NOT NULL,
    \`quantity\` integer NULL,
    \`ts\` datetime NULL,
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
docker exec -it mysql sh -c "cat /data/schema.sql | mysql --user=user --password=userpw MAIN 2>/dev/null"
rm -f ../../mysql/data/schema.sql

#
echo ""
echo "Connect : Start the Debezium MySQL CDC Source Connector"
echo ""
# 
$CONNECT create ./connectors/mysql-cdc.json
$CONNECT status ./connectors/mysql-cdc.json

#
echo ""
echo "Cassandra : Create Keyspace and Tables"
echo ""
#
cat > ../../cassandra/data/schema.sql <<EOF
create keyspace if not exists "main" with replication = {'class':'SimpleStrategy','replication_factor':1};
use "main";
create table "orders" (order_id text primary key, store_id text, user_id text, quantity int, ts timestamp);
create table "orders_enriched" (order_id text primary key, store_id text, store_name text, user_id text, user_name text, quantity int, ts timestamp);
EOF
docker exec -it cassandra sh -c "cat /data/schema.sql | cqlsh --password=cassandra"
rm -f ../../cassandra/data/schema.sql

#
echo ""
echo "Connect : Start the Datastax Cassandra Sink Connector"
echo ""
#
$CONNECT create ./connectors/cassandra.json
$CONNECT status ./connectors/cassandra.json

#
echo ""
echo "MySQL : Load 100 stores into the 'stores' table and 1000 users into the 'users' table."
echo ""
#
sleep 1
cp ./data/stores.csv ../../mysql/data/stores.csv
cp ./data/users.csv ../../mysql/data/users.csv
cat > ../../mysql/data/load.sql <<EOF
LOAD DATA LOCAL INFILE '/data/stores.csv' INTO TABLE stores FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE '/data/users.csv' INTO TABLE users FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
EOF
docker exec -it mysql sh -c "cat /data/load.sql | mysql --user=user --password=userpw MAIN"
rm -f ../../mysql/data/load.sql
rm -f ../../mysql/data/stores.csv
rm -f ../../mysql/data/users.csv

#
echo ""
echo "Setup : Completed"
echo ""
#

