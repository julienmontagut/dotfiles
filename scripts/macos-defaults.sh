#!/bin/sh

echo "Error this is meant to be migrated to nix. Do not use"
exit -1

# User home folder
#
chflags nohidden ~/Library
if [ ! -d $HOME/Developer ]; then
    mkdir $HOME/Developer
fi

# Global settings
#
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true

# Menu bar
#
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true

# Finder
#
defaults write com.apple.Finder ShowSidebar -bool true
defaults write com.apple.Finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.Finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.Finder FXEnableRemoveFromICloudDriveWarning -bool false
defaults write com.apple.Finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.Finder FXRemoveOldTrashItems -bool true
defaults write com.apple.Finder WarnOnEmptyTrash -bool false
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Terminal
#
defaults write com.apple.Terminal "Default Window Settings" -string "Ocean"
defaults write com.apple.Terminal "Startup Window Settings" -string "Ocean"

killall Finder
killall Dock
