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
  # Try to get SSID from ipconfig (might be redacted in newer macOS)
  SSID=$(echo "$WIFI_INFO" | awk -F ' : ' '/^[[:space:]]*SSID :/ {print $2}' | xargs)

  # If SSID is redacted or empty, try networksetup as fallback
  if [ -z "$SSID" ] || [ "$SSID" = "<redacted>" ]; then
    SSID=$(networksetup -getairportnetwork "$WIFI_DEVICE" 2>/dev/null | sed 's/Current Wi-Fi Network: //' | xargs)
    # If still can't get SSID, don't show label (just icon)
    if [ -z "$SSID" ] || echo "$SSID" | grep -q "not associated"; then
      SSID=""
    fi
  fi

  # Connected - blue icon
  if [ -n "$SSID" ]; then
    sketchybar --set "$NAME" icon=󰖩 icon.color="$BLUE" label="$SSID"
  else
    sketchybar --set "$NAME" icon=󰖩 icon.color="$BLUE" label=""
  fi
else
  # WiFi is not active - red icon
  sketchybar --set "$NAME" icon=󰖪 icon.color="$RED" label=""
fi
