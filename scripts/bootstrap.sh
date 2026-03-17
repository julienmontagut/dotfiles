#!/bin/bash

set -e

OSNAME=$(uname -s)
XDG_DATA_HOME=${XDG_DATA_HOME:-"${HOME}/.local/share"}
DOTFILES_DIR=${DOTFILES_DIR:-"${XDG_DATA_HOME}/dotfiles"}

if [ "$OSNAME" = "Darwin" ]; then
    if ! xcode-select -p >/dev/null; then
        xcode-select --install
    else
        echo "Xcode command line tools already installed, skipping installation..."
    fi

    if ! PATH="/opt/homebrew/bin:$PATH" command -v brew >/dev/null; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew already installed, skipping installation..."
    fi
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

# Run platform-specific install script
if [ "$OSNAME" = "Darwin" ]; then
    echo "Running macOS installation..."
    "$DOTFILES_DIR/scripts/install-macos.sh"
elif [ "$OSNAME" = "Linux" ]; then
    echo "Running Linux installation..."
    "$DOTFILES_DIR/scripts/install-linux.sh"
fi
