#!/bin/bash

# Use French locale for date
DATE=$(LC_TIME=fr_FR.UTF-8 date '+%a %d %b %H:%M')

sketchybar --set date label="$DATE" label.align=center
