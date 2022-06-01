#!/bin/sh

cd $(dirname $0)/../..

./network.sh
(cd kafka; docker compose up -d)
(cd connect; docker compose up -d)
(cd cassandra; docker compose up -d)
(cd mysql; docker compose up -d)
(cd ksqlDB; docker compose up -d)
(cd connect; docker compose up -d --wait)
(cd cassandra; docker compose up -d --wait)
