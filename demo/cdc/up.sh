#!/bin/sh

cd $(dirname $0)/../..

./network.sh

(cd mysql; docker compose up -d)
(cd kafka; docker compose up -d)
(cd connect; docker compose up -d)
(cd monitoring; docker compose up -d )
#(cd monitoring; docker compose up -d prometheus grafana)
