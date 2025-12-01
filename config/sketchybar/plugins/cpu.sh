#!/bin/bash

# Get number of CPU cores
NUM_CORES=$(sysctl -n hw.ncpu)

# Get total CPU usage and divide by number of cores
CPU_USAGE=$(ps -A -o %cpu | awk -v cores="$NUM_CORES" '{s+=$1} END {printf "%.0f", s/cores}')

sketchybar --set cpu label="${CPU_USAGE}%"
