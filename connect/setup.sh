#!/bin/sh

base=$(dirname $0)

cd $base


#curl -s -O http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz

#http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz
sudo tar xfv ~/workspaces/nbuesing/kafka-local/connect/confluent-hub-client-latest.tar.gz

mkdir -p tmp
touch tmp/connect-distributed.properties

#(cd /usr/local/confluent;sudo curl -s http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz | tar xfv -)


#
# kafka-connect-jdbc 
#
#  need to also add the mysql jdbc driver
#

(cd ./jars; rm -fr ./confluentinc-kafka-connect-jdbc-10.3.x-SNAPSHOT)
(cd ./jars; unzip /Users/buesing/workspaces/confluentinc/kafka-connect-jdbc/target/components/packages/confluentinc-kafka-connect-jdbc-10.3.x-SNAPSHOT.zip)
(cd ./jars/confluentinc-kafka-connect-jdbc-10.3.x-SNAPSHOT/lib; curl -s -k -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.21.tar.gz | tar xfv -  --strip-components=1 -- mysql-connector-java-8.0.21/mysql-connector-java-8.0.21.jar)



#confluent-hub install --worker-configs ./tmp/connect-distributed.properties --component-dir ./jars --no-prompt confluentinc/kafka-connect-jdbc:10.2.0
#(cd ./jars/confluentinc-kafka-connect-jdbc/lib; curl -s -k -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.21.tar.gz | tar xfv -  --strip-components=1 -- mysql-connector-java-8.0.21/mysql-connector-java-8.0.21.jar)

#
# debezium
#
#confluent-hub install --worker-configs ./tmp/connect-distributed.properties --component-dir ./jars --no-prompt debezium/debezium-connector-mysql:1.5.0 

#
# elasticsearch
#
#confluent-hub install --worker-configs ./tmp/connect-distributed.properties --component-dir ./jars --no-prompt confluentinc/kafka-connect-elasticsearch:11.0.4


confluent-hub install --worker-configs ./tmp/connect-distributed.properties --component-dir ./jars --no-prompt confluentinc/kafka-connect-s3:10.0.1


(cd jars; curl -s https://github.com/aiven/aiven-kafka-connect-gcs/releases/download/v0.9.0/aiven-kafka-connect-gcs-0.9.0.tar | tar xfv -)



rm -fr ./tmp/connect-distributed.properties
