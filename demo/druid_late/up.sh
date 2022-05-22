#!/bin/sh

cd $(dirname $0)/../..

./network.sh

(cd kafka; docker compose up -d $(docker-compose config --services | grep -v schema-registry))
(cd druid; docker compose up -d --wait)
(cd dashboards; docker compose up -d superset --wait)
#(cd storage; docker compose up -d)

