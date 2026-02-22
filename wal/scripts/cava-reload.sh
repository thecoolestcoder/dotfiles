#!/bin/sh
# ~/.config/wal/scripts/cava-reload.sh
cp ~/.cache/wal/colors-cava.conf ~/.config/cava/config
pkill -USR2 cava  # Sends SIGUSR2 to reload cava without restarting
