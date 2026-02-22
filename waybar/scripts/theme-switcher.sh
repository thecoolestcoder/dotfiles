#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
HYPR_DIR="$HOME/.config/hypr"
THEMES_DIR="$WAYBAR_DIR/themes"
BORDER_THEMES_DIR="$HYPR_DIR/themes"
CURRENT_WAYBAR="$WAYBAR_DIR/style.css"
CURRENT_BORDERS="$BORDER_THEMES_DIR/current-borders.conf"

# Get list of available themes
themes=$(ls "$THEMES_DIR"/*.css | xargs -n 1 basename | sed 's/.css//')

# Use rofi to select theme
selected=$(echo "$themes" | rofi -dmenu -p "Select Theme")

# If nothing selected, exit
[[ -z "$selected" ]] && exit 0

# Copy selected waybar theme
cp "$THEMES_DIR/$selected.css" "$CURRENT_WAYBAR"

# Copy matching border theme if it exists
if [[ -f "$BORDER_THEMES_DIR/$selected-borders.conf" ]]; then
    cp "$BORDER_THEMES_DIR/$selected-borders.conf" "$CURRENT_BORDERS"
else
    # Fallback to default borders
    cp "$BORDER_THEMES_DIR/default-borders.conf" "$CURRENT_BORDERS"
fi

# Reload waybar
pkill waybar
waybar &

# Reload hyprland to apply new borders
hyprctl reload
