#!/bin/bash
part=$(cat partition.conf)
if [ $part -eq 0 ]; then 
  avail=$(df | grep root | awk '{ print $4 }')
else
  avail=$(df | grep 'Part_'$part | awk '{ print $4 }')
fi
#avail=$(df | grep 'Part_'$part | awk '{ print $4 }')
#echo $avail
if [ $avail -lt 100000 ]; then
  part=$((part+1))
  echo $part > partition.conf
  pkill arecord
  sleep 2
  if [ $part -le 3 ]; then
    /usr/bin/arecord -c 2 -f S16 -t wav -r 96000 --max-file-time 300 --use-strftime /media/Part_$part/%Y_%m_%d_%H_%M_%S_%v.wav
  fi
fi
