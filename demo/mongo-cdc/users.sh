#!/bin/bash

cd $(dirname $0)

set -e

NAMES_FILE=./tmp/names.txt
RANDOM_NAMES_FILE=./tmp/random_names.txt
INPUT_FILE=./tmp/input.txt

function cleanup {
  rm -f ${NAMES_FILE}
  rm -f ${RANDOM_NAMES_FILE}
  rm -f ${INPUT_FILE}
}

cleanup

touch ${NAMES_FILE}
curl -s https://www.cs.cmu.edu/Groups/AI/areas/nlp/corpora/names/female.txt | egrep -v "^#|^$" | awk 'BEGIN {srand()} !/^$/ { if (rand() <= .25) print $0}' >> ${NAMES_FILE}
curl -s https://www.cs.cmu.edu/Groups/AI/areas/nlp/corpora/names/male.txt | egrep -v "^#|^$" | awk 'BEGIN {srand()} !/^$/ { if (rand() <= .25) print $0}'  >> ${NAMES_FILE}

cat ${NAMES_FILE} | tr '[:upper:]' '[:lower:]' | sort | uniq | sort -R | head -1000 > ${RANDOM_NAMES_FILE}

touch ${INPUT_FILE}
declare -i i=0
while IFS=$'\n' read -r line; do
  echo "$i|{\"user_id\" : \"${i}\", \"user_name\" : \"${line}\"}" >> ${INPUT_FILE}
  i=$i+1
done < ${RANDOM_NAMES_FILE}

cat ${INPUT_FILE} | kafka-console-producer --bootstrap-server localhost:19092 --property parse.key=true --property key.separator=\| --topic users 

cleanup
