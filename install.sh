#!/bin/sh
set -e

OSNAME=$(uname -s)
XDG_DATA_HOME=${XDG_DATA_HOME:-"${HOME}/.local/share"}
DOTFILES_DIR=${DOTFILES_DIR:-"${XDG_DATA_HOME}/dotfiles"}

if [ "$OSNAME" = "Darwin" ] || [ "$OSNAME" = "Linux" ]; then
  # Install nix from determinate systems except if it is already installed
  if
    ! command -v nix &
    >/dev/null && [ ! -d "$HOME/.nix-profile" ] && [ ! -f "/nix/var/nix/profiles/default/bin/nix" ]
  then
    echo "Nix not detected, installing..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |
      sh -s -- install
  else
    echo "Nix already installed, skipping installation..."
  fi
fi

# On macOS, we install homebrew to handle app installations
if [ "$OSNAME" = "Darwin" ]; then
  if
    ! xcode-select -p &
    >/dev/null
  then
    xcode-select --install
  fi

  if
    ! command -v brew &
    >/dev/null
  then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  nix run nix-darwin -- switch --flake $DOTFILES_DIR
  # darwin-rebuild switch --flake $DOTFILES_DIR
fi

# Install Home Manager on WSL if not already installed
if
  ! command -v home-manager &
  >/dev/null
then
  echo "Home Manager not found, installing..."
  nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
else
  echo "Home Manager already installed, skipping installation..."
fi

# Create dotfiles directory if it doesn't exist
mkdir -p "$DOTFILES_DIR"

# Check if repo is already cloned
if [ ! -d "$DOTFILES_DIR/.git" ]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/julienmontagut/dotfiles.git "$DOTFILES_DIR"
else
  echo "Dotfiles repository already exists, updating..."
  (cd "$DOTFILES_DIR" && git pull)
fi

echo "Applying configuration with home-manager..."
home-manager switch --flake "$DOTFILES_DIR"
