#!/bin/sh

cd $(dirname $0)

touch ../tmp/connect-distributed.properties

if [ ! -d "../../connect/jars/debezium-debezium-connector-mysql" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt debezium/debezium-connector-mysql:1.7.1
fi

if [ ! -d "../../connect/jars/confluentinc-kafka-connect-jdbc" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt confluentinc/kafka-connect-jdbc:10.2.5
  (cd ../tmp; curl -s https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-8.0.27.tar.gz | tar xf - mysql-connector-java-8.0.27/mysql-connector-java-8.0.27.jar)
  mv ../tmp/mysql-connector-java-8.0.27/mysql-connector-java-8.0.27.jar ../../connect/jars/confluentinc-kafka-connect-jdbc/lib
fi

rm -f ../tmp/connect-distributed.properties

