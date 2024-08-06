#!/bin/sh
 /usr/bin/arecord -c 2 -f S16 -t wav -r 96000 --max-file-time 300 --use-strftime /home/pi/AUDIO/%Y_%m_%d_%H_%M_%S_%v.wav
