#!/usr/local/bin/bash

answer=0

function compare_lists {
  local test_num=0
  for left in $(echo "$1" | jq -c '.[]')
  do
    if [[ "$answered" -gt "0" ]]
    then
      return
    fi
    right=$(echo "$2" | jq -c .["$test_num"])
    if [[ "$right" == "null" ]]
    then
      continue
    fi
    echo "  - Compare $left to $right"
    if [[ "$left" =~ ^\[ ]] || [[ "$right" =~ ^\[ ]]
    then
      if [[ "$right" =~ ^[0-9]+$ ]]
      then
        echo "    - Mixed types; convert right to [$right] and retry comparison"
        right="[$right]"
      elif [[ "$left" =~ ^[0-9]+$ ]]
      then
        echo "    - Mixed types; convert left to [$left] and retry comparison"
        left="[$left]"
      fi
      compare_lists "$left" "$right"
    elif [[ "$left" -lt "$right" ]]
    then
      echo "    - Left side is smaller, so inputs are in the right order"
      answered=1
      break
    elif [[ "$left" -gt "$right" ]]
    then
      echo "    - Right side is smaller, so inputs are not in the right order"
      answered=2
      return
    fi
    test_num=$((test_num + 1))
  done
  if [[ "$answered" == "0" ]]
  then
      left=$(echo "$1" | jq -c .["$test_num"])
      right=$(echo "$2" | jq -c .["$test_num"])
      echo "$left $right"
      if [[ "$left" == "null" && "$right" == "null" ]]
      then
        #noop
        answered=0
      elif [[ "$left" == "null" ]]
      then
        echo "  - Left side ran out of items, so inputs are in the right order"
        answered=1
      elif [[ "$right" == "null" ]]
      then
        echo "    - Right side is smaller, so inputs are not in the right order"
        answered=2
      else
        echo "wtf"
      fi
  fi
}

declare -a pairs
pair_num=0

while read -r pair
do
  if [[ "$pair" != "" ]]
  then
    pairs["$pair_num"]="$pair"
    pair_num=$(( pair_num + 1 ))
  fi
done < "$1"

for (( num=0; num<"${#pairs[@]}"; num=num+2 ))
do
  echo "== Pair $(( num / 2 + 1 )) =="
  packet1="${pairs[$num]}"
  packet2="${pairs[$(( num + 1 ))]}"
  echo "- Compare $packet1 vs $packet2"
  answered=0
  compare_lists "$packet1" "$packet2"
  if [[ "$answered" == "1" ]]
  then
    answer=$(( answer + ( num / 2 + 1 ) ))
  fi
done

echo
echo "Answer: $answer"
