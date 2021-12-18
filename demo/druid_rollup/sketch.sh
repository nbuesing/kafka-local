#!/bin/sh

DRUID=$(dirname $0)/../../bin/druid


COMMAND=load

$DRUID ${COMMAND} ./druid/order_sketch_none.json
$DRUID ${COMMAND} ./druid/order_sketch_theta_16.json
$DRUID ${COMMAND} ./druid/order_sketch_theta_16384.json
$DRUID ${COMMAND} ./druid/order_sketch_hll_4_4.json
$DRUID ${COMMAND} ./druid/order_sketch_hll_4_12.json
$DRUID ${COMMAND} ./druid/order_sketch_hll_8_12.json
