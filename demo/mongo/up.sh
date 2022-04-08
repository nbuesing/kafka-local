#!/bin/sh

cd $(dirname $0)/../..

./network.sh

(cd kafka; docker compose up -d)
(cd connect; docker compose up -d)
(cd mysql; docker compose up -d)
(cd mongo; docker compose up -d)
(cd ksqlDB; docker compose up -d)

(cd monitoring; docker compose up -d )

# takes the longest, but want to let others start while it is starting, so don't wait until evertyhing else has been started.
(cd connect; docker compose up -d --wait)
