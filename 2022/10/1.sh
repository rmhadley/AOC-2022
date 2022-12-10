#!/usr/local/bin/bash

cycle=0
x=1
delay=0
addx=0
declare -a cycles

while read -r instruction
do
  cycle=$((cycle + 1))
  cycles["$cycle"]="$x"
  if [[ "$instruction" != "noop" ]]
  then
    delay=1
    addx="${instruction/* /}"
    for (( waiting=0; waiting<delay; waiting++ ))
    do
      cycle=$((cycle + 1))
      cycles["$cycle"]="$x"
    done
    delay=0
    x=$((x + addx))
  fi
done < input
cycle=$((cycle + 1))
cycles["$cycle"]="$x"

echo "$((20 * cycles[20] + 60 * cycles[60] + 100 * cycles[100] + 140 * cycles[140] + 180 * cycles[180] + 220 * cycles[220]))"
