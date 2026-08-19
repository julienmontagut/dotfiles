#!/bin/bash
# The macOS setup mise can't express declaratively: [bootstrap.macos.defaults] writes scalars
# only, so the Dock's app array and the symbolic-hotkey dict need `defaults` calls, and TouchID
# needs a root-owned file under /etc/pam.d. The scalar preferences live in config.macos.toml.
# Run by [tasks.bootstrap] during `mise bootstrap` (macOS only).
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

# TouchID for sudo.
pam_file="/etc/pam.d/sudo_local"
if [[ -f "$pam_file" ]] && grep -q "pam_tid.so" "$pam_file" 2>/dev/null; then
  echo "TouchID for sudo already configured."
else
  echo "Creating $pam_file (requires sudo)..."
  sudo tee "$pam_file" >/dev/null <<'EOF'
# sudo_local: local config file which survives system update
auth       sufficient     pam_tid.so
EOF
  echo "TouchID for sudo enabled."
fi

echo "Done! Some changes may require a logout/restart to take effect."
