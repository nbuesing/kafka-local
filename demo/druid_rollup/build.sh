#!/bin/sh

cd "$(dirname $0)" || exit

touch ../tmp/connect-distributed.properties

if [ ! -d "../../connect/jars/confluentinc-kafka-connect-datagen" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt confluentinc/kafka-connect-datagen:0.5.0
fi

rm -f ../tmp/connect-distributed.properties

cp -r data/* ../../connect/data
