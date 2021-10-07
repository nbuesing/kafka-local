#!/bin/sh

DATA=$1
shift

#URL=http://localhost:38888
URL=http://localhost:38081

CONTENT_TYPE_HDR='Content-Type:application/json'

curl -X POST -H $CONTENT_TYPE_HDR -d @$DATA $URL/druid/indexer/v1/supervisor


#curl -X POST http://localhost:18081/druid/indexer/v1/supervisor/_metrics-kafka-streams/shutdown

#TASK=task
#curl -X POST -H $CONTENT_TYPE_HDR -d @$DATA $URL/druid/indexer/v1/$TASK

#http://localhost:18888/unified-console.html#query
