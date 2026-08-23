#!/usr/bin/env bash

if pgrep -x "hypridle" > /dev/null
then
    pkill hypridle
    notify-send "Caffeine Mode" "Idle Disabled" -t 2000
else
    hypridle &
    notify-send "Caffeine Mode" "Idle Enabled" -t 2000
fi
