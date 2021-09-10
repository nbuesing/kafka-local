#!/bin/sh

cd $(dirname $0)/../..

(cd storage; docker compose down -v)
(cd connect; docker compose down -v)
(cd kafka; docker compose down -v)
