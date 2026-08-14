#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

# Wi-Fi is en0 on every Apple Silicon Mac, but ask rather than assume - a Thunderbolt dock or a
# USB ethernet adapter can reorder the interfaces.
WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
SUMMARY=$(ipconfig getsummary "${WIFI_DEVICE:-en0}" 2>/dev/null)

if echo "$SUMMARY" | grep -q "LinkStatusActive : TRUE" &&
    echo "$SUMMARY" | grep -q "InterfaceType : WiFi"; then
    sketchybar --set "$NAME" icon="$ICON_WIFI" icon.color="$MUTED"
else
    sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" icon.color="$RED"
fi
