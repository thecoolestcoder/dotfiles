#!/usr/bin/env bash

STEP=5
MAX=1.5
SIGNAL=8

default_sink_get() {
    wpctl status | awk '/▲ Sinks:/{sf=1} sf && /^\s*\*[[:space:]]*\d+/{print $2; exit}'
}

notify_volume() {
    local vol_info vol icon
    vol_info="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
    vol="$(awk '{print int($2 * 100)}' <<< "$vol_info")"

    if grep -q '\[MUTED\]' <<< "$vol_info"; then
        icon="audio-volume-muted"
        notify-send \
            -a "volume" \
            -r 9991 \
            -u low \
            -h string:x-canonical-private-synchronous:volume \
            -i "$icon" \
            "Muted"
    else
        if [ "$vol" -lt 34 ]; then
            icon="audio-volume-low"
        elif [ "$vol" -lt 67 ]; then
            icon="audio-volume-medium"
        else
            icon="audio-volume-high"
        fi

        notify-send \
            -a "volume" \
            -r 9991 \
            -u low \
            -h string:x-canonical-private-synchronous:volume \
            -h int:value:"$vol" \
            -i "$icon" \
            "Volume ${vol}%"
    fi
}

notify_mic() {
    local mic_info mic icon
    mic_info="$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)"
    mic="$(awk '{print int($2 * 100)}' <<< "$mic_info")"

    if grep -q '\[MUTED\]' <<< "$mic_info"; then
        icon="microphone-sensitivity-muted"
        notify-send \
            -a "volume" \
            -r 9992 \
            -u low \
            -h string:x-canonical-private-synchronous:microphone \
            -i "$icon" \
            "Microphone muted"
    else
        icon="microphone-sensitivity-high"
        notify-send \
            -a "volume" \
            -r 9992 \
            -u low \
            -h string:x-canonical-private-synchronous:microphone \
            -h int:value:"$mic" \
            -i "$icon" \
            "Microphone ${mic}%"
    fi
}

refresh_waybar() {
    pkill -RTMIN+"$SIGNAL" waybar 2>/dev/null
}

case "$1" in
    raise)
        wpctl set-volume -l "$MAX" @DEFAULT_AUDIO_SINK@ "${STEP}%+"
        notify_volume
        refresh_waybar
        ;;
    lower)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${STEP}%-"
        notify_volume
        refresh_waybar
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        notify_volume
        refresh_waybar
        ;;
    mic-mute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        notify_mic
        refresh_waybar
        ;;
    *)
        exit 1
        ;;
esac
