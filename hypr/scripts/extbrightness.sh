#!/bin/bash

# Adjust this: 10 = 10% steps
step=10

case $1 in
    up)
        ddcutil --display 1 setvcp 10 + "$step"
        ;;
    down)
        current=$(ddcutil --display 1 getvcp 10 | grep -o 'current value: [0-9]*' | grep -o '[0-9]*')
        if [ "$current" -le 10 ]; then
            ddcutil --display 1 setvcp 10 10
        else
            ddcutil --display 1 setvcp 10 - "$step"
        fi
        ;;
    *)
        echo "Usage: $0 up|down"
        exit 1
        ;;
esac

# Send OSD
current_val=$(ddcutil --display 1 getvcp 10 | grep -o 'current value: [0-9]*' | grep -o '[0-9]*')
notify-send -h string:x-canonical-private-synchronous:bright-notify \
            -u low \
            -i display-brightness \
            "External Brightness: ${current_val}%" \
            -h int:value:"$current_val"
