#!/bin/sh

cd "$(dirname $0)" || exit

touch ../tmp/connect-distributed.properties

if [ ! -d "../../connect/jars/confluentinc-kafka-connect-s3" ]; then
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ../../connect/jars --no-prompt confluentinc/kafka-connect-s3:10.0.7
fi

rm -f ../tmp/connect-distributed.properties

# ensure that the aws secrets in connect cluster are set to minio's credentials.
#
cat > ../../connect/secrets/aws.properties <<EOF
AWS_ACCESS_KEY_ID=admin
AWS_SECRET_ACCESS_KEY=miniominio
EOF

