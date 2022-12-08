#!/usr/local/bin/bash

declare -a grid
row=0

while read -r trees
do
  grid["$row"]="$trees"
  row=$((row+1))
done < input

best_view=0

for y in "${!grid[@]}"
do
  row=${grid[$y]}
  if [[ "$y" == "0" ]]
  then
    #Top row is * 0 so skip these guys
    continue
  elif [[ "$((y + 1))" == "${#grid[@]}" ]]
  then
    #Bottom row is * 0 so skip these guys
    continue
  fi
  for (( x=0; x<${#row}; x++ ))
  do
    if [[ "$x" == 0 ]]
    then
      #Left column is * 0 so skip these guys
      continue
    elif [[ "$((x + 1))" == "${#row}" ]]
    then
      #Right column is * 0 so skip these guys
      continue
    else
      tree="${row:$x:1}"

      #Check to the left
      left_score=0
      for (( row_x=$((x - 1)); row_x>=0; row_x-- ))
      do
        left_score=$((left_score + 1))
        if [[ "${row:$row_x:1}" -ge "${tree}" ]]
        then
          break
        fi
      done

      #Check right
      right_score=0
      for (( row_x=$((x + 1)); row_x<${#row}; row_x++ ))
      do
        right_score=$((right_score + 1))
        if [[ "${row:$row_x:1}" -ge "${tree}" ]]
        then
          break
        fi
      done

      #get column
      col=""
      for rows in "${!grid[@]}"
      do
        col="${col}${grid[$rows]:$x:1}"
      done

      #Check above
      above_score=0
      for (( row_y=$((y - 1)); row_y>=0; row_y-- ))
      do
        above_score=$((above_score + 1))
        if [[ "${col:$row_y:1}" -ge "${tree}" ]]
        then
          break
        fi
      done

      #Check below
      below_score=0
      for (( row_y=$((y + 1)); row_y<${#col}; row_y++ ))
      do
        below_score=$((below_score + 1))
        if [[ "${col:$row_y:1}" -ge "${tree}" ]]
        then
          break
        fi
      done

      total_score=$((left_score * right_score * above_score * below_score))
      if [[ "$total_score" -gt "$best_view" ]]
      then
        best_view="$total_score"
      fi
    fi
  done
done

echo "$best_view"
