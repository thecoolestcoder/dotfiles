#!/bin/bash

# Kill previous instances
for pid in $(pgrep -f "bash.*caps_lock_watch.sh"); do 
    if [ "$pid" != "$$" ]; then
        kill "$pid"
    fi
done

# Find the first valid Caps Lock LED path
LEDPATH=$(find /sys/class/leds -name "*capslock*" | head -n 1)/brightness

if [ -z "$LEDPATH" ] || [ ! -f "$LEDPATH" ]; then
    notify-send "Error" "No Caps Lock LED found!"
    exit 1
fi

# Initial state
LAST_STATE=$(cat "$LEDPATH")

while true; do
    CURRENT_STATE=$(cat "$LEDPATH")
    
    if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
        if [ "$CURRENT_STATE" -eq 1 ]; then
            notify-send -t 1500 -h string:x-canonical-private-synchronous:caps-notify -u low -i input-keyboard "Caps Lock" "ON"
        else
            notify-send -t 1500 -h string:x-canonical-private-synchronous:caps-notify -u low -i input-keyboard "Caps Lock" "OFF"
        fi
        LAST_STATE="$CURRENT_STATE"
    fi
    
    # Check every 0.1 seconds (low CPU usage)
    sleep 0.1
done
