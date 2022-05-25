# Demos

Each folder is a demonstration that leverages the `kafka-local` environment to showcase various aspects of event processing.

## Demo structure
  
* `./build.sh` - anything that needs to be done prior to starting containers.

  This is primarily for installation of various connect workers into the Kafka Connect cluster, since
  those connectors need to be installed before the cluster is started.

* `./up.sh` - starts up all the containers needed for the demonstration
   
  This is the minimal or near minimal starting of all the containers for the demonstration.

* `./setup.sh` - sets up the complete demonstration. This is what should be interrogated to 
change or understand what is going on.

* `./stop.sh` - stops all the containers that were started with `up.sh`.

* `./down.sh` - brings down the containers startd with `./up.sh` and remove any volumes.

* other scripts may exist, for typically running after `setup.sh` if the setup requires more orchestration (for example you cannot create stream datasources )

## Service passwords

* The admin account username for the applications that require one is `admin`.

* The admin account password is the application name, when possible. For example, the password for `grafana` is `grafana`.
Some systems have password requirements that makes this poor passwords not allowed. The password for `minio` is `miniominio`.

## Demos

### druid_late

This demonstration showcases how late arriving data can lead to open segments with sparse amount of data.

### opensky

### eos

### cdc
