#!/bin/sh

DRUID=$(dirname $0)/../../bin/druid

$DRUID load ./druid/compact/order_non_rolled.json
$DRUID load ./druid/compare/order_store_zipcode.json
$DRUID load ./druid/compare/order_user_reward.json
$DRUID load ./druid/compare/order_user_reward_store_zipcode.json
