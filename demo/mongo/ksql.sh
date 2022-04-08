#!/bin/sh

DIR=$(dirname $0)
cd $DIR

BIN=$DIR/../../bin
KSQL=$BIN/ksql-shell

$KSQL ./ksql/users.ksql
$KSQL ./ksql/stores.ksql
$KSQL ./ksql/orders.ksql
