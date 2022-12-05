#!/bin/bash

rm -f stacks_*

while read -r stacks
do
  if [[ "$stacks" = [* ]]
  then
    for (( stack=0; stack<=35; stack=stack + 4 ))
    do
      stack_num=$((stack / 4 + 1))
      if [[ "${stacks:$stack + 1:1}" == [A-Z] ]]
      then
        echo "${stacks:$stack + 1:1}" >> "stacks_$stack_num"
      fi
    done
  fi
done < starting_stacks

while read -r command
do
  num=$(echo "$command" | cut -f 2 -d " ")
  from=$(echo "$command" | cut -f 4 -d " ")
  to=$(echo "$command" | cut -f 6 -d " ")
  head -n "$num" "stacks_$from" > "stacks_tmp_$to"
  cat "stacks_$to" >> "stacks_tmp_$to"
  mv "stacks_tmp_$to" "stacks_$to"
  sed "1,${num}d" "stacks_${from}" > "stacks_${from}_tmp"
  mv "stacks_${from}_tmp" "stacks_${from}"
done < input

for file in stacks_*
do
  ANSWER="$ANSWER$(head -n1 "$file")"
done

echo "$ANSWER"

rm -f stacks_*
