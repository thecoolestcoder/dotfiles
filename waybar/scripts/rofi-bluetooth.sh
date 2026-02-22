#!/usr/bin/env bash
# rofi-bluetooth — Bluetooth manager widget for rofi
# Depends: rofi, bluez-utils (bluetoothctl), bc

divider="---------"
goback="Back"

# ── Power ──────────────────────────────────────────────
power_on() {
    bluetoothctl show | grep -q "Powered: yes"
}

toggle_power() {
    if power_on; then
        bluetoothctl power off
    else
        if rfkill list bluetooth | grep -q 'blocked: yes'; then
            rfkill unblock bluetooth && sleep 3
        fi
        bluetoothctl power on
    fi
    show_menu
}

# ── Scan ───────────────────────────────────────────────
scan_on() {
    if bluetoothctl show | grep -q "Discovering: yes"; then
        echo "Scan: on"; return 0
    else
        echo "Scan: off"; return 1
    fi
}

toggle_scan() {
    if scan_on; then
        kill $(pgrep -f "bluetoothctl --timeout 5 scan on")
        bluetoothctl scan off
    else
        bluetoothctl --timeout 5 scan on
    fi
    show_menu
}

# ── Pairable / Discoverable ────────────────────────────
pairable_on() {
    if bluetoothctl show | grep -q "Pairable: yes"; then
        echo "Pairable: on"; return 0
    else
        echo "Pairable: off"; return 1
    fi
}
toggle_pairable() {
    power_on && bluetoothctl pairable $(pairable_on && echo off || echo on)
    show_menu
}

discoverable_on() {
    if bluetoothctl show | grep -q "Discoverable: yes"; then
        echo "Discoverable: on"; return 0
    else
        echo "Discoverable: off"; return 1
    fi
}
toggle_discoverable() {
    power_on && bluetoothctl discoverable $(discoverable_on && echo off || echo on)
    show_menu
}

# ── Device helpers ─────────────────────────────────────
device_connected() {
    bluetoothctl info "$1" | grep -q "Connected: yes"
}
device_paired() {
    if bluetoothctl info "$1" | grep -q "Paired: yes"; then
        echo "Paired: yes"; return 0
    else echo "Paired: no"; return 1; fi
}
device_trusted() {
    if bluetoothctl info "$1" | grep -q "Trusted: yes"; then
        echo "Trusted: yes"; return 0
    else echo "Trusted: no"; return 1; fi
}

toggle_connection() {
    if device_connected "$1"; then
        bluetoothctl disconnect "$1"
    else
        bluetoothctl connect "$1"
    fi
    device_menu "$device"
}
toggle_paired() {
    if device_paired "$1"; then bluetoothctl remove "$1"
    else bluetoothctl pair "$1"; fi
    device_menu "$device"
}
toggle_trust() {
    if device_trusted "$1"; then bluetoothctl untrust "$1"
    else bluetoothctl trust "$1"; fi
    device_menu "$device"
}

# ── Status string (for bars like waybar/polybar) ───────
print_status() {
    if power_on; then
        printf ''
        # Support both old (<5.65) and new bluetoothctl versions
        if (( $(echo "$(bluetoothctl version | cut -d ' ' -f 2) < 5.65" | bc -l) )); then
            paired_devices_cmd="paired-devices"
        else
            paired_devices_cmd="devices Paired"
        fi
        mapfile -t paired_devices < <(bluetoothctl $paired_devices_cmd | grep Device | cut -d ' ' -f 2)
        counter=0
        for device in "${paired_devices[@]}"; do
            if device_connected "$device"; then
                alias=$(bluetoothctl info "$device" | grep "Alias" | cut -d ' ' -f 2-)
                [[ $counter -gt 0 ]] && printf ", %s" "$alias" || printf " %s" "$alias"
                ((counter++))
            fi
        done
        printf "\n"
    else
        echo ""
    fi
}

# ── Device submenu ─────────────────────────────────────
device_menu() {
    device=$1
    device_name=$(echo "$device" | cut -d ' ' -f 3-)
    mac=$(echo "$device" | cut -d ' ' -f 2)

    if device_connected "$mac"; then connected="Connected: yes"
    else connected="Connected: no"; fi
    paired=$(device_paired "$mac")
    trusted=$(device_trusted "$mac")

    options="$connected\n$paired\n$trusted\n$divider\n$goback\nExit"
    chosen="$(echo -e "$options" | $rofi_command "$device_name")"

    case "$chosen" in
        "" | "$divider") ;;
        "$connected")    toggle_connection "$mac" ;;
        "$paired")       toggle_paired "$mac" ;;
        "$trusted")      toggle_trust "$mac" ;;
        "$goback")       show_menu ;;
    esac
}

# ── Main menu ──────────────────────────────────────────
show_menu() {
    if power_on; then
        power="Power: on"
        devices=$(bluetoothctl devices | grep Device | cut -d ' ' -f 3-)
        scan=$(scan_on)
        pairable=$(pairable_on)
        discoverable=$(discoverable_on)
        options="$devices\n$divider\n$power\n$scan\n$pairable\n$discoverable\nExit"
    else
        power="Power: off"
        options="$power\nExit"
    fi

    chosen="$(echo -e "$options" | $rofi_command "Bluetooth")"

    case "$chosen" in
        "" | "$divider") ;;
        "$power")        toggle_power ;;
        "$scan")         toggle_scan ;;
        "$discoverable") toggle_discoverable ;;
        "$pairable")     toggle_pairable ;;
        *)
            device=$(bluetoothctl devices | grep "$chosen")
            [[ $device ]] && device_menu "$device"
            ;;
    esac
}

# ── Entry point ────────────────────────────────────────
rofi_command="rofi -dmenu $* -p"

case "$1" in
    --status) print_status ;;
    *)        show_menu ;;
esac
