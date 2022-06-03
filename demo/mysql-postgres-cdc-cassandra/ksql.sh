#!/bin/sh

JAVA_HOME=$JAVA14_HOME

DIR=$(dirname $0)
cd $DIR

BIN=$DIR/../../bin
KSQL=$BIN/ksql-shell

$KSQL ./ksql/mysql_users.ksql
$KSQL ./ksql/mysql_stores.ksql
$KSQL ./ksql/mysql_orders.ksql

$KSQL ./ksql/postgres_users.ksql
$KSQL ./ksql/postgres_stores.ksql
$KSQL ./ksql/postgres_orders.ksql

$KSQL ./ksql/mysql_orders_enriched.ksql
$KSQL ./ksql/postgres_orders_enriched.ksql

$KSQL ./ksql/union.ksql
