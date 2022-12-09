#!/usr/local/bin/bash

h_x=0
h_y=0
t_x=0
t_y=0

rm -rf visited
mkdir visited

while read -r movement
do
  dir="${movement/ */}"
  distance="${movement/* /}"

  for (( i=1; i<=distance; i++ ))
  do
    #Move H
    case "$dir" in
      "R")
        h_x=$((h_x + 1))
        ;;
      "L")
        h_x=$((h_x - 1))
        ;;
      "U")
        h_y=$((h_y - 1))
        ;;
      "D")
        h_y=$((h_y + 1))
        ;;
    esac
    #Move T
    x_diff=$((h_x - t_x))
    y_diff=$((h_y - t_y))
    if [[ "$x_diff" == 0 ]]
    then
      if [[ "$y_diff" == 2 ]]
      then
        t_y=$((t_y + 1))
      elif [[ "$y_diff" == -2 ]]
      then
        t_y=$((t_y - 1))
      fi
    elif [[ "$y_diff" == 0 ]]
    then
      if [[ "$x_diff" == 2 ]]
      then
        t_x=$((t_x + 1))
      elif [[ "$x_diff" == -2 ]]
      then
        t_x=$((t_x - 1))
      fi
    elif [[ "$x_diff" == 1 ]]
    then
      if [[ "$y_diff" == 2 ]]
      then
        t_y=$((t_y + 1))
        t_x=$((t_x + 1))
      elif [[ "$y_diff" == -2 ]]
      then
        t_y=$((t_y - 1))
        t_x=$((t_x + 1))
      fi
    elif [[ "$x_diff" == -1 ]]
    then
      if [[ "$y_diff" == 2 ]]
      then
        t_y=$((t_y + 1))
        t_x=$((t_x - 1))
      elif [[ "$y_diff" == -2 ]]
      then
        t_y=$((t_y - 1))
        t_x=$((t_x - 1))
      fi
    elif [[ "$y_diff" == 1 ]]
    then
      if [[ "$x_diff" == 2 ]]
      then
        t_y=$((t_y + 1))
        t_x=$((t_x + 1))
      elif [[ "$x_diff" == -2 ]]
      then
        t_y=$((t_y + 1))
        t_x=$((t_x - 1))
      fi
    elif [[ "$y_diff" == -1 ]]
    then
      if [[ "$x_diff" == 2 ]]
      then
        t_y=$((t_y - 1))
        t_x=$((t_x + 1))
      elif [[ "$x_diff" == -2 ]]
      then
        t_y=$((t_y - 1))
        t_x=$((t_x - 1))
      fi
    fi
    echo "Diff: $x_diff, $y_diff"
    touch visited/"${t_x}-${t_y}"
  done

done < input
