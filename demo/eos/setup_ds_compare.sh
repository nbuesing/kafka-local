#!/bin/sh

DRUID=$(dirname $0)/../../bin/druid

$DRUID load ./druid/order_store_zipcode.json
$DRUID load ./druid/order_user_reward.json
$DRUID load ./druid/order_user_reward_sketch.json
$DRUID load ./druid/order_user_reward_store_zipcode.json
$DRUID load ./druid/order_metric_showcase.json
