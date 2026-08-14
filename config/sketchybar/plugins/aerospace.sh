#!/usr/bin/env bash
# Paints one workspace item. $1 is the workspace id; $FOCUSED_WORKSPACE comes from the
# aerospace_workspace_change event (aerospace.toml's exec-on-workspace-change).
#
# Three states, carried by color alone: focused (accent), occupied (dim), empty (faint). The two
# resting states sit deliberately close to the background so the focused one is the only thing the
# eye lands on.

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

WORKSPACE_ID="$1"

# $FOCUSED_WORKSPACE is unset on the --update pass at startup (the event hasn't fired yet), so
# resolve it ourselves then. Costs one extra fork at launch and nothing on subsequent events.
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

ICONS=""
while IFS= read -r app; do
    [ -n "$app" ] && ICONS="$ICONS$(app_icon "$app") "
done <<<"$(aerospace list-windows --workspace "$WORKSPACE_ID" --format "%{app-name}" 2>/dev/null | sort -u)"
ICONS="${ICONS% }"

if [ "$WORKSPACE_ID" = "$FOCUSED" ]; then
    COLOR="$ACCENT"
elif [ -n "$ICONS" ]; then
    COLOR="$DIM"
else
    COLOR="$FAINT"
fi

# The workspace glyph stays in the item's icon; the label carries its apps, falling back to the
# workspace name so an empty workspace is still identifiable.
sketchybar --set "$NAME" \
    label="${ICONS:-$WORKSPACE_ID}" \
    icon.color="$COLOR" \
    label.color="$COLOR"
