#!/bin/bash

# Path to the wallpaper (passed as an argument)
WALLPAPER=$1

# 1. Set the wallpaper using swww (supports smooth transitions)
swww img "$WALLPAPER" --transition-type outer --transition-fps 60

# 2. Generate colors using pywal (or wallust/matugen)
wal -i "$WALLPAPER"

# 3. Reload Kitty colors (sends escape sequences to all open kitty windows)
kitty @ set-colors -a "~/.cache/wal/colors-kitty.conf"

# 4. Reload Waybar
# We kill it and restart it so it picks up the new @import in style.css
pkill waybar
hyprctl dispatch exec waybar

# 5. Reload Hyprland borders (optional)
# This requires a pywal template (see step 2 below)
hyprctl keyword general:col.active_border "rgb($(cat ~/.cache/wal/colors-hyprland))"
