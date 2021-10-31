#!/bin/sh

DIR=$(dirname $0)

cd $DIR

BIN=$DIR/../../bin

CONNECT=$BIN/connect
DRUID=$BIN/druid

alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

# also done in build.sh
cp -r data/* ../../connect/data


kt --create --replication-factor 3 --partitions 4 --topic orders
kt --create --replication-factor 3 --partitions 4 --topic ORDERS_ENRICHED
kt --create --replication-factor 3 --partitions 4 --topic users
kt --create --replication-factor 3 --partitions 4 --topic stores

$CONNECT create ./connectors/store.json
$CONNECT create ./connectors/user.json
$CONNECT create ./connectors/order.json

$DIR/ksql/ksql-shell ./ksql/users.ksql
$DIR/ksql/ksql-shell ./ksql/stores.ksql
$DIR/ksql/ksql-shell ./ksql/orders_in.ksql
sleep 5
$DIR/ksql/ksql-shell ./ksql/orders_out.ksql

sleep 2
$DRUID load ./druid/order.json
