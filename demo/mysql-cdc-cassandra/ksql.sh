#!/bin/sh

JAVA_HOME=$JAVA14_HOME

DIR=$(dirname $0)
cd $DIR

BIN=$DIR/../../bin
KSQL=$BIN/ksql-shell

$KSQL ./ksql/users.ksql
$KSQL ./ksql/stores.ksql
$KSQL ./ksql/orders.ksql
$KSQL ./ksql/orders_enriched.ksql
