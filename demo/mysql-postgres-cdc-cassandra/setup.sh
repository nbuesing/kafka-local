#!/bin/sh

function heading() {
  tput setaf 2; printf "\n\n$@\n"; tput sgr 0
}

function footing() {
  tput setaf 4; printf "\n$@\n\n"; tput sgr 0
}

function subheading() {
  tput setaf 3; printf "\n$@\n\n"; tput sgr 0
}


DIR=$(dirname $0)
cd $DIR
BIN=$DIR/../../bin
CONNECT=$BIN/connect

alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

$CONNECT available
[ $? -ne 0 ] && echo "connector RESTful API is not yet available, aborting script. wait until connector is ready to run this script." && exit 1

heading "setup: started"

subheading "kafka: create topics"
#kt --create --replication-factor 3 --partitions 4 --topic mysql_main.main.users
#kt --create --replication-factor 3 --partitions 4 --topic mysql_main.main.stores
#kt --create --replication-factor 3 --partitions 4 --topic mysql_main.main.orders
#kt --create --replication-factor 3 --partitions 4 --topic ORDERS_ENRICHED

subheading "mysql: create tables"
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
docker exec -it mysql sh -c "cat /data/schema.sql | mysql --user=user --password=userpw main"
rm -f ../../mysql/data/schema.sql

subheading "postgres: create tables"
cat > ../../postgres/data/schema.sql <<EOF
drop table if exists "orders";
create table "orders" (
    "order_id" varchar(10) NOT NULL,
    "store_id" varchar(10) NOT NULL,
    "user_id" varchar(10) NOT NULL,
    "quantity" integer NULL,
    "ts" timestamp NULL,
    primary key ("order_id")
);
drop table if exists "stores";
create table "stores" (
    "store_id" varchar(10) NOT NULL,
    "store_name" varchar(400) NOT NULL,
    primary key ("store_id")
);
drop table if exists "users";
create table "users" (
    "user_id" varchar(10) NOT NULL,
    "user_name" varchar(400) NOT NULL,
    primary key ("user_id")
);

CREATE ROLE main REPLICATION LOGIN;

EOF
docker exec -it postgres sh -c "cat /data/schema.sql | psql --dbname=main --user=admin"
rm -f ../../postgres/data/schema.sql


subheading "connect : start debezium mysql cdc source connector"
$CONNECT create ./connectors/mysql-cdc.json
$CONNECT status ./connectors/mysql-cdc.json

subheading "connect : start debezium postgres cdc source connector"
$CONNECT create ./connectors/postgres-cdc.json
$CONNECT status ./connectors/postgres-cdc.json

subheading "cassandra : create keyspace and tables"
cat > ../../cassandra/data/schema.sql <<EOF
create keyspace if not exists "main" with replication = {'class':'SimpleStrategy','replication_factor':1};
use "main";
create table "orders" (order_id text primary key, store_id text, user_id text, quantity int, ts timestamp);
create table "orders_enriched" (order_id text primary key, store_id text, store_name text, user_id text, user_name text, quantity int, ts timestamp);
create table "all_orders" (source_system text, order_id text, store_id text, store_name text, user_id text, user_name text, quantity int, ts timestamp, PRIMARY KEY (source_system, order_id));
EOF
docker exec -it cassandra sh -c "cat /data/schema.sql | cqlsh --password=cassandra"
rm -f ../../cassandra/data/schema.sql

subheading "connect : start the datastax cassandra sink connector"
$CONNECT create ./connectors/cassandra.json
$CONNECT status ./connectors/cassandra.json

#
subheading "mysql : Load 100 stores into the 'stores' table and 1000 users into the 'users' table."
#
sleep 1
cp ./data/stores.csv ../../mysql/data/stores.csv
cp ./data/users.csv ../../mysql/data/users.csv
cat > ../../mysql/data/load.sql <<EOF
LOAD DATA LOCAL INFILE '/data/stores.csv' INTO TABLE stores FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE '/data/users.csv' INTO TABLE users FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
EOF
docker exec -it mysql sh -c "cat /data/load.sql | mysql --user=user --password=userpw main"
rm -f ../../mysql/data/load.sql
rm -f ../../mysql/data/stores.csv
rm -f ../../mysql/data/users.csv

#
subheading "postgres : Load 100 stores into the 'stores' table and 1000 users into the 'users' table."
sleep 1
cp ./data/stores.csv ../../postgres/data/stores.csv
cp ./data/users.csv ../../postgres/data/users.csv
cat > ../../postgres/data/load.sql <<EOF
truncate stores;
COPY stores(store_id, store_name) FROM '/data/stores.csv' DELIMITER ',' CSV HEADER;
truncate users;
COPY users(user_id, user_name) FROM '/data/users.csv' DELIMITER ',' CSV HEADER;
EOF
docker exec -it postgres sh -c "cat /data/load.sql | psql --dbname=main --user=admin"
rm -f ../../postgres/data/load.sql
rm -f ../../postgres/data/stores.csv
rm -f ../../postgres/data/users.csv

footing "setup: completed"
