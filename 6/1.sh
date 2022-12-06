#!/bin/bash

signal=$(cat input)
marker=""

for (( i=0; i<${#signal}; i++ ))
do
  marker="${marker}${signal:$i:1}"
  if [[ ${#marker} -eq 5 ]]
  then
    marker="${marker:1}"
  fi
  if [[ ${#marker} -eq 4 ]]
  then
    unique=$(for (( j=0; j<4; j++))
    do
      echo "${marker:$j:1}"
    done | sort | uniq | wc -l)
    if [[ "$unique" -eq 4 ]]
    then
      echo "$marker"
      echo $((i + 1))
      break
    fi
  fi
done
