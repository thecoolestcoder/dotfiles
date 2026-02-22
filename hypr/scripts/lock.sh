#!/usr/bin/env bash
# Force symlink to current swww wallpaper
WALL=$(swww query | grep 'path:' | cut -d ' ' -f2)
mkdir -p ~/.cache
rm -f ~/.cache/current_wallpaper
ln -sf "$WALL" ~/.cache/current_wallpaper
# Verify
ls -la ~/.cache/current_wallpaper
hyprlock
