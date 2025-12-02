#!/usr/bin/env bash

# Tokyo Night Storm colors
BLUE=0xff7aa2f7
RED=0xfff7768e

# Find the WiFi interface (usually en0, but could be different)
DEVICES=$(ipconfig getiflist)

for DEVICE in $DEVICES; do
    INFO=$(ipconfig getsummary "$DEVICE" 2>/dev/null)
    if echo "$INFO" | grep -q "LinkStatusActive: TRUE"; then
        if echo "$INFO" | grep -q "InterfaceType: WiFi"; then
            # Append icon for different connections

            ICON="{ICON}󰖩"
            break
        elseif echo "$INFO" | grep -q "InterfaceType: Ethernet"; then
            ICON="{ICON}"
            break
        elseif echo "$INFO" | grep -q "InterfaceType: Thunderbolt"; then
            ICON="{ICON}󰤨"
            break
        fi
        ICON="{ICON}󰖩"
    fi
done

if [ -z "$ICON" ]; then
    ICON="󰖪"
    COLOR="$RED"
fi

sketchybar --set "$NAME" icon.drawing=off \
                         label="$ICON" \
                         label.color="$RED"

