#!/usr/bin/env bash

# Tokyo Night Storm colors
BLUE=0xff7aa2f7
RED=0xfff7768e

# Find the WiFi interface (usually en0, but could be different)
WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

if [ -z "$WIFI_DEVICE" ]; then
  WIFI_DEVICE="en0"
fi


# Get WiFi info using ipconfig (works better with recent macOS privacy changes)
WIFI_INFO=$(ipconfig getsummary "$WIFI_DEVICE" 2>/dev/null)

# Check if WiFi is connected by looking for LinkStatusActive and InterfaceType
if echo "$WIFI_INFO" | grep -q "LinkStatusActive : TRUE" && echo "$WIFI_INFO" | grep -q "InterfaceType : WiFi"; then
    sketchybar --set "$NAME" icon=󰖩 icon.color="$BLUE" label=""
else
  # WiFi is not active - red icon
  sketchybar --set "$NAME" icon=󰖪 icon.color="$RED" label=""
fi
