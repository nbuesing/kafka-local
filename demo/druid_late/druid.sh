#!/bin/sh

DRUID=$(dirname $0)/../../bin/druid

$DRUID load ./druid/order.json
