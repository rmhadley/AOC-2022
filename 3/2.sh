#!/bin/bash

total=0
elves=0

while read -r rucksack
do
  elves=$((elves + 1))
  echo "$rucksack" > "rucksack${elves}"
  if [[ "$elves" -eq 3 ]]
  then
    elves=0
    rucksack1=$(cat rucksack1)
    rucksack2=$(cat rucksack2)
    rucksack3=$(cat rucksack3)
    for (( i=0; i<${#rucksack1}; i++ ))
    do
      if echo "$rucksack2" | grep -q "${rucksack1:$i:1}"
      then
        if echo "$rucksack3" | grep -q "${rucksack1:$i:1}"
        then
          LETTER=$(echo "${rucksack1:$i:1}" | tr '[:upper:]' '[:lower:]')
          ORD=$(printf '%d' "'$LETTER")
          NUM=$((ORD - 96))
          if [[ "$LETTER" != "${rucksack1:$i:1}" ]]
          then
            NUM=$((NUM + 26))
          fi
          total=$((total + NUM))
          break;
        fi
      fi
    done
  fi
done < input

rm -f rucksack*
echo "$total"
