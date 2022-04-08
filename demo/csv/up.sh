#!/bin/sh

cd $(dirname $0)/../..

./network.sh

(cd kafka; docker compose up -d)
(cd connect; docker compose up -d --wait)
