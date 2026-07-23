#!/bin/bash
# The macOS defaults that don't fit mise's [bootstrap.macos.defaults] (scalar) section:
# a disabled hotkey pair and the Dock's app list. The plain scalar preferences live in
# mise.toml. Run by [tasks.bootstrap] during `mise bootstrap` (macOS only).
set -euo pipefail

# Disable Ctrl+Space input source switching (conflicts with terminal leader keys).
# Key 60 = "Select the previous input source", Key 61 = "Select next source in Input menu".
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# Dock apps: reset the list, then add the ones that exist.
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
add_dock_app "/Applications/Ghostty.app"
add_dock_app "/Applications/DevPod.app"
add_dock_app "/Applications/OrbStack.app"
add_dock_app "$HOME/Applications/Rider.app"
add_dock_app "$HOME/Applications/RustRover.app"
add_dock_app "/Applications/Xcode.app"

for app in "Dock" "Finder" "SystemUIServer"; do
    killall "$app" &>/dev/null || true
done

echo "Done! Some changes may require a logout/restart to take effect."
