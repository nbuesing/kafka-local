#!/bin/sh

cd $(dirname $0)/../..

./network.sh

(cd kafka; docker compose up -d)

#(cd kafka-lb; docker compose up -d)

(cd connect; docker compose up -d)

(cd ksqlDB; docker compose up -d)

(cd druid; docker compose up -d)

