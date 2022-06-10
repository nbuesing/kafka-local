#!/bin/bash


curl -s https://www.cs.cmu.edu/Groups/AI/areas/nlp/corpora/names/female.txt  |  awk 'BEGIN {srand()} !/^$/ { if (rand() <= .1) print $0}' | wc -l


#IFS=$'\n' curl -s https://www.cs.cmu.edu/Groups/AI/areas/nlp/corpora/names/male.txt | read -d '' -r -a lines


#declare -a first_names=()

while read -r LINE; do
  first_names+=($LINE)
#  echo ${first_names[@]}
done < /etc/passwd
#done < $(curl -s https://www.cs.cmu.edu/Groups/AI/areas/nlp/corpora/names/male.txt)

echo ${first_names[@]}

exit


#IFS=$'\n' read -d '' -r -a first_names < $(curl -s https://www.cs.cmu.edu/Groups/AI/areas/nlp/corpora/names/male.txt)
#curl -s https://www.cs.cmu.edu/Groups/AI/areas/nlp/corpora/names/male.txt | IFS=$'\n' read -d '' -r -a first_names

#IFS=$'\n' read -d '' -r -a lines < /etc/passwd
#
#echo "x"
##declare -a first_names=(
##  "kafka" 
##  "broker" 
##  "streams" 
##  "client"
##)
#declare -i first_names_length=${#first_names[*]}
#
#echo $first_names_length
#echo ${first_names[2]}
#
#exit
# 
#DICT=/usr/share/dict/words
#DICT_SIZE=`cat $DICT | wc -l` 
#
#X=0
# 
#while [ "$X" -lt "$1" ]; do
#
#  random_number=`od -N3 -An -i /dev/urandom | awk -v f=0 -v r="$DICT_SIZE" '{printf "%i\n", f + r * $1 / 16777216}' | head -1` 
#
#  echo $random_number
#
#  sed "${random_number}q;d" $DICT 
#
#let "X = X + 1" 
#
#done
