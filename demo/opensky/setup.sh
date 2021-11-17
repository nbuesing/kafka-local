#!/bin/sh

DIR=$(dirname $0)

cd $DIR

BIN=$DIR/../../bin

CONNECT=$BIN/connect
DRUID=$BIN/druid
KSQL=$BIN/ksql-shell

alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

#
# connect startup is usually the last service up from those that are not dependent on others, so we make sure that is up before we run through the script.
#
# if/when other services end up being a startup-issue, checks for them should be considered.
# 

$CONNECT available
[ $? -ne 0 ] && echo "connector RESTful API is not yet available, aborting script. wait until connector is ready to run this script." && exit 1


kt --create --replication-factor 3 --partitions 4 --topic flightdata
kt --create --replication-factor 3 --partitions 4 --topic FLIGHTS_SUMMARY

$CONNECT create ./connectors/opensky.json

$KSQL ./ksql/flights.ksql
sleep 1
$KSQL ./ksql/flights_summary.ksql


$DRUID load ./druid/flight_summary.json

./superset/create.sh
