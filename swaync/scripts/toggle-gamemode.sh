#!/bin/bash

# Toggle Gamemode (Hyprland animations)
# Uses a state file to track if gamemode is active.

STATE_FILE="/home/coolboi/.config/swaync/scripts/.gamemode_active"

if [ -f "$STATE_FILE" ]; then
  # Gamemode is active, disable it (enable animations)
  hyprctl keyword animations:enabled 1 > /dev/null
  rm "$STATE_FILE"
  notify-send "Gamemode" "Animations Enabled (Gamemode Off)" -i games
else
  # Gamemode is inactive, enable it (disable animations)
  hyprctl keyword animations:enabled 0 > /dev/null
  touch "$STATE_FILE"
  notify-send "Gamemode" "Animations Disabled (Gamemode On)" -i applications-games
fi
