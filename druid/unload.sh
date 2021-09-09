#!/bin/sh

spec=$1
shift

URL=http://localhost:38081

curl -X POST $URL/druid/indexer/v1/supervisor/${spec}/reset
curl -X POST $URL/druid/indexer/v1/supervisor/${spec}/shutdown
