#!/bin/bash

# 1. Generate colors with Pywal
wal -i "$1"

# 2. Update Kitty colors
killall -USR1 kitty || true

# 3. Handle cache wallpaper
rm -f "$HOME/.cache/current_wallpaper"
cp "$1" "$HOME/.cache/current_wallpaper"

# 4. Apply wallpaper with grow transition explicitly
swww img "$1" \
  --transition-type any \
  --transition-step 63 \
  --transition-duration 2 \
  --transition-fps 60 \
  --transition-angle 0

# 5. Reload Waybar
pkill waybar
sleep 0.3
waybar &
~/.config/wal/scripts/cava-reload.sh
