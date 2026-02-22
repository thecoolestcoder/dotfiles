#!/bin/bash

case $1 in
    raise)
        # -i 5 adds 5%, --allow-boost allows going over 100% if needed
        pamixer -i 5
        ;;
    lower)
        pamixer -d 5
        ;;
    mute)
        pamixer -t
        ;;
    mic-mute)
        pamixer --default-source -t
        ;;
esac

if [ "$1" == "mic-mute" ]; then
    is_muted=$(pamixer --default-source --get-mute)
    if [ "$is_muted" == "true" ]; then
         notify-send -h string:x-canonical-private-synchronous:mic-notify -u low -i microphone-sensitivity-muted "Mic Muted"
    else
         notify-send -h string:x-canonical-private-synchronous:mic-notify -u low -i microphone-sensitivity-high "Mic On"
    fi
else
    vol=$(pamixer --get-volume)
    is_muted=$(pamixer --get-mute)
    
    if [ "$is_muted" == "true" ]; then
        notify-send -h string:x-canonical-private-synchronous:vol-notify -u low -i audio-volume-muted "Muted"
    else
        notify-send -h string:x-canonical-private-synchronous:vol-notify -u low -i audio-volume-high "Volume: ${vol}%" -h int:value:$vol
    fi
fi
