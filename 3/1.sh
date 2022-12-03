#!/bin/bash

total=0

while read -r rucksack
do
  compartment1="${rucksack:0:${#rucksack}/2}"
  compartment2="${rucksack:${#rucksack}/2}"
  for (( i=0; i<${#compartment1}; i++ ))
  do
    if echo "$compartment2" | grep -q "${compartment1:$i:1}"
    then
      LETTER=$(echo "${compartment1:$i:1}" | tr '[:upper:]' '[:lower:]')
      ORD=$(printf '%d' "'$LETTER")
      NUM=$((ORD - 96))
      if [[ "$LETTER" != "${compartment1:$i:1}" ]]
      then
        NUM=$((NUM + 26))
      fi
      total=$((total + NUM))
      break
    fi
  done
done < input

echo "$total"
