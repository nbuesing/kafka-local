

# Late Arriving Data into a Real-Time Pipeline into Druid 

This demonstration it to show the negative impacts late-arriving data has to the file segments of an Apache Druid instance.

### ./build.sh

Downloads and installs the Kafka Connect S3 Sink Connector into Kafka Connect Cluster.
creates s3 key/secret into connects secret folder that connector uses for security w/out exposing those credentials in the configruation.

### ./up.sh

Starts up the needed services

 * Apache Kafka (1 zookeeper, 4 brokers, but not the schema registry)
 * Kafka Connect (2 connectors running in distributed mode)
 * Apache Druid
 * Superset (Custom image to enable pydruid for druid connection; and default admin account)
 * Minio (S3 Complaint Object Store)

### ./setup.sh

  * Creates 2 Kafka Topics `orders` and `skus` each with 4 partitions and replication factor of 3.
  * S3 Buckets `sku` and `order`.
  * Create S3 credentials that aligns with the credentials used by connector (established in the build.sh).

### ./druid.sh

  * Creates Druid datasources for `orders` and `skus`. 
This can be done w/out any data in the topics, but the topics need to exist.

  * `orders`

    * schema 
      * Time
        * timestamp - minute level prevision (truncated to minute)
      * Dimensions
        * orderId
        * userId
        * storeId
      * Metrics
        * count 
    * configuration
      * 5 minute segment granularity
      * roll-ups enabled

  * `skus`

    * schema
        * Time
            * timestamp - minute level prevision (truncated to minute)
        * Dimensions
            * sku
            * storeId
        * Metrics
            * count
            * quantity
    * configuration
        * 5 minute segment granularity
        * roll-ups enabled

### ./connect.sh

  * Starts the Kafka Connect S3 Sink Connector for the `skus` topic writing to the `sku` bucket.
  * This is writing to the s3 complaint object store, Minio, running as a container in the local stack.
    * Data is partitioned by time `'y'=YYYY/'m'=MM/'d'=dd/'H'=HH`
    * `timestamp` is extracted from the message, leveraging the same timestamp field that is being used by Druid

### Publisher (Fake Data Generator)

A light-weight Java application to generate fake data of orders. 
It publishes both to an `orders` topic and each product to the `skus` topic.
It is built using Gradle (7.4.2) and Java 18.

To build the project, use `gradle build` in addition to compiling the code it will generate a script, `ruh.sh`.
This script run the application w/out having to rebuild and assemble a distribution bundle. 

```
#!/bin/sh
set -e
gradle assemble > /dev/null
export CP="${CP}:..."
java -cp ${CP} dev.buesing.ksd.publisher.Main "$@"
```

To generate orders with current timestamp, simply run with:

```
./run.sh
```

To generate orders with a historical timestamp, run with a timestamp range:

```
./run.sh --min-timestamp "2022-01-01 00:00:00" --max-timestamp "2022-05-01 00:00:00"
```

Other options are available, see those options by leveraging the `--help` argument.

```
./run.sh --help
```

### ./superset.sh

  * Creates the database reference to `druid`, a dataset for `orders`, and a dataset for `skus`.
  * Creates two charts with the `skus` dataset, a sku/store pivot table, and a store order time-series graf.
  * This cannot be done until the Druid data-sources exist, otherwise the datasets will fail being created.

### Visualization / Tool Access

The applications are accessible via localhost with the port mappings from the container to your host machine.

#### Druid

* http://localhost:48888/unified-console.html#segments

#### Superset

* http://localhost:28088/
* username: `admin`
* password: `superset`

#### Minio

* http://localhost:9001/
* username: `admin`
* password: `miniominio`

#### Connect

* http://localhost:18083

No authentication or authorization required to communicate with the connect cluster.

`./bin/connect` is a script to provide systemctl like commands to connectors. 
