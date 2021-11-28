# Demos

Each folder is a demonstration that leverages the `kafka-local` environment to showcase various aspects of event processing.

## Demo structure
  
* `./build.sh` - anything that needs to be done prior to starting containers.

  This is primarily for installation of various connect workers into the Kafka Connect cluster, since
  those connectors need to be installed before the connect cluster is started.

* `./up.sh` - starts up all the containers needed for the demonstration
   
  This is the minimal or near minimal starting of all the containers for the demonstration.

* `./setup.sh` - sets up the complete demonstration. This is what should be interrogated to 
change or understand what is going on.

* `./stop.sh` - stops all the containers that were started with `up.sh`.

* `./down.sh` - brings down all of the containers and remove any volumes.


## Demos

### opensky

### eos

### cdc
