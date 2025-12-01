#!/bin/bash

# Tokyo Night Storm colors
BLUE=0xff7aa2f7
GRAY=0xff565f89
FG=0xffc0caf5

# Get list of apps in this workspace
APPS=$(aerospace list-windows --workspace "$1" --format "%{app-name}" | sort -u)

# Count apps
APP_COUNT=$(echo "$APPS" | grep -v '^$' | wc -l | tr -d ' ')

# Build label with workspace number and app count
if [ "$APP_COUNT" -gt 0 ]; then
  LABEL="$1 [$APP_COUNT]"
else
  LABEL="$1"
fi

# Highlight if focused, always show
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.color=$BLUE \
    background.height=3 \
    background.y_offset=-14 \
    background.drawing=on \
    label.color=$FG \
    label="$LABEL"
else
  sketchybar --set "$NAME" \
    background.color=$GRAY \
    background.height=3 \
    background.y_offset=-14 \
    background.drawing=on \
    label.color=$FG \
    label="$LABEL"
fi
