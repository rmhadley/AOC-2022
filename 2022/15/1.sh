#!/usr/local/bin/bash

declare -A sensors
declare -A row
declare -A beacons

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

for sensor in "${!sensors[@]}"
do
  sensor_x="${sensor/,*/}"
  sensor_y="${sensor/*,/}"
  distance="${sensors[$sensor]/*,*,/}"

  if [[ "${sensors[$sensor]}" =~ ^.*,2000000,.*$ ]]
  then
    beacons["${sensors[$sensor]/,*,*/}"]="B"
  fi

  min_y=$(( sensor_y - distance ))
  max_y=$(( sensor_y + distance ))
  if [[ $min_y -le 2000000 ]] && [[ $max_y -ge 2000000 ]]
  then
    y_diff=$(( 2000000 - sensor_y ))
    y_diff=${y_diff#-}
    max_x_diff=$(( distance - y_diff ))

    for (( x=$(( sensor_x - max_x_diff )); x<=$(( sensor_x + max_x_diff )); x++ ))
    do
      row["$x"]="#"
    done
  fi
done

echo $(( ${#row[@]} - ${#beacons[@]} ))
