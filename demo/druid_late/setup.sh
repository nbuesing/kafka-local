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

MC="docker run -it --rm --network kafka-local --volume $(pwd)/mc-config.json:/root/.mc/config.json minio/mc:latest"

$MC mb minio/sku
$MC mb minio/order
$MC admin user svcacct add minio admin --access-key druid --secret-key druid_secret

