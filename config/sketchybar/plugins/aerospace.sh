#!/bin/bash

# Tokyo Night Storm colors
BLUE=0xff7aa2f7
GRAY=0xff565f89
FG=0xffc0caf5

# Workspace ID passed as argument
WORKSPACE_ID="$1"

# If FOCUSED_WORKSPACE is not set, get it from aerospace
if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

# Map app names to nerd font icons
get_app_icon() {
  case "$1" in
    Alacritty|kitty|iTerm2|Terminal) printf "\uf489" ;;
    Firefox|Firefox\ Developer\ Edition) printf "\ue745" ;;
    Safari) printf "\ue745" ;;
    Chrome|Google\ Chrome) printf "\uf268" ;;
    Code|VSCode|Visual\ Studio\ Code) printf "\ue70c" ;;
    GoLand|IntelliJ\ IDEA) printf "\ue7b5" ;;
    Rider) printf "\ue70c" ;;
    RustRover) printf "\ue7a8" ;;
    Slack) printf "\uf198" ;;
    Discord) printf "\ufb6e" ;;
    Spotify) printf "\uf1bc" ;;
    Mail|Thunderbird) printf "\uf6ef" ;;
    Calendar) printf "\uf073" ;;
    Notes) printf "\uf249" ;;
    *) printf "\uf15b" ;;
  esac
}

# Get list of unique apps in this workspace
APPS=$(aerospace list-windows --workspace "$WORKSPACE_ID" --format "%{app-name}" | sort -u)

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

# Highlight if focused, always show
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.color=$BLUE \
    background.height=3 \
    background.y_offset=-16 \
    background.drawing=on \
    label.color=$FG \
    label="$LABEL"
else
  sketchybar --set "$NAME" \
    background.color=$GRAY \
    background.height=3 \
    background.y_offset=-16 \
    background.drawing=on \
    label.color=$FG \
    label="$LABEL"
fi
