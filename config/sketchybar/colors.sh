#!/usr/bin/env bash
# The Rosé Pine colours this bar actually uses, shared by sketchybarrc and every plugin.
# Upstream palette: https://rosepinetheme.com/palette. Pull another colour from there when an
# item needs one; don't mirror the whole palette here just in case.
# Swap in the Dawn block below for the light variant; BAR stays black either way.

# Surfaces, darkest to lightest
export BAR=0xff000000   # true black and fully opaque, so the bar is seamless with the notch band
export FAINT=0xff26233a # overlay - empty workspace, barely there on purpose
export DIM=0xff403d52   # highlight med - occupied but unfocused workspace
export MUTED=0xff6e6a86 # muted - the resting state of the right cluster's icons
export FG=0xffe0def4    # text - the resting state of every label

# Accents. Only three, and only two of them mean "look at me".
export ACCENT=0xffc4a7e7 # iris - focused workspace
export GREEN=0xff9ccfd8  # charging. Rosé Pine has no green; foam carries the "all good" role,
                         # because pine is too dark to read against the black bar.
export YELLOW=0xfff6c177 # gold - warning threshold
export RED=0xffeb6f92    # love - critical threshold

# Rosé Pine Dawn
# export FAINT=0xfff2e9e1
# export DIM=0xffdfdad9
# export MUTED=0xff9893a5
# export FG=0xff575279
# export ACCENT=0xff907aa9
# export GREEN=0xff56949f
# export YELLOW=0xffea9d34
# export RED=0xffb4637a

# Basalt Dark
# export FAINT=0xff252626
# export DIM=0xff3e3e44
# export MUTED=0xff767575
# export FG=0xffe7e5e5
# export ACCENT=0xff96b4e0
# export GREEN=0xff5eb88a
# export YELLOW=0xffd4a656
# export RED=0xffd47080
