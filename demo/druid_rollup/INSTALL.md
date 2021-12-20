
* `build.sh` 

  * Installs `Datagen` connector into Kafka Connect.
  
* `up.sh` 

  * Starts Kafka Cluster, Kafka Connect, ksqlDB, and Druid.
  
* `setup.sh`

  * Verifies connect RESTful API is up and available, aborts immediately if it is not.
  
  * Copies the data needed by the `Datagen` connector to where it is accessible by the connector from the distributed connect cluster.  
  
  * Creates the Kafka topics `Datagen` 
  
  * Starts the 3 `Dategen` connectors: `user`, `store`, and `order`.

  * Creates ksql for ingesting `users`, `stores`, and `orders`.

  * Create the enriched order that combines and `order` with the store and user, key the topic by `ORDER_ID`. Make sure the ORDER_ID remains in the value,
    since Druid cannot pull data from the key.

  * Create another ksql stream to rekey the enriched order to where the topic is keyed by `USER_REWARD`. Make sure the USER_REWARD remains in the value,
    since Druid cannot pull data from the key.

* `down.sh`

  * shuts down all the containers and remove volumes.  
