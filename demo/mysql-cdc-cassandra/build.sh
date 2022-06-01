#!/bin/sh

cd $(dirname $0)

touch ../tmp/connect-distributed.properties

if [ ! -d "../../connect/jars/datastax-kafka-connect-cassandra-sink" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt datastax/kafka-connect-cassandra-sink:1.4.0
fi

if [ ! -d "../../connect/jars/debezium-debezium-connector-mysql" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt debezium/debezium-connector-mysql:1.7.1
fi

rm -f ../tmp/connect-distributed.properties

