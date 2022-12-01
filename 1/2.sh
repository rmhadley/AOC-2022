#!/bin/bash

total=0

for highest_three in $(./1.sh | tail -3)
do
  total=$((total + highest_three))
done
echo "$total"
