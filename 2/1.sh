#!/bin/bash

total=0

while read -r game
do
  them=$(echo "$game" | cut -f 1 -d " ")
  us=$(echo "$game" | cut -f 2 -d " ")

  #A = rock
  #B = paper
  #C = scissors
  #X = rock
  #Y = paper
  #Z = scissors

  if [ "$us" == "X" ]
  then
    score=1
  elif [ "$us" == "Y" ]
  then
    score=2
  elif [ "$us" == "Z" ]
  then
    score=3
  fi

  if [ "$them" == "A" ]
  then
    if [ "$us" == "Y" ]
    then
      score=$((score + 6))
    elif [ "$us" == "X" ]
    then
      score=$((score + 3))
    fi
  fi

  if [ "$them" == "B" ]
  then
    if [ "$us" == "Z" ]
    then
      score=$((score + 6))
    elif [ "$us" == "Y" ]
    then
      score=$((score + 3))
    fi
  fi

  if [ "$them" == "C" ]
  then
    if [ "$us" == "X" ]
    then
      score=$((score + 6))
    elif [ "$us" == "Z" ]
    then
      score=$((score + 3))
    fi
  fi

  total=$((total + score))

done < input 

echo "$total"
