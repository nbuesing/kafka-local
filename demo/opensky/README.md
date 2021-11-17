
# Geospatial Analytic Demonstration

## Requirements

* Java 11

* Docker Desktop (w/ built-in Docker Compose)

* `jq` command line tool (used in some scripts for parsing RESTful API responses

* Optional

  * Apache Kafka Confluent Community installation


## Steps

* Optional Steps

  * Mapbox
  
  Some of the superset charts leverage map data; if you are using them you will want to register with MapBox and attach the key to the superset.  
  The `docker-compose.yml` will use the environment variable `MAPBOX_API_KEY` if provided.
  
  * OpenSky

  OpenSky has limitations to how frequently it can be accessed.  Create a username/password if you need such access and update the opensky.properties to have those credentials.
  Change the configuration to accept them as well.

* build kafka-connect-opensky

  * this can be done using the `./build.sh` script

* build ksqldb-udf-geospatial

  * this can be done using the `./build.sh` script

* start all the necessary containers

  All the contatainers that need to be started for this demonstration can be done manually, or through the `up.sh` script.
  
  ```
  cd demo/opensky
  ./up.sh
  ```
  
  * Containers

    * Apache Kafka Cluster: 1 zookeeper, 4 brokers

    * Apache Kafka Distributed Connect Cluster: 2 connectors

    * KsqlDB

      * the ksql-cli is not deployed by default, assuming you have `ksql` as part of a local installation, and you can use that for connecting to the ksqlDB server.
  
    * Apache Druid

    * Apache Superset
  
      * to properly configure superset with druid support, a custom Docker image is created, see `dashboards/superset/Dockerfile` if you are interested.

* start up all the applications

  * `setup.sh` handles all of this for you, here is what it does

    * create the topics

    * start OpenSky connector

    * creates two ksql statements, one to ingest the data into ksqlDB and one to enrich the data with the user defined functions that were deployed with the ksqlDB.

    * Superset

  ```
  cd superset
  ./create.sh
  ```

  * summary
    
    * Create Database Connection

    * Create Dataset

    * Create Charts

    * Like Druid, you could do this all within superset manually.  The database and dataset are rather trivial to do manually.
    The charts are more difficult due to the nature of the preset time range query.
      
## Teardown

* stop all the containers and remove their volumes

  * ./down.sh
  
  * summary
  
    * goes into each directory that was part of the `up.sh` script and execute `docker compose down -v`. 
  
    * all volumes are removed; if you want to persist volumes adjust accordingly.


