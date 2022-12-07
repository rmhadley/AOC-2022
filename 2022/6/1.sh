#!/bin/bash

signal=$(cat input)
marker=""

for (( i=0; i<${#signal}; i++ ))
do
  marker="${signal:$i:4}"
  unique=$(for (( j=0; j<4; j++))
  do
    echo "${marker:$j:1}"
  done | sort | uniq | wc -l)
  if [[ "$unique" -eq 4 ]]
  then
    echo "$marker"
    echo $((i + 4))
    break
  fi
done
