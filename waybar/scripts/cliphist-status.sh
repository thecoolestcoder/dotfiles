#!/bin/bash
# Check if cliphist has any items
if [ "$(cliphist list | wc -l)" -gt 0 ]; then
    # Full Clipboard Icon
    echo '{"text": "󰃢", "class": "full"}'
else
    # Empty Clipboard Icon
    echo '{"text": "󰅊", "class": "empty"}'
fi