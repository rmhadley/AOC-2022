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
          world["$x,$y"]="🟩"
        done
      done

      d_start=$point
    else
      d_start=$point
    fi
  done
done < "$1"

function drop_sand {
  sand_x=$drop_from_x
  sand_y=$drop_from_y

  fell_off=1

  for y in $(seq "$sand_y" "$max_y")
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
    fell_off=0
    world["${sand_x},${sand_y}"]="🟤"
    break
  done

  if [[ "$fell_off" == 1 ]]
  then
    end=1
  fi
}

function draw_world {
  world_output=""
  start_at=0
  if [[ "$max_y" -gt 50 ]]
  then
    if [[ "$sand_y" -gt 50 ]]
    then
      start_at=$(( sand_y - 25 ))
      max=$(( sand_y + 25 ))
    else
      max=50
    fi
  else
    max=$max_y
  fi
  for y in $(seq "$start_at" "$max")
  do
    line=""
    for x in $(seq $(( min_x - 2)) $(( max_x + 2 )))
    do
      if [[ "${world[$x,$y]}" == "" ]]
      then
        line="${line}🟦"
      else
        line="${line}${world[$x,$y]}"
      fi
    done
    world_output="${world_output}\n${line}"
  done
  clear
  echo -e "$world_output"
}

end=0
sand=0
drop_from_x=500
drop_from_y=0

world["500,0"]="🔻"

while [[ $end = 0 ]]
do
  drop_sand
  draw_world
  if [[ $end = 0 ]]
  then
    sand=$(( sand + 1 ))
  fi
done


draw_world

echo
echo "Sand: $sand"
