#!/bin/sh

cd $(dirname $0)/../..

(cd connect; docker compose down -v)
(cd kafka; docker compose down -v)
