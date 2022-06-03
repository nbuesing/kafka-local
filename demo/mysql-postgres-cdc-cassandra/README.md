
## MySQL and Postgres Change Data Capture To Cassandra

* This demonstration demonstrates change data capture from a MySQL database, enrichment by ksqlDB, and the stores
the resulting enriched stream of data to Cassandra.

* Uses and Stores are created and stored in tables in MySQL and replicated to topics in Kafka. 

* Orders are also created and stored in tables in MySQL, a script is provided to generate random orders.

* The tables in MySQL are streamed into Kafka topics using the Debezium MySQL CDC source connector.  MySQL has
binlog enabled to allow the connector to capture all changes to the MySQL databse.

* ksqlDB joins the stream of orders to the tables of users and stores to create an enriched ordered. This enriched order
is written to Cassandra using the open-source Datastax Cassandra sink connector.

* This demonstration leverages docker and docker compose to provide a fully contained demonstration of this pprocess.

## Containers 

* Kafka (1 Zookeeper, 4 Brokers, and 1 Schema Registry)

* Kafka Connect (2 distributed workers in a single connect cluster)

  * Debezium MySQL Source Connector
  * Datastax Cassandra Sink Connector

* MySQL (with binlog enabled to allow for the Debezium source connector to obtain changes from the database)

* Postgres (with loggine enabled)

* Cassandra

* ksqlDB

## Setup

### `build.sh`

  * The Debezium and Datastax connectors needs to be installed in the distributed connect cluster before it is started.
This script downloads them from the confluent hub and installs them so the connect containers have access to them at startup.

### `up.sh`

  * starts all of the necessary containers 

  * it also waits to ensure that both connect distributed cluster and cassandra are fully available before returning; since
their startup times are longer than others (the others should be ready when they are). Do a `docker ps` to ensure all containers are up and healthy.

### `setup.sh`

  * creates kafka topics
  * creates database tables in both MySQL, Postgres, and Cassandra
  * loads `user` and `store` tables in MySQL and Postgres.
  * starts the `Debezium MySQL Source Connector`, `Debezium Postgresql Source Connector` and the `Datastax Cassandra Sink Connector`

### `./ksql.sh`

  * creates the `ORDERS`, `STRORES`, and `USERS` streams from the CDC topic.

  * creates the `ENRICHED_ORDERS` stream that creates the enriched data.

### `generate.sh`

  * generates an order or N orders if a numerical value is provided as an argument.

  * random orders, but `store_id` and `user_id` are valid orders that exist in the `stores` and `users` tables.


## Teardown

### `down.sh`

  * shuts all the containers down

  * removes all volumes
