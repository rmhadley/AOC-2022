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
  for letter in $(head -n"$num" "stacks_$from")
  do
    echo "$letter" > "stacks_${to}_new"
    cat "stacks_${to}" >> "stacks_${to}_new"
    mv "stacks_${to}_new" "stacks_${to}"
    sed 1,1d "stacks_${from}" > "stacks_${from}_tmp"
    mv "stacks_${from}_tmp" "stacks_${from}"
  done
done < input

for file in stacks_*
do
  ANSWER="$ANSWER$(head -n1 "$file")"
done

rm -f stacks_*

echo "$ANSWER"
