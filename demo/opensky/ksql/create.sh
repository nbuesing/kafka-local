#!/bin/sh

FILE=$1
shift

ksql --config-file config.properties --file=$FILE


