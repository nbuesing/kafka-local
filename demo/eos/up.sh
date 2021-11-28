#!/bin/sh

cd $(dirname $0)/../..

./network.sh

# if broker-4 is commented out, do not try to start it -- script technically will work if any broker is commented out
ACTIVE_BROKERS=$(sed -n -E -e "s/^  (broker-[0-9]):/\1 /p" ./kafka/docker-compose.yml | tr -d '\n')
(cd kafka; docker compose up -d zookeeper ${ACTIVE_BROKERS})

#(cd kafka-lb; docker compose up -d)

(cd connect; docker compose up -d)

(cd druid; docker compose up -d)

(cd ksqlDB; docker compose up -d)

(cd monitoring; docker compose up -d prometheus grafana)
