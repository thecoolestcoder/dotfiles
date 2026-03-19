#!/bin/bash
LOCK_FILE="/home/coolboi/.config/swaync/scripts/.caffeine_active"
INHIBIT_PID_FILE="/home/coolboi/.config/swaync/scripts/.caffeine_pid"

if [ -f "$LOCK_FILE" ]; then
  # Turn off: kill the inhibitor process and clean up
  if [ -f "$INHIBIT_PID_FILE" ]; then
    kill "$(cat "$INHIBIT_PID_FILE")" 2>/dev/null
    rm -f "$INHIBIT_PID_FILE"
  fi
  rm -f "$LOCK_FILE"
else
  # Turn on: run systemd-inhibit in background, keep PID
  systemd-inhibit --what=idle:sleep --who="Caffeine" --why="User requested" --mode=block \
    sleep infinity &
  echo $! >"$INHIBIT_PID_FILE"
  touch "$LOCK_FILE"
fi
