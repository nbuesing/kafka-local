#!/bin/bash

set -e

rm -f ./names.txt
touch ./names.txt
curl -s https://www.cs.cmu.edu/Groups/AI/areas/nlp/corpora/names/female.txt | egrep -v "^#|^$" | awk 'BEGIN {srand()} !/^$/ { if (rand() <= .25) print $0}' >> ./names.txt
curl -s https://www.cs.cmu.edu/Groups/AI/areas/nlp/corpora/names/male.txt | egrep -v "^#|^$" | awk 'BEGIN {srand()} !/^$/ { if (rand() <= .25) print $0}'  >> ./names.txt

cat ./names.txt | sort -R | head -1000 > ./names2.txt

declare -a names=()
while IFS= read -r line; do
 names+=("$line") 
done < ./names.txt
size=${#names[@]}

#index=$(($RANDOM % $size))
#echo ${names[$index]}


#echo ${myArray[@]}

tmpfile=$(mktemp /tmp/abc-script.XXXXXX)
trap "rm -f ${tmpfile}" ERR

#touch ${tmpfile}
#for i in $(seq 1000); do
#  echo "$i|{\"user_id\" : \"${i}\", \"user_name\" : \"USER_NAME_${i}_${names[$(($RANDOM % $size))]}\"}" >> ${tmpfile}
#done

touch ${tmpfile}
declare -i i=0
while IFS=$'\n' read -r line; do
  echo "$i|{\"user_id\" : \"${i}\", \"user_name\" : \"${line}\"}" >> ${tmpfile}
  i=$i+1
done < ./names2.txt

cat ${tmpfile} 

#cat ${tmpfile} | kafka-console-producer --bootstrap-server localhost:19092 --property parse.key=true --property key.separator=\| --topic X

rm -f ${tmpfile}
