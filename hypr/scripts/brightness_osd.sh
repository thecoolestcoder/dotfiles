#!/bin/bash

# $1 is action: up, down
if [ "$1" == "up" ]; then
    brightnessctl -e4 -n2 set 5%+
elif [ "$1" == "down" ]; then
    brightnessctl -e4 -n2 set 5%-
fi

# Get current brightness percentage
current=$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')

notify-send -h string:x-canonical-private-synchronous:bright-notify -u low -i display-brightness "Brightness: ${current}%" -h int:value:$current
