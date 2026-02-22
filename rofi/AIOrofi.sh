=#!/usr/bin/env bash

# Path to fd binary
FD_BIN=$(command -v fd || command -v fdfind)

# --- 1. HANDLE THE FINAL ACTION ---
if [[ "$@" == "Search Web for "* ]]; then
    QUERY=$(echo "$@" | sed 's/Search Web for //')
    google-chrome-stable "https://www.google.com/search?q=$QUERY" > /dev/null 2>&1 &
    exit 0
elif [[ "$@" == "Open File" || "$@" == "Open Folder" ]]; then
    FILE=$(cat /tmp/rofi-file-path)
    coproc ( xdg-open "$FILE" > /dev/null 2>&1 )
    exit 0
elif [[ "$@" == "Open in Thunar" ]]; then
    FILE=$(cat /tmp/rofi-file-path)
    coproc ( thunar "$(dirname "$FILE")" > /dev/null 2>&1 )
    exit 0
elif [[ "$@" == "Open in Terminal" ]]; then
    FILE=$(cat /tmp/rofi-file-path)
    coproc ( kitty --directory "$FILE" > /dev/null 2>&1 )
    exit 0
elif [[ "$@" == Copy* ]]; then
    RESULT=$(echo "$@" | sed 's/Copy \(.*\) to clipboard/\1/')
    echo -n "$RESULT" | wl-copy
    exit 0
fi

# --- 2. HANDLE THE SELECTION (Step 2) ---
if [[ "$@" == /* ]]; then
    echo "$@" > /tmp/rofi-file-path
    if [[ -d "$@" ]]; then
        echo -e "Open Folder\0icon\x1ffolder-blue"
        echo -e "Open in Terminal\0icon\x1futilities-terminal"
    else
        echo -e "Open File\0icon\x1fdocument-open"
        echo -e "Open in Thunar\0icon\x1ffolder-blue"
    fi
    exit 0
fi

# --- 3. SEARCH LOGIC ---
if [ ! -z "$1" ]; then
    QUERY="$1"
    RESULTS_BUFFER=""
    FOUND_COUNT=0

    # A. CALCULATOR LOGIC
    if [[ "$QUERY" =~ ^[0-9\(\.\-] ]]; then
        CALC_RESULT=$(echo "scale=2; $QUERY" | bc -l 2>/dev/null)
        if [ ! -z "$CALC_RESULT" ] && [ "$CALC_RESULT" != "0" ]; then
            RESULTS_BUFFER+="Copy $CALC_RESULT to clipboard\0icon\x1fcalc\n"
            ((FOUND_COUNT++))
        fi
    fi

    # B. FILE & FOLDER SEARCH
    FILE_RESULTS=$($FD_BIN -H "$QUERY" /home/coolboi /home/coolboi/.config \
        --absolute-path --color never \
        --exclude "**/ble.sh/*" --exclude "**/ble/*" \
        --exclude "**/.git/*" --exclude "**/.cache/*" --exclude "**/node_modules/*" \
        --exclude "**/.trash/*" --exclude "**/go/*" --exclude "**/kate/*" \
        --exclude "**/KDE/*" --exclude "**/google-chrome/*" --exclude "**/chromium/*" \
        --exclude "**/BraveSoftware/*" --exclude "**/mozilla/*" --exclude "**/Code/Cache*" \
        --exclude "**/Code/CachedData*" --exclude "**/Code/User/workspaceStorage/*" \
        --exclude "**/Electron/*" --exclude "**/libaccounts-glib/*" --exclude "**/systemd/*" \
        --exclude "**/libreoffice/*" --exclude "**/gtk-3.0/*" --exclude "**/gtk-4.0/*" \
        --exclude "**/target/*" --exclude "**/.cargo/registry/*" --exclude "**/.cargo/git/*" \
        --exclude "**/far/*" --exclude "**/*.bak" \
        --exclude "**/*.pyc" --exclude "**/*.lock" --exclude "**/*.bin" | sort -u | head -n 8)

    if [ ! -z "$FILE_RESULTS" ]; then
        while read -r line; do
            if [[ -d "$line" ]]; then
                RESULTS_BUFFER+="$line\0icon\x1ffolder-blue\n"
            else
                RESULTS_BUFFER+="$line\0icon\x1ftext-x-generic\n"
            fi
            ((FOUND_COUNT++))
        done <<< "$FILE_RESULTS"
    fi

    # C. OUTPUT LOGIC
    if [ $FOUND_COUNT -eq 0 ]; then
        echo -e "Search Web for $QUERY\0icon\x1fgoogle-chrome"
    else
        echo -ne "$RESULTS_BUFFER"
        echo -e "Search Web for $QUERY\0icon\x1fgoogle-chrome"
    fi
fi
