#!/bin/bash
set -euo pipefail

echo "Configuring general settings..."

defaults write -g AppleMetricUnits -bool true

echo "Configuring keyboard..."

# Disable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Fast key repeat rate after a short initial delay
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

echo "Configuring Dock..."

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Position Dock on the left
defaults write com.apple.dock orientation -string "left"

# Don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Set up Dock apps
add_dock_app() {
  if [ -d "$1" ]; then
    defaults write com.apple.dock persistent-apps -array-add \
      "<dict>
        <key>tile-data</key>
        <dict>
          <key>file-data</key>
          <dict>
            <key>_CFURLString</key>
            <string>$1</string>
            <key>_CFURLStringType</key>
            <integer>0</integer>
          </dict>
        </dict>
      </dict>"
    echo "Added $(basename "$1") to Dock"
  fi
}

defaults write com.apple.dock persistent-apps -array

add_dock_app "/Applications/Google Chrome.app"
add_dock_app "/Applications/Claude.app"
add_dock_app "/Applications/WezTerm.app"
add_dock_app "/Applications/DevPod.app"
add_dock_app "/Applications/OrbStack.app"
add_dock_app "$HOME/Applications/Rider.app"
add_dock_app "$HOME/Applications/RustRover.app"
add_dock_app "/Applications/Xcode.app"

echo "Configuring Finder..."

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# TODO: Configure the default view in the finder 
# defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "Configuring trackpad..."

# Set tap to click and three finger drag
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

echo "Restarting affected applications..."

for app in "Dock" "Finder" "SystemUIServer"; do
    killall "$app" &>/dev/null || true
done

echo "Done! Some changes may require a logout/restart to take effect."

