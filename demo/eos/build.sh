#!/bin/sh

cd $(dirname $0)

touch ../tmp/connect-distributed.properties

if [ ! -d "../../connect/jars/confluentinc-kafka-connect-datagen" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt confluentinc/kafka-connect-datagen:0.5.0
fi

#if [ ! -d "../../connect/jars/streamthoughts-kafka-connect-file-pulse" ]; then
#  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt streamthoughts/kafka-connect-file-pulse:2.3.0
#fi

if [ ! -d "../../connect/jars/jcustenborder-kafka-connect-spooldir" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt jcustenborder/kafka-connect-spooldir:2.0.62
fi

rm -f ../tmp/connect-distributed.properties



cp -r data/* ../../connect/data
