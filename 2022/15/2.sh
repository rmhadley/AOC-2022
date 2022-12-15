#!/usr/local/bin/bash

declare -A sensors

while read -r sensor
do
  sensor_x=$( echo "$sensor" | cut -f3 -d " " | sed -e 's/[^0-9]*//g')
  sensor_y=$( echo "$sensor" | cut -f4 -d " " | sed -e 's/[^0-9]*//g')
  beacon_x=$( echo "$sensor" | cut -f9 -d " " | sed -e 's/[^0-9]*//g')
  beacon_y=$( echo "$sensor" | cut -f10 -d " " | sed -e 's/[^0-9]*//g')

  x_diff=$(( sensor_x - beacon_x ))
  x_diff=${x_diff#-}
  y_diff=$(( sensor_y - beacon_y ))
  y_diff=${y_diff#-}
  distance=$(( x_diff + y_diff ))

  sensors["$sensor_x,$sensor_y"]="$beacon_x,$beacon_y,$distance"
done < input

#3187704
for (( check_row=0; check_row<=4000000; check_row++))
do
  if [[ $(( check_row % 1000 )) -eq 0 ]]
  then
    echo "Row: $check_row"
  fi
  unset ranges
  declare -a ranges

  for sensor in "${!sensors[@]}"
  do
    sensor_x="${sensor/,*/}"
    sensor_y="${sensor/*,/}"
    distance="${sensors[$sensor]/*,*,/}"

    min_y=$(( sensor_y - distance ))
    max_y=$(( sensor_y + distance ))
    if [[ $min_y -le $check_row ]] && [[ $max_y -ge $check_row ]]
    then
      y_diff=$(( check_row - sensor_y ))
      y_diff=${y_diff#-}
      max_x_diff=$(( distance - y_diff ))
      range_x1=$(( sensor_x - max_x_diff ))
      range_x2=$(( sensor_x + max_x_diff ))
      if [[ $range_x1 -lt 0 ]]
      then
        range_x1=0
      fi
      if [[ $range_x2 -lt 0 ]]
      then
        range_x2=0
      fi
      if [[ $range_x1 -gt 4000000 ]]
      then
        range_x1=4000000
      fi
      if [[ $range_x2 -gt 4000000 ]]
      then
        range_x2=4000000
      fi

      ranges[${#ranges[@]}]="$range_x1,$range_x2"
    fi
  done

  unset combined_ranges
  combined_ranges=("0,0" "0,0")

  for range in "${ranges[@]}"
  do
    range_x1="${range/,*/}"
    range_x2="${range/*,/}"
    if [[ "${combined_ranges[0]}" == "0,0" ]]
    then
      combined_ranges[0]="$range"
    else
      c_range_1="${combined_ranges[0]/,*/}"
      c_range_2="${combined_ranges[0]/*,/}"
      if [[ "$range_x1" -ge "$c_range_1" ]] && [[ "$range_x1" -le "$c_range_2" ]]
      then
        #range starts withing combined range
        if [[ "$range_x2" -gt "$c_range_2" ]]
        then
          combined_ranges[0]="$c_range_1,$range_x2"
        fi
      elif [[ "$range_x1" -lt "$c_range_1" ]] && [[ "$range_x2" -ge "$c_range_1" ]]
      then
        if [[ "$range_x2" -gt "$c_range_2" ]]
        then
          combined_ranges[0]="$range_x1,$range_x2"
        else
          combined_ranges[0]="$range_x1,$c_range_2"
        fi
      else
        if [[ "${combined_ranges[1]}" == "0,0" ]]
        then
          combined_ranges[1]="$range"
        else
          c_range_1="${combined_ranges[1]/,*/}"
          c_range_2="${combined_ranges[1]/*,/}"
          if [[ "$range_x1" -ge "$c_range_1" ]] && [[ "$range_x1" -le "$c_range_2" ]]
          then
            #range starts withing combined range
            if [[ "$range_x2" -gt "$c_range_2" ]]
            then
              combined_ranges[1]="$c_range_1,$range_x2"
            fi
          elif [[ "$range_x1" -lt "$c_range_1" ]] && [[ "$range_x2" -ge "$c_range_1" ]]
          then
            if [[ "$range_x2" -gt "$c_range_2" ]]
            then
              combined_ranges[1]="$range_x1,$range_x2"
            else
              combined_ranges[0]="$range_x1,$c_range_2"
            fi
          fi
        fi
      fi
    fi
  done
  if [[ "${combined_ranges[1]}" != "0,0" ]]
  then
    c_range_1="${combined_ranges[0]/*,/}"
    c_range_2="${combined_ranges[1]/,*/}"
    if [[ "$c_range_1" -lt "$c_range_2" ]]
    then
      echo "Maybe here? $check_row"
      break
    fi
  fi
done


echo "0: ${combined_ranges[0]}"
echo "1: ${combined_ranges[1]}"
answer=$(( ${combined_ranges[0]/*,/} * 4000000 + check_row ))
echo "Answer: $answer"
