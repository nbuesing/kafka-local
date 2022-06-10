java -Dlog4j.debug -Dlog4j.configuration=file:/debezium/log4j.properties -Dcassandra.storagedir=/var/lib/cassandra -jar /debezium/debezium-connector-cassandra.jar /debezium/config.properties 2>&1 >./debezium.log &

