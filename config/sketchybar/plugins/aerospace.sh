#!/usr/bin/env bash

# Tokyo Night Storm colors
BLUE=0xff7aa2f7
GRAY=0xff565f89

# Workspace ID passed as argument
WORKSPACE_ID="$1"

# Map app names to nerd font icons
get_app_icon() {
  case "$1" in
    Alacritty|kitty|iTerm2|Terminal) echo $'\uf489' ;;
    Firefox|Firefox\ Developer\ Edition) echo $'\ue745' ;;
    Safari) echo $'\ue745' ;;
    Chrome|Google\ Chrome) echo $'\uf268' ;;
    Code|VSCode|Visual\ Studio\ Code) echo $'\ue70c' ;;
    GoLand|IntelliJ\ IDEA) echo $'\ue7b5' ;;
    Rider) echo $'\ue70c' ;;
    RustRover) echo $'\ue7a8' ;;
    Slack) echo $'\uf198' ;;
    Discord) echo $'\ufb6e' ;;
    Spotify) echo $'\uf1bc' ;;
    Mail|Thunderbird) echo $'\uf6ef' ;;
    Calendar) echo $'\uf073' ;;
    Notes) echo $'\uf249' ;;
    *) echo $'\uf15b' ;;
  esac
}

# Get list of unique apps in this workspace
APPS=$(aerospace list-windows --workspace "$WORKSPACE_ID" --format "%{app-name}" 2>/dev/null | sort -u)

# Build icon string
ICONS=""
while IFS= read -r app; do
  if [ -n "$app" ]; then
    ICON=$(get_app_icon "$app")
    ICONS="${ICONS}${ICON} "
  fi
done <<< "$APPS"

# Trim trailing space
ICONS="${ICONS% }"

# Build label with workspace number and app icons
if [ -n "$ICONS" ]; then
  LABEL="$WORKSPACE_ID $ICONS"
else
  LABEL="$WORKSPACE_ID"
fi

# Update label
sketchybar --set "$NAME" label="$LABEL"

# Highlight if focused (simple approach from official docs)
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" background.color="$BLUE"
else
  sketchybar --set "$NAME" background.color="$GRAY"
fi
