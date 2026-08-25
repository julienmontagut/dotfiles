#!/usr/bin/env bash
# Nerd Fonts v3 glyphs (Lilex Nerd Font Mono), named once so no other file carries a bare literal.
#
# Glyphs are literal UTF-8, not $'\uXXXX': macOS /bin/bash is 3.2, and ANSI-C \u escapes only
# landed in bash 4.2 - they would come out as the literal text "\uf268". The codepoint and Nerd
# Fonts name live in the trailing comment instead. Every codepoint below is present in
# LilexNerdFontMono-Regular.ttf; re-check the cmap before adding one.

# Workspaces carry no glyph: they are named by position, 1 to 5, in both sketchybarrc and waybar,
# and scratch is drawn as a plain dash. Nothing here to name.

# --- left cluster ---
export ICON_CLOCK=󰅐 # U+F0150 nf-md-clock_outline
export ICON_CAL=󰃭 # U+F00ED nf-md-calendar

# --- centre ---
export ICON_APP=󰖸 # U+F05B8 nf-md-application

# --- right cluster ---
export ICON_CPU=󰻠 # U+F0EE0 nf-md-cpu_64_bit
export ICON_RAM=󰍛 # U+F035B nf-md-memory
export ICON_DATE=󰃰 # U+F00F0 nf-md-calendar_clock
export ICON_WIFI=󰖩 # U+F05A9 nf-md-wifi
export ICON_WIFI_OFF=󰖪 # U+F05AA nf-md-wifi_off

# --- volume ramp, lowest to highest; see volume.sh ---
export ICON_VOL_MUTE=󰝟 # U+F075F nf-md-volume_off
export ICON_VOL_LOW=󰕿 # U+F057F nf-md-volume_low
export ICON_VOL_MID=󰖀 # U+F0580 nf-md-volume_medium
export ICON_VOL_HIGH=󰕾 # U+F057E nf-md-volume_high

# --- battery ramps, lowest to highest; see battery.sh ---
export ICON_BAT_0=󰂎 # U+F008E nf-md-battery_outline
export ICON_BAT_20=󰁻 # U+F007B nf-md-battery_20
export ICON_BAT_40=󰁽 # U+F007D nf-md-battery_40
export ICON_BAT_60=󰁿 # U+F007F nf-md-battery_60
export ICON_BAT_80=󰂁 # U+F0081 nf-md-battery_80
export ICON_BAT_100=󰁹 # U+F0079 nf-md-battery
export ICON_CHG_20=󰂆 # U+F0086 nf-md-battery_charging_20
export ICON_CHG_40=󰂈 # U+F0088 nf-md-battery_charging_40
export ICON_CHG_60=󰂉 # U+F0089 nf-md-battery_charging_60
export ICON_CHG_80=󰂊 # U+F008A nf-md-battery_charging_80
export ICON_CHG_100=󰂅 # U+F0085 nf-md-battery_charging_100
