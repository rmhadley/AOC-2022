#!/usr/local/bin/bash

declare -A world

min_x=9999
max_x=0
max_y=0

while read -r lines
do
  d_start=0
  for point in ${lines// ->/}
  do

    if [[ ${point/,*/} -lt $min_x ]]
    then
      min_x=${point/,*/}
    elif [[ ${point/,*/} -gt $max_x ]]
    then
      max_x=${point/,*/}
    fi

    if [[ ${point/*,/} -gt $max_y ]]
    then
      max_y=${point/*,/}
    fi

    if [[ "$d_start" != "0" ]]
    then
      start_x=${d_start/,*/}
      start_y=${d_start/*,/}
      end_x=${point/,*/}
      end_y=${point/*,/}

      for x in $(seq "$start_x" "$end_x")
      do
        for y in $(seq "$start_y" "$end_y")
        do
          world["$x,$y"]="#"
        done
      done

      d_start=$point
    else
      d_start=$point
    fi
  done
done < "$1"

function drop_sand {
  sand_x=500
  sand_y=0

  for y in $(seq "$sand_y" "$max_y" )
  do
    #check down
    check_x=$sand_x
    check_y=$(( sand_y + 1 ))
    if [[ "${world[${check_x},${check_y}]}" == "" ]]
    then
      sand_y=$check_y
      continue
    fi
    #check down left
    check_x=$(( sand_x - 1 ))
    check_y=$(( sand_y + 1 ))
    if [[ "${world[${check_x},${check_y}]}" == "" ]]
    then
      sand_x=$check_x
      sand_y=$check_y
      continue
    fi
    #check down right
    check_x=$(( sand_x + 1 ))
    check_y=$(( sand_y + 1 ))
    if [[ "${world[${check_x},${check_y}]}" == "" ]]
    then
      sand_x=$check_x
      sand_y=$check_y
      continue
    fi
    #No where to go, so we stay here
    if [[ "${sand_x},${sand_y}" == "500,0" ]]
    then
      end=1
    fi
    break
  done
  world["${sand_x},${sand_y}"]="O"
}

end=0
sand=0

progress=0
while [[ $end = 0 ]]
do
  drop_sand
  sand=$(( sand + 1 ))
  progress=$(( progress + 1 ))
  if [[ "$progress" == 500 ]]
  then
    progress=0
    #draw the world
    for y in $(seq 0 $(( max_y + 2 )))
    do
      line=""
      for x in $(seq "$min_x" "$max_x")
      do
        if [[ "$y" == $(( max_y + 2 )) ]]
        then
          line="${line}#"
        elif [[ "${world[$x,$y]}" == "" ]]
        then
          line="${line}."
        else
          line="${line}${world[$x,$y]}"
        fi
      done
      echo "$line"
    done

    echo
    echo "Sand: $sand"
    echo
  fi
done

#draw the world
for y in $(seq 0 $(( max_y + 2 )))
do
  line=""
  for x in $(seq "$min_x" "$max_x")
  do
    if [[ "$y" == $(( max_y + 2 )) ]]
    then
      line="${line}#"
    elif [[ "${world[$x,$y]}" == "" ]]
    then
      line="${line}."
    else
      line="${line}${world[$x,$y]}"
    fi
  done
  echo "$line"
done

echo
echo "Sand: $sand"
