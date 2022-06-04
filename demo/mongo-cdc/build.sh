#!/bin/sh

cd $(dirname $0)

touch ../tmp/connect-distributed.properties


if [ ! -d "../../connect/jars/debezium-debezium-connector-mongodb" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt debezium/debezium-connector-mongodb:1.9.2
fi

if [ ! -d "../../connect/jars/mongodb-kafka-connect-mongodb" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt mongodb/kafka-connect-mongodb:1.7.0
fi


rm -f ../tmp/connect-distributed.properties

