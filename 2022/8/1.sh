#!/usr/local/bin/bash

declare -a grid
row=0

while read -r trees
do
  grid["$row"]="$trees"
  row=$((row+1))
done < input

visible=0

for y in "${!grid[@]}"
do
  row=${grid[$y]}
  if [[ "$y" == "0" ]]
  then
    #Top row is always visible
    length=${#row}
    visible=$((visible + length))
    continue
  elif [[ "$((y + 1))" == "${#grid[@]}" ]]
  then
    #Bottom row is always visible
    length=${#row}
    visible=$((visible + length))
    continue
  fi
  for (( x=0; x<${#row}; x++ ))
  do
    if [[ "$x" == 0 ]]
    then
      #Left column always visible
      visible=$((visible + 1))
    elif [[ "$((x + 1))" == "${#row}" ]]
    then
      #Right column always visible
      visible=$((visible + 1))
    else
      tree="${row:$x:1}"

      #Check left
      for (( row_x=0; row_x<x; row_x++ ))
      do
        tree_visible=1
        if [[ "${row:$row_x:1}" -ge "${tree}" ]]
        then
          tree_visible=0
          break
        fi
      done
      if [[ "$tree_visible" == 1 ]]
      then
        #Tree visible from left. Stop checking others
        visible=$((visible + 1))
        continue
      fi

      #Check right
      for (( row_x=$((x + 1)); row_x<${#row}; row_x++ ))
      do
        tree_visible=1
        if [[ "${row:$row_x:1}" -ge "${tree}" ]]
        then
          tree_visible=0
          break
        fi
      done
      if [[ "$tree_visible" == 1 ]]
      then
        #Tree visible from right. Stop checking others
        visible=$((visible + 1))
        continue
      fi

      #get column
      col=""
      for rows in "${!grid[@]}"
      do
        col="${col}${grid[$rows]:$x:1}"
      done

      #Check above
      for (( row_y=0; row_y<y; row_y++ ))
      do
        tree_visible=1
        if [[ "${col:$row_y:1}" -ge "${tree}" ]]
        then
          tree_visible=0
          break
        fi
      done
      if [[ "$tree_visible" == 1 ]]
      then
        #Tree visible from above. Stop checking others
        visible=$((visible + 1))
        continue
      fi

      #Check below
      for (( row_y=$((y + 1)); row_y<${#col}; row_y++ ))
      do
        tree_visible=1
        if [[ "${col:$row_y:1}" -ge "${tree}" ]]
        then
          tree_visible=0
          break
        fi
      done
      if [[ "$tree_visible" == 1 ]]
      then
        #Tree visible from below. Stop checking others
        visible=$((visible + 1))
        continue
      fi
    fi
  done
done

echo "Visible: $visible"
