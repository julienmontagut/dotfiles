#!/bin/bash
# macOS system defaults configuration
# Run this script to apply preferred system settings

set -euo pipefail

echo "Applying macOS defaults..."

# =============================================================================
# Keyboard
# =============================================================================

echo "Configuring keyboard..."

# Fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1

# Short delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Use metric units
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# =============================================================================
# Dock
# =============================================================================

echo "Configuring Dock..."

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Position Dock on the left
defaults write com.apple.dock orientation -string "left"

# Don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Speed up Dock auto-hide animation
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3

# =============================================================================
# Finder
# =============================================================================

echo "Configuring Finder..."

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use column view by default
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# =============================================================================
# Trackpad
# =============================================================================

echo "Configuring trackpad..."

# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Three finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# =============================================================================
# Screenshots
# =============================================================================

echo "Configuring screenshots..."

# Save screenshots to ~/Pictures/Screenshots
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

# Save screenshots as PNG
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# =============================================================================
# Other
# =============================================================================

echo "Configuring other settings..."

# Disable natural scrolling (optional - comment out if you prefer natural)
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# =============================================================================
# Kill affected applications
# =============================================================================

echo "Restarting affected applications..."

for app in "Dock" "Finder" "SystemUIServer"; do
    killall "$app" &>/dev/null || true
done

echo "Done! Some changes may require a logout/restart to take effect."
