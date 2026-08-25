#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

# $INFO is the new percentage on volume_change. Unset on the --update pass at startup, so ask
# CoreAudio ourselves then - one osascript fork at launch and none afterwards.
VOLUME="${INFO:-$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)}"
MUTED_STATE=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)

# No output device, or osascript gave us nothing - drop the item rather than draw a lie.
if [ -z "$VOLUME" ] || [ "$VOLUME" = "missing value" ]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

if [ "$MUTED_STATE" = "true" ] || [ "$VOLUME" -eq 0 ]; then
    ICON="$ICON_VOL_MUTE"
    COLOR="$MUTED"
elif [ "$VOLUME" -gt 66 ]; then
    ICON="$ICON_VOL_HIGH"
    COLOR="$ROSE"
elif [ "$VOLUME" -gt 33 ]; then
    ICON="$ICON_VOL_MID"
    COLOR="$ROSE"
else
    ICON="$ICON_VOL_LOW"
    COLOR="$ROSE"
fi

sketchybar --set "$NAME" drawing=on \
    icon="$ICON" \
    icon.color="$COLOR" \
    label="${VOLUME}%" \
    label.color="$COLOR"
