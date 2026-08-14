#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

STATUS=$(pmset -g batt)
PERCENTAGE=$(echo "$STATUS" | grep -Eo "[0-9]+%" | head -1 | cut -d% -f1)

# No battery (desktop Mac, or pmset gave us nothing) - drop the item rather than draw a lie.
if [ -z "$PERCENTAGE" ]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

if echo "$STATUS" | grep -q 'AC Power'; then
    COLOR="$GREEN"
    if [ "$PERCENTAGE" -gt 80 ]; then ICON="$ICON_CHG_100"
    elif [ "$PERCENTAGE" -gt 60 ]; then ICON="$ICON_CHG_80"
    elif [ "$PERCENTAGE" -gt 40 ]; then ICON="$ICON_CHG_60"
    elif [ "$PERCENTAGE" -gt 20 ]; then ICON="$ICON_CHG_40"
    else ICON="$ICON_CHG_20"
    fi
else
    if [ "$PERCENTAGE" -gt 80 ]; then
        ICON="$ICON_BAT_100"
        COLOR="$MUTED"
    elif [ "$PERCENTAGE" -gt 60 ]; then
        ICON="$ICON_BAT_80"
        COLOR="$MUTED"
    elif [ "$PERCENTAGE" -gt 40 ]; then
        ICON="$ICON_BAT_60"
        COLOR="$MUTED"
    elif [ "$PERCENTAGE" -gt 20 ]; then
        ICON="$ICON_BAT_40"
        COLOR="$YELLOW"
    elif [ "$PERCENTAGE" -gt 10 ]; then
        ICON="$ICON_BAT_20"
        COLOR="$YELLOW"
    else
        ICON="$ICON_BAT_0"
        COLOR="$RED"
    fi
fi

sketchybar --set "$NAME" drawing=on \
    icon="$ICON" \
    icon.color="$COLOR" \
    label="${PERCENTAGE}%"
