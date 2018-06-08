#!/bin/bash

BRIGHTNESS=`cat /sys/class/backlight/intel_backlight/brightness`
FILE=/sys/class/backlight/intel_backlight/brightness

if [ -z $1 ]; then
    echo $BRIGHTNESS
else
    if [ $1 > 0 ]; then
        VALUE=$(($BRIGHTNESS + $1))
        echo $VALUE > $FILE
    elif [ $1 < 0 ]; then
        VALUE=$(($BRIGHTNESS - $1))
        echo $VALUE > $FILE
    else
        echo 'In parameter you have to set value <> 0'
    fi;
    echo $BRIGHTNESS
fi;

