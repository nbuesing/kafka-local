#!/bin/sh

cd $(dirname $0)/../..

./network.sh

(cd kafka; docker compose up -d $(docker-compose config --services | grep -v schema-registry))
(cd connect; docker compose up -d)
(cd druid; docker compose up -d)
(cd ksqlDB; docker compose up -d)

