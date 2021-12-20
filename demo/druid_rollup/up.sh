#!/bin/sh

cd $(dirname $0)/../..

./network.sh

(cd kafka; docker compose up -d $(docker-compose config --services | grep -v schema-registry))
(cd connect; docker compose up -d connect-1)
(cd druid; docker compose up -d)
sleep 2
(cd ksqlDB; docker compose up -d)

#kt --topic _confluent-ksql-default__command_topic --describe
# --partitions 1 --replication-factor 1 
# min.insync.replicas=1,cleanup.policy=delete,retention.ms=-1,unclean.leader.election.enable=false

