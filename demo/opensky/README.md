
# Geospatial Analytic Demonstration

## Requirements

* Java 11

* Docker Desktop (w/ built-in Docker Compose)

* `jq` command line tool (used in some scripts for parsing RESTful API responses

* Optional

  * Apache Kafka Confluent Community installation


## Steps

* Optionals

  * Mapbox

    * MAPBOX_API_KEY optional

  * OpenSky Credentials

    * ...

* build kafka-connect-opensky

  * this can be done using the `./build.sh` script

* build ksqldb-udf-geospatial

  * this can be done using the `./build.sh` script

* start all the necessary containers

  * ./up.sh

  * Setup

  * Apache Kafka Cluster: 1 zookeeper, 4 brokers

  * Apache Kafka Distributed Connect Cluster: 2 connectors

  * KsqlDB

  * Apache Druid

  * Apache Superset

* start OpenSky connector

  * ./connect create ./connector/opensky.json

* KsqlDB

  * create stream for topic created by connector

  * create table that enriches the data

* Druid

  * create the Druid Dataset

* Superset

  * Create Database Connection

  * Create Dataset

  * Create Chart

## Teardown

* stop all the containers and remove their volumes

  * ./down.sh


