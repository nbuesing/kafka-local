#!/bin/sh

cd $(dirname $0)/../..

if [[ ! -d ./connect/jars/kafka-connect-opensky || ! -f ./ksqldb/ext/ksqldb-udf-geospatial-1.0.0-all.jar ]]; then
  echo ""
  echo ""
  echo " run build.sh to build opensky connector and geospatial functions for KsqlDB and deploy them."
  echo ""
  echo ""
  exit
fi

./network.sh

(cd kafka; docker compose up -d $(docker-compose config --services | grep -v schema-registry))

(cd connect; docker compose up -d)

(cd ksqlDB; docker compose up -d)

(cd druid; docker compose up -d)

(cd dashboards; docker compose up -d)

