#!/bin/sh

# Example

sudo echo "23" > /sys/class/gpio/export
sudo echo "out" > /sys/class/gpio/gpio23/direction

start=$(date +%s)
while true; do
  proc=$(ps -aux | grep arecord | grep -v grep)
  if [ -z "$proc" ]; then
    echo "0" > /sys/class/gpio/gpio23/value
    part=$(cat partition.conf)
    if [ $part -eq 0 ]; then
      /usr/bin/arecord -c 2 -f S16 -t wav -r 96000 --max-file-time 300 --use-strftime /home/pi/AUDIO/%Y_%m_%d_%H_%M_%S_%v.wav
    else
      if [ $part -le 1 ]; then
        /usr/bin/arecord -c 2 -f S16 -t wav -r 96000 --max-file-time 300 --use-strftime /media/Part_$part/%Y_%m_%d_%H_%M_%S_%v.wav
      fi
    fi
  else
    end=$(date +%s)
    diff=$(($end-$start))
    if [ $diff -lt 36000 ]; then
      echo "1" > /sys/class/gpio/gpio23/value
      sleep 0.001
      echo "0" > /sys/class/gpio/gpio23/value
    fi
  fi
  sleep 5
done

