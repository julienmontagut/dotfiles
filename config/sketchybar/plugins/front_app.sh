#!/bin/bash

# Get the front app name
FRONT_APP=$(aerospace list-windows --focused --format "%{app-name}")

# Update the bar
if [ -n "$FRONT_APP" ]; then
  sketchybar --set front_app label="$FRONT_APP"
else
  sketchybar --set front_app label="Desktop"
fi
