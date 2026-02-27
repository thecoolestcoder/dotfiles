#!/bin/bash

# Check if wifi is currently enabled
WIFI_STATUS=$(nmcli radio wifi)

if [ "$WIFI_STATUS" = "enabled" ]; then
    nmcli radio all off
else
    nmcli radio all on
fi

# This tells SwayNC to re-run the "update-command" immediately
swaync-client -rs
