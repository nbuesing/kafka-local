#!/bin/sh

cd $(dirname $0)

touch ../tmp/connect-distributed.properties

if [ ! -d "../../connect/jars/streamthoughts-kafka-connect-file-pulse" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt  streamthoughts/kafka-connect-file-pulse:latest
fi

rm -f ../tmp/connect-distributed.properties

