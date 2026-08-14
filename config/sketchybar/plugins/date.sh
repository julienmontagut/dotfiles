#!/usr/bin/env bash

sketchybar --set "$NAME" label="$(LC_TIME=fr_FR.UTF-8 date '+%a %d %b %H:%M')"
