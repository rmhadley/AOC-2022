#!/usr/local/bin/bash

cycle=0
x=2
delay=0
addx=0
output=""

while read -r instruction
do
  cycle=$((cycle + 1))
  check_cycle="$cycle"
  if [[ "$check_cycle" -gt 200 ]]
  then
    check_cycle=$((check_cycle - 200))
  elif [[ "$check_cycle" -gt 160 ]]
  then
    check_cycle=$((check_cycle - 160))
  elif [[ "$check_cycle" -gt 120 ]]
  then
    check_cycle=$((check_cycle - 120))
  elif [[ "$check_cycle" -gt 80 ]]
  then
    check_cycle=$((check_cycle - 80))
  elif [[ "$check_cycle" -gt 40 ]]
  then
    check_cycle=$((check_cycle - 40))
  fi
  if 
    [[ "$check_cycle" == $((x - 1)) ]] || [[ "$check_cycle" == "$x" ]] || [[ "$check_cycle" == $((x + 1)) ]]
  then
    output="$output#"
  else
    output="$output."
  fi
  if [[ "$instruction" != "noop" ]]
  then
    delay=1
    addx="${instruction/* /}"
    for (( waiting=0; waiting<delay; waiting++ ))
    do
      cycle=$((cycle + 1))
      check_cycle="$cycle"
      if [[ "$check_cycle" -gt 200 ]]
      then
        check_cycle=$((check_cycle - 200))
      elif [[ "$check_cycle" -gt 160 ]]
      then
        check_cycle=$((check_cycle - 160))
      elif [[ "$check_cycle" -gt 120 ]]
      then
        check_cycle=$((check_cycle - 120))
      elif [[ "$check_cycle" -gt 80 ]]
      then
        check_cycle=$((check_cycle - 80))
      elif [[ "$check_cycle" -gt 40 ]]
      then
        check_cycle=$((check_cycle - 40))
      fi
      if
        [[ "$check_cycle" == $((x - 1)) ]] || [[ "$check_cycle" == "$x" ]] || [[ "$check_cycle" == $((x + 1)) ]]
      then
        output="$output#"
      else
        output="$output."
      fi
    done
    delay=0
    x=$((x + addx))
  fi
done < input

echo "${output:0:40}"
echo "${output:40:40}"
echo "${output:80:40}"
echo "${output:120:40}"
echo "${output:160:40}"
echo "${output:200:40}"
