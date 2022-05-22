#!/bin/sh

if ! [ -x "$(command -v aws)" ]; then
    echo ""
    echo "aws is not found, please install and make it available on your path."
    echo ""
    exit
fi



DIR=$(dirname $0)

cd $DIR

BIN=$DIR/../../bin

DRUID=$BIN/druid
KSQL=$BIN/ksql-shell


alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

kt --create --replication-factor 3 --partitions 4 --topic orders
kt --create --replication-factor 3 --partitions 4 --topic skus


AWS_ACCESS_KEY_ID=admin
AWS_SECRET_ACCESS_KEY=miniominio
AWS_DEFAULT_REGION=local

aws --endpoint-url=http://localhost:9000 s3api create-bucket --bucket order
aws --endpoint-url=http://localhost:9000 s3api create-bucket --bucket sku


#  minio-create-buckets:
#    image: minio/mc:latest
#    depends_on:
#        - minio
#    entrypoint: >
#        /bin/sh -c "
#        /usr/bin/mc config host add minio http://minio:9000 admin miniominio --api s3v4;
#        while ! /usr/bin/mc mb minio/public ; do echo 'waiting for minio'; sleep 1; done;
#        /usr/bin/mc policy set download minio/public;
#        exit 0;
#        "
