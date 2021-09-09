# Introduction

* This project is to provide a complete ecosystem to do local Kafka development w/out the need to connect to external systems.

* Each directory has its own `docker-compose.yml` and its own docker-compose project defined in the `.env` property file.

  * this makes it easy to start/stop only what you need.
  
  * the network is created as external to allow for the containers between compose files to communicate while also not
    requiring any specific docker compose to be running.
  
* Even though you are running all of the Kafka components from docker containers, you will want the software installed 
  locally so you can use the command line operations; personally, I install the confluent community edition installation
  locally in `/usr/local/confluent`, and add `/usr/local/confluent/bin` to my path.
  
* Go to Confluent's [get-started](https://www.confluent.io/get-started), select the **here** link (javascript so I cannot deep link it) 
  in the Download Confluent Platform section to get the download for community edition.

# kafka

  * This is the `Apache Kafka Cluster` and is the core pieces needed for working with Kafka Brokers
  
  * 1 Zookeeper
  
  * 4 Brokers
  
  * 1 Schema Registry
  
  * If you are running on a machine with limited resources, considering commenting out `broker-4`.
  
  * Having 4 brokers showcases how Kafka works better, in that most topics have a replication factor of 3,
  and this showcases that some brokers do not have any data for a given partition of a topic.
  
  * Only one zookeeper is provided, in an actual setup we would have 3 or 5 zookeepers. As of Kafka 2.8 it is possible
    to explore Kafka w/out the use of Zookeeper for the quorum.
  
  * Only one schema registry is provided, in an actual setup we would have 2 for high-availability reasons.
  
# monitoring

  * this is an optional set of containers to monitor the health of Kafka
  
  * Grafana provides a dashboard to monitoring the Kafka metrics.
  
    * `http://localhost:3000`
    
    * username: `admin`
    
    * password: `grafana`
  
  * `kowl` and `kafka-ui` are provided for kafka exploration through a UI interface. I have not used `kafka-ui`, but
     looks promising. I enjoy using `kowl`. Other options to use would be `akhq`, `kafdrop` and `conduktor`.
  
# connect

  * As of Kafka 2.6 (`confluent-community` 6.0) most of the bundled connectors were removed; this is great in that it allows
for easier upgrading of connectors w/out having to upgrade `connect`. 
    
  * Place the desired connectors (unzipped) into the ./jars directory.  The script, `setup.sh` will install the latest version 
    of the JDBC connector, Elasticsearch connector, and the Debezium (for mysql).  The JDBC connector provides the oracle ojdbc.jar
    for connecting to Oracle, but the MySQL mysql-connector-java has to be downloaded separately and added; again this is all
    part of the provided `setup.sh` file.
    
# ksqlDB

 * a single KSQL Server and KSQL Command Line Container
 
 * to access the command line interface
 
   ```
   docker exec -it kl_ksql-client bash
   % ksql http://ksql-server:8088
   ```

# elasticsearch

 * provides elasticsearch and kabana containers

# mysql

 * provides a MySQL database with bin-log enabled
  
 * see Debeizum connector in connectors for accessing data with CDC.

# oracle

 * provides an Oracle datbase with logminer enabled
 
 * see kafka-connect-logminer in connectors for accessing data with CDC.
 
 * the Oracle container must be built, see [README](./oracle/README.md).

# connectors

 * the connector project provides command line access to create/delete connectors.
 
 * connector must be built within the connect container or provided in the `connect-lib` directory.
 
 * currently, the connector has the jdbc connectors with mysql and oracle drivers added,
 elastic search, and debezium CDC connector.
 
 * use confluent-hub to install additional connectors, or have them build and placed in the `connect-lib` directory.
 
 
