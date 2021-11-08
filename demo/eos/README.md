
* `build.sh` to download and install the connectors into the Connect cluster.
  
   * the docker containers for the two connect clusters mount a `./jars` directory for these additional connectors.
Within an actual deployment, `confluent-hub` would be used within those machines to do the installation.

   * the data needed for those connectors are also copied over to a data directory that is available from
those workers. The `spooldir` and `datagen` connectors requires the files to be accessible from the connect workers. For a
production deployment the use of a common mount point (for on prem installation) or cloud buckets are prefered.


 
* `up.sh` to create all of the containers within `kafka-local` needed for the demo.

  * `kafka`: 1 zookeeper and 4 brokers (no schema-registry).

  * `connect`: 2 connect clusters, with mount points for adding connectors and the data needed by the connectors.

    * `spooldir` and `datagen` opensource connectors
  
  * `ksqlDB`: the `ksql-server`, the command line container is available, but commented out as expectations is that 
confluent community source installation is on your local machine.  
   
  * `druid`: a minimal instance of druid, druid has its own zookeeper instance (kafka's is not shared).



* `setup.sh`: the configure everything script

  * In a hurry to see how everything works, just run the `setup.sh` script.  

  * topics created, connectors created, ksql statements created, and druid specifications started.

  * run these manually if you want to see how things work; the druid specification can be copied into the UI 
and then modified to see various changes could impact it.


* `down.sh`: use this to shut down all the containers within `up.sh`.  

  * It does shutdown a few of the other compose files assuming they may have been manually started as well.

  * `-v` is used so all volumes will be removed as well.




* the `./bin` directory of `kafka-local` provides scripts to interact with the various systems.  usually within the 
`setup.sh` script of a demo.  

  * `ksql-restart` is a convience script to restart the ksql-server and change processing guarentee. It also
will do `shutdown` or a `kill`.  The use of `kill` illistrates the importantce of exactly once semantics.
