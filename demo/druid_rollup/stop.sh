#!/bin/sh

cd $(dirname $0)/../..

# in case they were started
(cd dashboards; docker compose stop)

(cd connect; docker compose stop)
(cd druid; docker compose stop)
(cd ksqlDB; docker compose stop)
(cd kafka-lb; docker compose stop)
(cd kafka; docker compose stop)
