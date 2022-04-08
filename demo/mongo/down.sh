#!/bin/sh

cd $(dirname $0)/../..

# in case they were started
(cd dashboards; docker compose down -v)
(cd monitoring; docker compose down -v)

(cd ksqlDB; docker compose down -v)
(cd connect; docker compose down -v)
(cd kafka; docker compose down -v)

(cd mysql; docker compose down -v)
