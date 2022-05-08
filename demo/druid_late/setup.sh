#!/bin/sh

DIR=$(dirname $0)

cd $DIR

BIN=$DIR/../../bin

DRUID=$BIN/druid
KSQL=$BIN/ksql-shell


alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

kt --create --replication-factor 3 --partitions 4 --topic orders

