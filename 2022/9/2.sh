#!/usr/local/bin/bash

move=1

function move_knott {
  my_x="${t_x[$1]}"
  my_y="${t_y[$1]}"
  their_x="$2"
  their_y="$3"

  x_diff=$((their_x - my_x))
  y_diff=$((their_y - my_y))
  
  if [[ "$x_diff" == 0 ]]
  then
    if [[ "$y_diff" == 2 ]]
    then
      my_y=$((my_y + 1))
    elif [[ "$y_diff" == -2 ]]
    then
      my_y=$((my_y - 1))
    fi
  elif [[ "$y_diff" == 0 ]]
  then
    if [[ "$x_diff" == 2 ]]
    then
      my_x=$((my_x + 1))
    elif [[ "$x_diff" == -2 ]]
    then
      my_x=$((my_x - 1))
    fi
  elif [[ "$x_diff" == 1 ]]
  then
    if [[ "$y_diff" == 2 ]]
    then
      my_y=$((my_y + 1))
      my_x=$((my_x + 1))
    elif [[ "$y_diff" == -2 ]]
    then
      my_y=$((my_y - 1))
      my_x=$((my_x + 1))
    fi
  elif [[ "$x_diff" == -1 ]]
  then
    if [[ "$y_diff" == 2 ]]
    then
      my_y=$((my_y + 1))
      my_x=$((my_x - 1))
    elif [[ "$y_diff" == -2 ]]
    then
      my_y=$((my_y - 1))
      my_x=$((my_x - 1))
    fi
  elif [[ "$y_diff" == 1 ]]
  then
    if [[ "$x_diff" == 2 ]]
    then
      my_y=$((my_y + 1))
      my_x=$((my_x + 1))
    elif [[ "$x_diff" == -2 ]]
    then
      my_y=$((my_y + 1))
      my_x=$((my_x - 1))
    fi
  elif [[ "$y_diff" == -1 ]]
  then
    if [[ "$x_diff" == 2 ]]
    then
      my_y=$((my_y - 1))
      my_x=$((my_x + 1))
    elif [[ "$x_diff" == -2 ]]
    then
      my_y=$((my_y - 1))
      my_x=$((my_x - 1))
    fi
  elif [[ "$y_diff" == 2 ]] && [[ "$x_diff" == 2 ]]
  then
      my_y=$((my_y + 1))
      my_x=$((my_x + 1))
  elif [[ "$y_diff" == -2 ]] && [[ "$x_diff" == -2 ]]
  then
      my_y=$((my_y - 1))
      my_x=$((my_x - 1))
  elif [[ "$y_diff" == -2 ]] && [[ "$x_diff" == 2 ]]
  then
      my_y=$((my_y - 1))
      my_x=$((my_x + 1))
  elif [[ "$y_diff" == 2 ]] && [[ "$x_diff" == -2 ]]
  then
      my_y=$((my_y + 1))
      my_x=$((my_x - 1))
  fi
  t_x["$1"]="$my_x"
  t_y["$1"]="$my_y"
}

h_x=0
h_y=0
declare -a t_x
declare -a t_y
t_x[0]=0
t_y[0]=0
t_x[1]=0
t_y[1]=0
t_x[2]=0
t_y[2]=0
t_x[3]=0
t_y[3]=0
t_x[4]=0
t_y[4]=0
t_x[5]=0
t_y[5]=0
t_x[6]=0
t_y[6]=0
t_x[7]=0
t_y[7]=0
t_x[8]=0
t_y[8]=0

rm -rf visited
mkdir visited

while read -r movement
do
  dir="${movement/ */}"
  distance="${movement/* /}"

  echo "Move: $move"
  move=$((move + 1))

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

    #Move T knotts
    follow_x="$h_x"
    follow_y="$h_y"
    for knott in "${!t_x[@]}"
    do
      move_knott "$knott" "$follow_x" "$follow_y"
      follow_x="${t_x[$knott]}"
      follow_y="${t_y[$knott]}"
    done

    touch visited/"${t_x[8]}-${t_y[8]}"
  done

done < input

