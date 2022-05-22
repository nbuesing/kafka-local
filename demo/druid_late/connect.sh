#!/bin/sh

CONNECT=$(dirname $0)/../../bin/connect

$CONNECT recreate ./connect/s3.json
$CONNECT status ./connect/s3.json
