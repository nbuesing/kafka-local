#!/bin/sh

cd $(dirname $0)/../..

# in case they were started
(cd monitoring; docker compose down -v)
(cd ksqlDB; docker compose down -v)

(cd dashboards; docker compose down -v)
(cd druid; docker compose down -v)
(cd kafka; docker compose down -v)
