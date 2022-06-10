#!/bin/sh

cd $(dirname $0)

touch ../tmp/connect-distributed.properties

#curl -s -O https://repo1.maven.org/maven2/io/debezium/debezium-connector-cassandra-core/1.9.3.Final/debezium-connector-cassandra-core-1.9.3.Final.jar

#curl -fSL -o debezium-connector-cassandra.jar https://repo1.maven.org/maven2/io/debezium/debezium-connector-cassandra/1.9.3.Final/debezium-connector-cassandra-1.9.3.Final-jar-with-dependencies.jar

#curl -s -o debezium-connector-cassandra.jar https://repo1.maven.org/maven2/io/debezium/debezium-connector-cassandra/1.9.0.Beta1/debezium-connector-cassandra-1.9.0.Beta1-jar-with-dependencies.jar
curl -s -o debezium-connector-cassandra.jar https://repo1.maven.org/maven2/io/debezium/debezium-connector-cassandra/1.8.1.Final/debezium-connector-cassandra-1.8.1.Final-jar-with-dependencies.jar


#if [ ! -d "../../connect/jars/debezium-debezium-connector-mongodb" ]; then
#  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt debezium/debezium-connector-mongodb:1.9.2
#fi

#if [ ! -d "../../connect/jars/mongodb-kafka-connect-mongodb" ]; then
#  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt mongodb/kafka-connect-mongodb:1.7.0
#fi


rm -f ../tmp/connect-distributed.properties

