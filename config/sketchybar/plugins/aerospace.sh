#!/usr/bin/env bash
# Paints one workspace item. $1 is the workspace id; $FOCUSED_WORKSPACE comes from the
# aerospace_workspace_change event (aerospace.toml's exec-on-workspace-change).
#
# The item is a digit and nothing else, so all three states are carried by colour alone - there is
# no chrome on this bar to carry them any other way. focused (iris) / occupied (subtle) / empty
# (muted), which against base is 8.4:1 / 5.5:1 / 3.4:1: a clear ramp where even the resting states
# stay readable.

source "$HOME/.config/sketchybar/colors.sh"

WORKSPACE_ID="$1"

# $FOCUSED_WORKSPACE is unset on the --update pass at startup (the event hasn't fired yet), so
# resolve it ourselves then. Costs one extra fork at launch and nothing on subsequent events.
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

if [ "$WORKSPACE_ID" = "$FOCUSED" ]; then
    COLOR="$ACCENT"
elif [ -n "$(aerospace list-windows --workspace "$WORKSPACE_ID" --format '%{window-id}' 2>/dev/null)" ]; then
    COLOR="$SUBTLE"
else
    COLOR="$MUTED"
fi

sketchybar --set "$NAME" icon.color="$COLOR"
