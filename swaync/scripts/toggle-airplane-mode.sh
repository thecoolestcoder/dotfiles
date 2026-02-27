#!/bin/bash

# Toggle Airplane Mode (Wi-Fi) using nmcli
# Checks if Wi-Fi is enabled and toggles it.

WIFI_STATUS=$(nmcli radio wifi)

if [ "$WIFI_STATUS" == "enabled" ]; then
  nmcli radio wifi off
  notify-send "Airplane Mode" "Wi-Fi Disabled" -i network-wireless-offline
else
  nmcli radio wifi on
  notify-send "Airplane Mode" "Wi-Fi Enabled" -i network-wireless
fi
