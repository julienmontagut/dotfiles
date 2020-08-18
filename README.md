# My custom dotfiles

Dotfiles to personalize system

## Installation

1. Clone this repository `git clone git@github.com:julienmontagut/dotfiles`
2. Run `install.sh`

## Structure

This repository contains the following folders
 - `./settings`: application settings
 - `./store`: application data stores, may store user data

### Compatibility with XDG dirs
XDG_CACHE_HOME is set to ~/.cache
XDG_CONFIG_HOME is set to `$DOTFILES/settings`, ~/.config may be simlinked to the same
XDG_CONFIG_HOME is set to `$DOTFILES/stores`, ~/.local/share may be simlinked to the same
