#!/bin/bash

signal=$(cat input)
marker=""

for (( i=0; i<${#signal}; i++ ))
do
  marker="${signal:$i:14}"
  unique=$(for (( j=0; j<14; j++))
  do
    echo "${marker:$j:1}"
  done | sort | uniq | wc -l)
  if [[ "$unique" -eq 14 ]]
  then
    echo "$marker"
    echo $((i + 14))
    break
  fi
done
