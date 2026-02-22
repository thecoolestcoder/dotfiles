#!/usr/bin/env bash

# Constants
divider="─────────────────"
goback=" Back"

# Nerd Font icons
ICON_WIFI_FULL="󰤨"
ICON_WIFI_HIGH="󰤥"
ICON_WIFI_MED="󰤢"
ICON_WIFI_LOW="󰤟"
ICON_WIFI_OFF="󰤭"
ICON_CONNECTED="󰔡"
ICON_LOCKED="󰍁"
ICON_UNLOCKED="󰍃"
ICON_POWER="󰐥"
ICON_SCAN="󰂪"

# --- HELPER FUNCTIONS ---

get_signal_icon() {
    local signal="$1"
    if [[ "$signal" -ge 75 ]]; then echo "$ICON_WIFI_FULL";
    elif [[ "$signal" -ge 50 ]]; then echo "$ICON_WIFI_HIGH";
    elif [[ "$signal" -ge 25 ]]; then echo "$ICON_WIFI_MED";
    else echo "$ICON_WIFI_LOW"; fi
}

get_security_icon() {
    [[ "$1" == "--" || -z "$1" ]] && echo "$ICON_UNLOCKED" || echo "$ICON_LOCKED"
}

wifi_enabled() {
    nmcli radio wifi | grep -q "enabled"
}

get_current_connection() {
    nmcli -t -f NAME,TYPE connection show --active | grep "802-11-wireless" | cut -d: -f1
}

# --- FIX: ROBUST SSID EXTRACTION ---
# This function pulls the SSID regardless of icons or signal percentage
extract_ssid() {
    echo "$1" | sed -E 's/^[^a-zA-Z0-9]*//; s/ \([0-9]+%\)$//' | xargs
}

# --- ACTIONS ---

toggle_wifi() {
    wifi_enabled && nmcli radio wifi off || nmcli radio wifi on
    sleep 1
    show_menu
}

list_networks() {
    # Scan and list with a format that's easier to parse later
    nmcli -f SSID,SIGNAL,SECURITY device wifi list | tail -n +2 | while read -r ssid signal security; do
        [[ -z "$ssid" || "$ssid" == "--" ]] && continue
        
        local sig_icon=$(get_signal_icon "$signal")
        local sec_icon=$(get_security_icon "$security")
        
        if [[ "$ssid" == "$(get_current_connection)" ]]; then
            echo "$ICON_CONNECTED $sig_icon $sec_icon $ssid ($signal%)"
        else
            echo "  $sig_icon $sec_icon $ssid ($signal%)"
        fi
    done | sort -u
}

connect_network() {
    local ssid=$(extract_ssid "$1")
    notify-send "WiFi" "Connecting to $ssid..."
    
    # Check if already saved
    if nmcli connection show | grep -q "^$ssid "; then
        nmcli connection up "$ssid" || notify-send "WiFi" "Failed to connect"
    else
        local security=$(nmcli -t -f SSID,SECURITY device wifi list | grep "^$ssid:" | cut -d: -f2)
        if [[ "$security" == "--" || -z "$security" ]]; then
            nmcli device wifi connect "$ssid"
        else
            local pass=$(rofi -dmenu -password -p "Password for $ssid")
            [[ -n "$pass" ]] && nmcli device wifi connect "$ssid" password "$pass"
        fi
    fi
    show_menu
}

# --- MENUS ---

network_menu() {
    local raw_line="$1"
    local ssid=$(extract_ssid "$raw_line")
    
    local options="󰤨 Connect\n󰆴 Forget Network\n$divider\n$goback"
    [[ "$ssid" == "$(get_current_connection)" ]] && options="󱛂 Disconnect\n󰆴 Forget Network\n$divider\n$goback"

    chosen=$(echo -e "$options" | rofi -dmenu -i -p "$ssid")
    
    case "$chosen" in
        "󰤨 Connect") connect_network "$raw_line" ;;
        "󱛂 Disconnect") nmcli connection down id "$ssid" && show_menu ;;
        "󰆴 Forget Network") nmcli connection delete id "$ssid" && show_menu ;;
        "$goback") show_menu ;;
    esac
}

show_menu() {
    local current=$(get_current_connection)
    local options=""

    if wifi_enabled; then
        options="$ICON_POWER WiFi: ON\n$ICON_SCAN Rescan\n$divider\n$(list_networks)"
    else
        options="$ICON_POWER WiFi: OFF"
    fi

    chosen=$(echo -e "$options" | rofi -dmenu -i -p "WiFi")

    case "$chosen" in
        "") exit ;;
        *"WiFi: "*) toggle_wifi ;;
        *"Rescan"*) nmcli device wifi rescan && sleep 1 && show_menu ;;
        *) [[ "$chosen" == *"("*")" ]] && network_menu "$chosen" ;;
    esac
}

show_menu
