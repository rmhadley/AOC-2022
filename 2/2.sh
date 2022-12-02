#!/bin/bash

total=0

while read -r game
do
  them=$(echo "$game" | cut -f 1 -d " ")
  us=$(echo "$game" | cut -f 2 -d " ")

  #A = rock
  #B = paper
  #C = scissors
  #X = lose
  #Y = draw
  #Z = win

  # lose
  if [ "$us" == "X" ]
  then
    if [ "$them" == "A" ]
    then
      score=3
    elif [ "$them" == "B" ]
    then
      score=1
    elif [ "$them" == "C" ]
    then
      score=2
    fi
  fi

  # draw
  if [ "$us" == "Y" ]
  then
    if [ "$them" == "A" ]
    then
      score=4
    elif [ "$them" == "B" ]
    then
      score=5
    elif [ "$them" == "C" ]
    then
      score=6
    fi
  fi

  # win
  if [ "$us" == "Z" ]
  then
    if [ "$them" == "A" ]
    then
      score=8
    elif [ "$them" == "B" ]
    then
      score=9
    elif [ "$them" == "C" ]
    then
      score=7
    fi
  fi

  total=$((total + score))

done < input 

echo "$total"
