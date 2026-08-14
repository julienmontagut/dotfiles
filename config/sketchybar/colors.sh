#!/usr/bin/env bash
# The Basalt Dark colours this bar actually uses, shared by sketchybarrc and every plugin.
# Upstream palette: config/ghostty/themes/basalt-dark, plus the grey ramp from
# config/nvim/colors/basalt.lua that the terminal themes don't carry. Pull another colour from
# there when an item needs one; don't mirror the whole palette here just in case.

# Surfaces, darkest to lightest
export BAR=0xff000000   # true black and fully opaque, so the bar is seamless with the notch band
export FAINT=0xff252626 # basalt selection grey - empty workspace, barely there on purpose
export DIM=0xff3e3e44   # bright black - occupied but unfocused workspace
export MUTED=0xff767575 # comment grey - the resting state of the right cluster's icons
export FG=0xffe7e5e5    # foreground - the resting state of every label

# Accents. Only three, and only two of them mean "look at me".
export ACCENT=0xff96b4e0 # basalt primary blue (nvim Function/Title) - focused workspace
export GREEN=0xff5eb88a  # charging
export YELLOW=0xffd4a656 # warning threshold
export RED=0xffd47080    # critical threshold
