#!/bin/bash

total=0

while read -r calories
do
  if [ "$calories" != "" ]
  then
    total=$((total + calories))
  else
    echo "$total"
    total=0
  fi
done < input | sort -n
