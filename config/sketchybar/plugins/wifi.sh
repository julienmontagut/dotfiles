#!/bin/bash

# Find the WiFi interface (usually en0, but could be different)
WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

if [ -z "$WIFI_DEVICE" ]; then
  WIFI_DEVICE="en0"
fi

# Get the WiFi status
WIFI_STATUS=$(networksetup -getairportnetwork "$WIFI_DEVICE" 2>/dev/null)

if echo "$WIFI_STATUS" | grep -q "Current Wi-Fi Network:"; then
  SSID=$(echo "$WIFI_STATUS" | sed 's/Current Wi-Fi Network: //')
  sketchybar --set wifi icon=󰖩 label="$SSID"
else
  sketchybar --set wifi icon=󰖪 label="Disconnected"
fi
