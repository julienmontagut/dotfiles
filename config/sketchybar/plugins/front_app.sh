#!/bin/bash

# Get the front app name
FRONT_APP=$(aerospace list-windows --focused --format "%{app-name}")

# Update the bar - hide if no focused app
if [ -n "$FRONT_APP" ]; then
  sketchybar --set front_app label="$FRONT_APP" drawing=on
else
  sketchybar --set front_app drawing=off
fi
