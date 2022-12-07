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

  if [[ $min_second -ge $min_first ]] && [[ $min_second -le $max_first ]]
  then
    total=$((total + 1))
  elif [[ $min_first -ge $min_second ]] && [[ $min_first -le $max_second ]]
  then
    total=$((total + 1))
  fi

done < input

echo "$total"
