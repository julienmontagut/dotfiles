#!/bin/bash
# The macOS setup mise can't express declaratively. The scalar preferences live in
# config.macos.toml. Run by [tasks.bootstrap] during `mise bootstrap`.
set -euo pipefail

# Disable Ctrl+Space input source switching, which conflicts with the terminal leader keys.
# Key 60 = previous input source, key 61 = next input source.
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

