#!/bin/bash

cd $(dirname $0)

declare -a NAMES=("foo" "bar" "x" "a" "c" "c")
declare -i NAMES_SIZE=${#NAMES[@]}

declare -a ADJECTIVES=(
 "Awesome"
 "Fascinating"
 "Incredible"
 "Marvelous"
 "Prodigious"
 "Shocking"
 "Stunning"
 "Surprising"
 "Unbelievable"
 "Cheap"
 "Affordable"
 "Discounted"
 "xAwesome"
 "xFascinating"
 "xIncredible"
 "xMarvelous"
 "xProdigious"
 "xShocking"
 "xStunning"
 "xSurprising"
 "xUnbelievable"
 "xCheap"
 "xAffordable"
 "xDiscounted"
)

declare -a ITEMS=(
  "CD Players"
  "VCRs"
  "Camcorders"
  "Computer Chips"
  "Computers"
  "Electronic Components"
  "Integrated Circuitry"
  "Radios"
  "Stereos"
  "Televisions"
  "Transistors"
  "Video Cameras"
  "Monitors"
  "Printers"
  "Hand Held Devices"  
  "A"
  "B"
  "C"
)


for i in $(seq 0 999); do
  item=$(($RANDOM % ${#ITEMS[@]}))
  adjective=$(($RANDOM % ${#ADJECTIVES[@]}))
  echo "$i|{\"store_id\" : \"${i}\", \"store_name\" : \"${ADJECTIVES[$adjective]} ${ITEMS[$item]}\"}"
done
