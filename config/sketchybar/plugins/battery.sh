#!/usr/bin/env bash

# Tokyo Night Storm colors
GREEN=0xff9ece6a
YELLOW=0xffe0af68
RED=0xfff7768e

STATUS=$(pmset -g batt)

PERCENTAGE=$(echo $STATUS | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo $STATUS | grep 'AC Power')

# Determine icon
if [ -n "$CHARGING" ]; then
  ICON=""
else
  if [ "$PERCENTAGE" -gt 80 ]; then
    ICON=""
    COLOR="$GREEN"
  elif [ "$PERCENTAGE" -gt 60 ]; then
    ICON=""
    COLOR="$GREEN"
  elif [ "$PERCENTAGE" -gt 40 ]; then
    ICON=""
    COLOR="$YELLOW"
  elif [ "$PERCENTAGE" -gt 20 ]; then
    ICON=""
    COLOR="$YELLOW"
  else
    ICON=""
    COLOR="$RED"
  fi
fi

sketchybar --set "$NAME" icon="$ICON" \
                         icon.color="$COLOR" \
                         background.color="$COLOR" \
                         label="${PERCENTAGE}%"
