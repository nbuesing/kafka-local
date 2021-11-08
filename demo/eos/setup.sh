#!/bin/sh

DIR=$(dirname $0)

cd $DIR

BIN=$DIR/../../bin

CONNECT=$BIN/connect
DRUID=$BIN/druid
KSQL=$BIN/ksql-shell


alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'


$CONNECT available
[ $? -ne 0 ] && echo "connector RESTful API is not yet available, aborting script. wait until connector is ready to run this script." && exit 1


# also done in build.sh
cp -r data/* ../../connect/data


kt --create --replication-factor 3 --partitions 4 --topic orders
kt --create --replication-factor 3 --partitions 4 --topic ORDERS_ENRICHED
kt --create --replication-factor 3 --partitions 4 --topic users
kt --create --replication-factor 3 --partitions 4 --topic stores

$CONNECT plugins
[ $? -eq 1 ] && error_msg "connect RESTful API not yet available" && exit 1


$CONNECT create ./connectors/store.json
$CONNECT create ./connectors/user.json
$CONNECT create ./connectors/order.json

$KSQL ./ksql/users.ksql
$KSQL ./ksql/stores.ksql
$KSQL ./ksql/orders.ksql

echo "sleeping 5 seconds to make sure the tables for users and stores are hydrated before orders enrichment stream is created"
sleep 5
$KSQL ./ksql/orders_enriched.ksql

$DRUID load ./druid/order.json
