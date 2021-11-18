#!/bin/sh

DATA=$1
shift

URL=http://localhost:38082
#URL=http://localhost:38081

CONTENT_TYPE_HDR='Content-Type:application/json'

curl -X POST -H $CONTENT_TYPE_HDR -d @$DATA $URL/druid/v2/sql/

