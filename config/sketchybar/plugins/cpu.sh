#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

NUM_CORES=$(sysctl -n hw.ncpu)
CPU_USAGE=$(ps -A -o %cpu | awk -v cores="$NUM_CORES" '{s+=$1} END {printf "%.0f", s/cores}')

if [ "$CPU_USAGE" -gt 80 ]; then
    COLOR="$RED"
elif [ "$CPU_USAGE" -gt 50 ]; then
    COLOR="$YELLOW"
else
    COLOR="$FG"
fi

sketchybar --set "$NAME" label="${CPU_USAGE}%" label.color="$COLOR"
