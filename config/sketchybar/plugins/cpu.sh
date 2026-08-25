#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

NUM_CORES=$(sysctl -n hw.ncpu)
CPU_USAGE=$(ps -A -o %cpu | awk -v cores="$NUM_CORES" '{s+=$1} END {printf "%.0f", s/cores}')

# At rest the field keeps its own hue; a warning recolours icon and label together so the whole
# field changes, not just half of it.
if [ "$CPU_USAGE" -gt 80 ]; then
    COLOR="$RED"
elif [ "$CPU_USAGE" -gt 50 ]; then
    COLOR="$YELLOW"
else
    COLOR="$ACCENT"
fi

sketchybar --set "$NAME" label="${CPU_USAGE}%" label.color="$COLOR" icon.color="$COLOR"
