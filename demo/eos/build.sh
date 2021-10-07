#!/bin/sh

cd $(dirname $0)

mkdir -p tmp
touch tmp/connect-distributed.properties

confluent-hub install --worker-configs ./tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt confluentinc/kafka-connect-datagen:0.5.0

