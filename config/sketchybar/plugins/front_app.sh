#!/usr/bin/env bash
# The focused app's name, centred. $INFO comes from front_app_switched; it is unset on the
# --update pass at startup, so fall back to asking aerospace (already a hard dependency here).

APP="${INFO:-$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null | head -1)}"

# Nothing focused - an empty pill is worse than no pill.
if [ -z "$APP" ]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

sketchybar --set "$NAME" drawing=on label="$APP"
