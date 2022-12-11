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

for round in {1..20}
do
  echo "Round: $round"
  for (( monkey=0; monkey<=monkey_num; monkey++ ))
  do
    echo "  Monkey $monkey:"
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
      #cmd="expr $item \\${operations[$monkey]}"
      #cmd="${cmd/old/$item}"
      #new=$(eval "$cmd")
      echo "    Monkey inspects an item with a worry level of $item."
      echo "      Worry level is ${operations[$monkey]} to $new."
      new=$(( new / 3 ))
      echo "      Monkey gets bored with item. Worry level is divided by 3 to $new."
      if (( new % tests[monkey] ))
      then
        echo "      Current worry level is not divisible by ${tests[$monkey]}."
        target_monkey="${falses[$monkey]}"
      else
        echo "      Current worry level is divisible by ${tests[$monkey]}."
        target_monkey="${trues[$monkey]}"
      fi
      echo "      Item with worry level $new is thrown to monkey $target_monkey."
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
