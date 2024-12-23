#!/bin/sh
set -e

OSNAME=$(uname -s)
XDG_DATA_HOME=${XDG_DATA_HOME:-"${HOME}/.local/share"}
DOTFILES_DIR=${DOTFILES_DIR:-"${XDG_DATA_HOME}/dotfiles"}

# If on NixOS, we skip the rest of the install
if [ "$OSNAME" = "Linux" ] && [ "$(cat /etc/os-release | grep -i nixos)" ]; then
  echo "NixOS detected, skipping the rest of the install"
  exit 0
fi

if [ "$OSNAME" = "Darwin" ] || [ "$OSNAME" = "Linux" ]; then
  # Install nix from determinate systems except on NixOS
  if ! command -v nix &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
        sh -s -- install 
fi

# On macOS, we install homebrew to handle app installations
if [ "$OSNAME" = "Darwin" ]; then
  if ! xcode-select -p &>/dev/null; then
    xcode-select --install
  fi

  if ! command -v brew &>/dev/null; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# Apply nix darwin on macOS
if [ "$OSNAME" = "Darwin" ]; then
  nix run nix-darwin -- switch --flake $DOTFILES_DIR
  # darwin-rebuild switch --flake $DOTFILES_DIR
fi
