#!/bin/sh

cd $(dirname $0)/../..

(cd ksqlDB; docker compose down -v)
(cd connect; docker compose down -v)
(cd kafka; docker compose down -v)

(cd mongo; docker compose down -v)
