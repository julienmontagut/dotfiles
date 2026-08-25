#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

# memory_pressure reports free %; we want used. awk coerces the trailing '%' away.
# Default to 0 so a format change on a future macOS degrades to a wrong number, not a broken item.
USED=$(memory_pressure | awk '/System-wide memory free percentage:/ {print 100-$5}')
USED=${USED:-0}

if [ "$USED" -gt 80 ]; then
    COLOR="$RED"
elif [ "$USED" -gt 50 ]; then
    COLOR="$YELLOW"
else
    COLOR="$GREEN"
fi

sketchybar --set "$NAME" label="${USED}%" label.color="$COLOR" icon.color="$COLOR"
