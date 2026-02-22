#!/bin/bash

# Get current active profile
current=$(powerprofilesctl get)

# Define display names and match them to power-profiles-daemon keywords
perf_label="󰓅 Performance"
bal_label="󰾗 Balanced"
save_label="󰾆 Power Saver"

# Add a marker to the active one
[[ "$current" == "performance" ]] && perf_label="$perf_label (Active)"
[[ "$current" == "balanced" ]] && bal_label="$bal_label (Active)"
[[ "$current" == "power-saver" ]] && save_label="$save_label (Active)"

options="$perf_label\n$bal_label\n$save_label\n---\n󰂄 View Full Status"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Mode: $current" -config ~/.config/rofi/config.rasi)

case $chosen in
    *"Performance"*)
        powerprofilesctl set performance
        notify-send "Power Profile" "Switched to Performance" -i notification-power-performance
        ;;
    *"Balanced"*)
        powerprofilesctl set balanced
        notify-send "Power Profile" "Switched to Balanced" -i notification-power-balanced
        ;;
    *"Power Saver"*)
        powerprofilesctl set power-saver
        notify-send "Power Profile" "Switched to Power Saver" -i notification-power-low
        ;;
    *"View Full Status"*)
        info=$(upower -i $(upower -e | grep 'BAT') | grep -E "state|percentage|time to empty|capacity")
        echo -e "$info" | rofi -dmenu -p "Battery Details"
        ;;
esac