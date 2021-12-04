#!/bin/sh

#
# Install jq into the staging/scripts directory to be used to format the json responses, do not download if already
# installed. Verify the checksum against expected value, and abort if not as expected.
#
if [ ! -f /opt/staging/scripts/jq-linux64 ]; then
  wget -O /opt/staging/scripts/jq-linux64 https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  echo '49db5105ebe613620c27cbd8706322e9e3c9ed733b5a4a1d4b14df9d  /opt/staging/scripts/jq-linux64' | sha3sum -c
  if [ $? -ne 0 ]; then
    echo "checksum of jq-1.6 for linux is not what was expected, aborting."
    exit
  fi
  chmod +x /opt/staging/scripts/jq-linux64
fi

if [ $# -eq 0 ]; then
  echo "usage: $0 datasource"
  exit
fi

datasource=$1
shift


alias jq=/opt/staging/scripts/jq-linux64

CLASSPATH="/opt/staging/scripts/conf:/opt/druid/lib/*"

cd /opt/staging/exports

#///opt/druid/var/druid/task/index_kafka_orders_ff239f7f6672be9_pcpaciph/work/persist/orders_2021-11-20T13:00:00.000Z_2021-11-20T14:00:00.000Z_2021-11-20T13:02:52.543Z_7/4/00000.smoosh

segments=$(find /opt/druid/var/druid/task/index_kafka_${datasource}_* -name 00000.smoosh -print )

for i in $segments; do


 dir=$(dirname $i)

 echo $i

 segment=$(echo $dir | rev | cut -d/ -f2 | rev)
 partition=$(echo $dir | rev | cut -d/ -f1 | rev)

 BASENAME=${datasource}_${segment}__${partition}

 java -classpath $CLASSPATH -Ddruid.extensions.loadList="[]" org.apache.druid.cli.Main tools dump-segment --directory "$dir" --out "${BASENAME}.metadata.tmp" --dump metadata
 jq < ${BASENAME}.metadata.tmp > ${BASENAME}.metadata
 rm -f ${BASENAME}.metadata.tmp

 java -classpath $CLASSPATH -Ddruid.extensions.loadList="[]" org.apache.druid.cli.Main tools dump-segment --directory "$dir" --out "${BASENAME}.bitmaps.tmp" --dump bitmaps --decompress-bitmaps
 jq < ${BASENAME}.bitmaps.tmp > ${BASENAME}.bitmaps
 rm -f ${BASENAME}.bitmaps.tmp

 java -classpath $CLASSPATH -Ddruid.extensions.loadList="[]" org.apache.druid.cli.Main tools dump-segment --directory "$dir" --out "${BASENAME}.rows" --dump rows --time-iso8601

done

