#!/usr/bin/env bash
# The Rosé Pine colours this bar actually uses, shared by sketchybarrc and every plugin.
# Upstream palette: https://rosepinetheme.com/palette. Pull another colour from there when an
# item needs one; don't mirror the whole palette here just in case.
# SketchyBar cannot follow the OS appearance, so this stays dark.
#
# config/waybar/style.css carries the same tokens under the same names, so the two bars stay
# in step. Change a role here, change it there.

# Chrome. A fixed, opaque, full-width strip in Rosé Pine base, square corners, no item chrome at
# all: items sit straight on the bar and state is carried by colour alone. The only rule drawn
# anywhere is the divider between two items in the same cluster.
#
# BAR is base rather than true black, which is a deliberate trade. Black was seamless with the
# notch housing; base is the theme's own background and reads as Rosé Pine, at the cost of the
# notch showing as a slightly darker rectangle. base is dark enough that the seam is faint.
export BAR=0xff191724    # base - the bar itself
export BORDER=0xff403d52 # highlight med - the divider between items in one cluster. Overlay is the
                         # usual choice but sits at 1.16:1 on base, invisible; this is 1.69:1.

# Text, dimmest to brightest. The workspace ramp is empty -> occupied -> focused, and every step
# stays legible against base: 3.4:1, 5.5:1, 8.4:1.
export MUTED=0xff6e6a86  # muted - empty workspace, and a muted or unavailable item
export SUBTLE=0xff908caa # subtle - occupied but unfocused workspace, and the focused-app item
export FG=0xffe0def4     # text - the resting state of every label

# Accents. One hue per metric so the right cluster reads as distinct fields at a glance,
# plus the two that mean "look at me".
export ACCENT=0xffc4a7e7 # iris - focused workspace, cpu
export ROSE=0xffebbcba   # rose - volume
export GREEN=0xff9ccfd8  # foam - memory, and charging. Rosé Pine has no green; foam carries the
                         # "all good" role, because pine is too dark to read against the black bar.
export YELLOW=0xfff6c177 # gold - clock and date at rest, and the warning threshold
export RED=0xffeb6f92    # love - critical threshold
