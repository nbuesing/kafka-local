#!/bin/sh

DRUID=$(dirname $0)/../../bin/druid

$DRUID load ./druid/orders.json
$DRUID load ./druid/skus.json
