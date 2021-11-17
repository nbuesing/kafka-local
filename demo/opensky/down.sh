#!/bin/sh

cd $(dirname $0)/../..

(cd connect; docker compose stop)
(cd dashboards; docker compose stop)
(cd druid; docker compose stop)
(cd ksqlDB; docker compose stop)
(cd kafka; docker compose stop)
