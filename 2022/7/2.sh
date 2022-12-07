#!/usr/local/bin/bash

top_dir=$(pwd)
base_dir="./fs"
rm -rf "$base_dir"
mkdir "$base_dir"
cd "$base_dir"
ls_output=0

while read -r terminal
do
  if [[ "$ls_output" -eq 1 ]]
  then
    if [[ ! "$terminal" =~ ^\$.*$ ]]
    then
      if [[ "$terminal" =~ ^dir.*$ ]]
      then
        mkdir "${terminal/* /}"
      else
        echo "${terminal/ */}" > "${terminal/* /}"
      fi
    else
      ls_output=0
    fi
  fi

  if [[ "$ls_output" -eq 0 ]]
  then
    if [[ "$terminal" =~ ^\$.*cd.*$ ]]
    then
      cd ./"${terminal/* /}"
    elif [[ "$terminal" =~ ^\$.*ls$ ]]
    then
      ls_output=1
    fi
  fi
done < ../input

total_size=$(find "${top_dir}/${base_dir}" -type f -exec cat {} \; | jq -s add)
free_space=$((70000000 - total_size))
space_needed=$((30000000 - free_space))

dir_del_size=70000000
for directory in $(find "${top_dir}/${base_dir}" -type d)
do
  dir_size=$(find "$directory" -type f -exec cat {} \; | jq -s add)
  if [[ "$dir_size" -ge "$space_needed" ]]
  then
    if [[ "$dir_size" -lt "$dir_del_size" ]]
    then
      dir_del_size="$dir_size"
    fi
  fi
done

echo "$dir_del_size"
