#!/bin/bash

total=0

while read -r pairs
do
  first="${pairs/,*/}"
  second="${pairs/*,/}"
  min_first="${first/-*/}"
  max_first="${first/*-/}"
  min_second="${second/-*/}"
  max_second="${second/*-/}"

  if [[ $min_first -ge $min_second ]] && [[ $max_first -le $max_second ]]
  then
    total=$((total + 1))
  elif [[ $min_second -ge $min_first ]] && [[ $max_second -le $max_first ]]
  then
      total=$((total + 1))
  fi
done < input

echo "$total"
