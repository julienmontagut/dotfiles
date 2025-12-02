#!/usr/bin/env bash

# Tokyo Night Storm colors
GREEN=0xff9ece6a
YELLOW=0xffe0af68
RED=0xfff7768e

# Get number of CPU cores
NUM_CORES=$(sysctl -n hw.ncpu)

# Get total CPU usage and divide by number of cores
CPU_USAGE=$(ps -A -o %cpu | awk -v cores="$NUM_CORES" '{s+=$1} END {printf "%.0f", s/cores}')

# Determine color based on usage
if [ "$CPU_USAGE" -gt 80 ]; then
  COLOR="$RED"
elif [ "$CPU_USAGE" -gt 50 ]; then
  COLOR="$YELLOW"
else
  COLOR="$GREEN"
fi

sketchybar --set "$NAME" icon.color="$COLOR" \
                         background.color="$COLOR" \
                         label="${CPU_USAGE}%"
