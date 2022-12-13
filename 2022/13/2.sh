#!/usr/local/bin/bash

correct=0

function sortiguess()
{
  qleft=$1
  qright=$2

  if [[ $1 -lt $2 ]]
  then
    pivot=${pairs[$1]}

    while [[ $qleft -lt $qright ]]
    do
      correct=0
      #echo "Checking if ${pairs[$qleft]} <= $pivot && $qleft < $2"
      if [[ "${pairs[$qleft]}" == "$pivot" ]]
      then
        correct=1
      else
        compare_lists "${pairs[$qleft]}" "$pivot"
      fi
      if [[ "$correct" == 2 ]]
      then
        correct=0
      fi
      while [[ "$correct" == 1 ]] && [[ $qleft -lt $2 ]]
      do
        qleft=$(( qleft + 1 ))
        correct=0
        #echo "Checking if ${pairs[$qleft]} <= $pivot && $qleft < $2"
        if [[ "${pairs[$qleft]}" == "$pivot" ]]
        then
          correct=1
        else
          compare_lists "${pairs[$qleft]}" "$pivot"
        fi
        if [[ "$correct" == 2 ]]
        then
          correct=0
        fi
      done

      correct=0
      #echo "Checking if ${pairs[$qright]} > $pivot"
      if [[ "${pairs[$qright]}" == "$pivot" ]]
      then
        correct=0
      else
        compare_lists "${pairs[$qright]}" "$pivot"
      fi
      if [[ "$correct" == 2 ]]
      then
        correct=0
      fi
      while [[ "$correct" == 0 ]]
      do
        qright=$(( qright - 1 ))
        correct=0
        #echo "Checking if ${pairs[$qright]} > $pivot"
        if [[ "${pairs[$qright]}" == "$pivot" ]]
        then
          correct=1
        else
          compare_lists "${pairs[$qright]}" "$pivot"
          if [[ "$correct" == 2 ]]
          then
            correct=0
          fi
        fi
      done

      if [[ $qleft -lt $qright ]]
      then
        temp=${pairs[$qleft]}
        pairs[$qleft]=${pairs[$qright]}
        pairs[$qright]=$temp
      fi
    done

    temp=${pairs[$qright]}
    pairs[$qright]=${pairs[$1]}
    pairs[$1]=$temp
    temp=$qright

    sortiguess "$1" $((qright-1)) pairs
    sortiguess $((temp+1)) "$2" pairs
  fi
}

function compare_lists {
  local test_num=0
  cache_key="${1}-${2}"
  if [[ ${check_cache[$cache_key]} != "" ]]
  then
    correct=${check_cache[$cache_key]}
    return
  fi
  for left in $(echo "$1" | jq -c '.[]')
  do
    if [[ "$correct" -gt "0" ]]
    then
      return
    fi
    right=$(echo "$2" | jq -c .["$test_num"])
    if [[ "$right" == "null" ]]
    then
      continue
    fi
    if [[ "$left" =~ ^\[ ]] || [[ "$right" =~ ^\[ ]]
    then
      if [[ "$right" =~ ^[0-9]+$ ]]
      then
        right="[$right]"
      elif [[ "$left" =~ ^[0-9]+$ ]]
      then
        left="[$left]"
      fi
      compare_lists "$left" "$right"
    elif [[ "$left" -lt "$right" ]]
    then
      correct=1
      check_cache[$cache_key]=1
      break
    elif [[ "$left" -gt "$right" ]]
    then
      correct=2
      check_cache[$cache_key]=2
      return
    fi
    test_num=$((test_num + 1))
  done
  if [[ "$correct" == "0" ]]
  then
      left=$(echo "$1" | jq -c .["$test_num"])
      right=$(echo "$2" | jq -c .["$test_num"])
      if [[ "$left" == "null" && "$right" == "null" ]]
      then
        #noop
        correct=0
        check_cache[$cache_key]=0
      elif [[ "$left" == "null" ]]
      then
        correct=1
        check_cache[$cache_key]=1
      elif [[ "$right" == "null" ]]
      then
        correct=2
        check_cache[$cache_key]=2
      fi
  fi
}

declare -a pairs
declare -A check_cache
pair_num=0

while read -r pair
do
  if [[ "$pair" != "" ]]
  then
    pairs["$pair_num"]="$pair"
    pair_num=$(( pair_num + 1 ))
  fi
done < "$1"

sortiguess 0 $(( "${#pairs[@]}" - 1 )) pairs

answer=0

for((i=0;i<${#pairs[@]};i++))
do
  if [[ "${pairs[$i]}" == "[[2]]" ]]
  then
    answer=$((i + 1))
  elif [[ "${pairs[$i]}" == "[[6]]" ]]
  then
    answer=$((answer * (i + 1)))
  fi
done

echo "$answer"
