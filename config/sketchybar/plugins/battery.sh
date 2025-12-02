#!/usr/bin/env bash

# Tokyo Night Storm colors
GREEN=0xff9ece6a
YELLOW=0xffe0af68
RED=0xfff7768e

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

# Determine icon
if [ -n "$CHARGING" ]; then
  ICON=""
else
  if [ "$PERCENTAGE" -gt 80 ]; then
    ICON=""
  elif [ "$PERCENTAGE" -gt 60 ]; then
    ICON=""
  elif [ "$PERCENTAGE" -gt 40 ]; then
    ICON=""
  elif [ "$PERCENTAGE" -gt 20 ]; then
    ICON=""
  else
    ICON=""
  fi
fi

# Determine color based on charge level
if [ "$PERCENTAGE" -gt 50 ]; then
  COLOR="$GREEN"
elif [ "$PERCENTAGE" -gt 20 ]; then
  COLOR="$YELLOW"
else
  COLOR="$RED"
fi

sketchybar --set "$NAME" icon="$ICON" \
                         icon.color="$COLOR" \
                         background.color="$COLOR" \
                         label="${PERCENTAGE}%"
