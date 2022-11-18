#!/bin/sh
set -e

# Functions
###########

function help() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -h, --help                Display this help message"
  echo "  -d, --install-defaults    Install macOS defaults"
}

# Arguments
###########

while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --help)
    help
    exit
    ;;
  -d | --install-defaults)
    OPT_INSTALL_DEFAULTS=true
    ;;
  *)
    help
    exit 1
    ;;
  esac
  shift
done

# Variables
###########

OS=$(uname -s)

DOTFILES_REPO_DIR="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"
DOTFILES_DIR=${DOTFILES_DIR:-$DOTFILES_REPO_DIR}

# Script
###########

# Checks if we are on macOS
if [ "$OS" != "Darwin" ]; then
  echo "This script is only for macOS"
  exit 1
fi

if OPT_INSTALL_DEFAULTS; then
  echo "Installing macOS defaults..."
  $DOTFILES_DIR/scripts/macos-defaults.sh
fi

# Install xcode command line tools if necessary
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
fi

# Install Homebrew
if ! command -v brew &>/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Homebrew packages from Brewfile
brew bundle --file="$DOTFILES_DIR/Brewfile"

# Install dotfiles
$DOTFILES_DIR/bin/dotfiles install

# TODO: Install binaries

# TODO: Install rustup
# if ! command -v rustup &>/dev/null; then
#   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# fi

# TODO: Configure git ignore
# git config --global core.excludesfile $XDG_CONFIG_HOME/ignore

# TODO: echo "export DOTFILES_DIR=$DOTFILES_DIR" > $HOME/.zshenv.local
