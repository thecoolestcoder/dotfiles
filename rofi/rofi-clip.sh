#!/bin/bash

# Define the Rofi theme/style (optional)
# Change 'dmenu' to your preferred rofi mode or theme
# e.g., rofi -dmenu -theme ~/.config/rofi/config.rasi
ROFI_CMD="rofi -dmenu -p 󰅇  -i"

# 1. Fetch history from cliphist
# 2. Pipe to Rofi for selection
# 3. Decode selection back to clipboard
# 4. Paste it if you want (optional)

selected=$(cliphist list | $ROFI_CMD)

if [ -n "$selected" ]; then
    echo "$selected" | cliphist decode | wl-copy
    # Optional: Send a notification
    notify-send "Clipboard" "Copied to clipboard!" -t 1000
fi
