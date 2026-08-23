#!/bin/bash

# Get current brightness value (raw number, not percentage, for precision)
current_val=$(brightnessctl get)

# $1 is action: up, down
case $1 in
    up)
        brightnessctl set 10%+
        ;;
    down)
        # Check if brightness is already very low (e.g., <= 10 or 1%)
        # 'brightnessctl g' returns the raw value. 
        # Most laptops have a max around 255 or 400.
        if [ "$current_val" -le 5 ]; then
            # Force it to 1 instead of 0
            brightnessctl set 1
        else
            brightnessctl set 10%-
        fi
        ;;
esac

# Get current percentage for the notification
current_per=$(brightnessctl -m | cut -d, -f4 | tr -d '%')

notify-send -h string:x-canonical-private-synchronous:bright-notify \
            -u low -i display-brightness "Brightness: ${current_per}%" \
            -h int:value:"$current_per"



