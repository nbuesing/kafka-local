#!/bin/sh

DRUID=$(dirname $0)/../../bin/druid

$DRUID load ./druid/compact/order_user_reward.json
$DRUID load ./druid/compact/order_user_reward_rekeyed.json
