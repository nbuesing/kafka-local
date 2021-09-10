#!/bin/sh

cd $(dirname $0)/../..

./network.sh

(cd kafka; docker compose up -d zookeeper broker-1 broker-2 broker-3 broker-4)

(cd connect; docker compose up -d)

(cd storage; docker compose up -d)

