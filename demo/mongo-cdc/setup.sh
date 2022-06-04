#!/bin/sh

DIR=$(dirname $0)
cd $DIR
BIN=$DIR/../../bin
CONNECT=$BIN/connect

alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

$CONNECT available
[ $? -ne 0 ] && echo "connector RESTful API is not yet available, aborting script. wait until connector is ready to run this script." && exit 1

#kt --create --replication-factor 3 --partitions 4 --topic mysql_main.MAIN.users
#kt --create --replication-factor 3 --partitions 4 --topic mysql_main.MAIN.stores
#kt --create --replication-factor 3 --partitions 4 --topic mysql_main.MAIN.orders

#restheart.restheart.ABC
#restheart.restheart.ABC2
#restheart.restheart.DEF


$CONNECT create ./connectors/mongo-cdc.json
$CONNECT status ./connectors/mongo-cdc.json

$CONNECT create ./connectors/mongo.json
$CONNECT status ./connectors/mongo.json
