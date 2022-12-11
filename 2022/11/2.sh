#!/usr/local/bin/bash

monkey_num=0
declare -a items
declare -a operations
declare -a tests
declare -a trues
declare -a falses
declare -a inspections

while read -r line
do
  if [[ "$line" = Starting* ]]
  then
    items["$monkey_num"]="${line/*:/}"
  elif [[ "$line" = Operation* ]]
  then
    operations["$monkey_num"]="${line/*old /}"
  elif [[ "$line" = Test* ]]
  then
    tests["$monkey_num"]="${line/*by /}"
  elif [[ "$line" = *true:* ]]
  then
    trues["$monkey_num"]="${line/*monkey /}"
  elif [[ "$line" = *false:* ]]
  then
    falses["$monkey_num"]="${line/*monkey /}"
  elif [[ "$line" = Monkey* ]]
  then
    monkey_num="${line:7:1}"
  fi
done < input

for round in {1..10000}
do
  echo "Round: $round"
  for (( monkey=0; monkey<=monkey_num; monkey++ ))
  do
    #echo "  Monkey $monkey:"
    for item in ${items[$monkey]//,/}
    do
      inspections["$monkey"]=$(( inspections[monkey] + 1 ))
      num=$((${operations[$monkey]/* /}))
      if [[ "$num" == 0 ]]
      then
        num="$item"
      fi
      if [[ "${operations[$monkey]:0:1}" == "*" ]]
      then
        new=$(( item * num ))
      else
        new=$(( item + num ))
      fi

      #9699690 is the lcm of all the tests from all the monkeys
      #I didn't know how to calculate it in bash so I cheated
      #and I calulated it with python and hard coded it here
      new=$(( new % 9699690 ))
      if (( new % tests[monkey] ))
      then
        target_monkey="${falses[$monkey]}"
      else
        target_monkey="${trues[$monkey]}"
      fi
      items["$target_monkey"]="${items[$target_monkey]}, $new"
    done
    items["$monkey"]=""
  done
  echo
  for (( monkey=0; monkey<=monkey_num; monkey++ ))
  do
    echo "Monkey $monkey: ${items[$monkey]}"
  done
  echo
done

echo
answer=1
for num in $(for (( monkey=0; monkey<=monkey_num; monkey++ ))
do
  echo "${inspections[$monkey]}"
done | sort -n | tail -n2)
do
  answer=$(( answer * num ))
done

echo "Answer: $answer"
