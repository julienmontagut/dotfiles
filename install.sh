#!/usr/bin/env bash
set -euo pipefail

DOTS_DIR="${DOTS_DIR:-$HOME/.local/share/dots}"
REPO_URL="https://github.com/julienmontagut/dotfiles.git"

# Detect operating system

OS="$(uname -s)"

if [[ "$OS" != "Darwin" && "$OS" != "Linux" ]]; then
  echo "Unsupported OS: $OS" >&2
  exit 1
fi

if [[ "$OS" == "Linux" ]] && ! command -v apt &>/dev/null; then
  echo "Unsupported Linux distro — please install git manually." >&2
  exit 1
fi

# Ensure git is installed

if ! command -v git &>/dev/null; then
  if [[ "$OS" == "Darwin" ]]; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    until xcode-select -p &>/dev/null; do
      sleep 5
    done
    echo "CLT installed."
  else
    echo "Installing git..."
    sudo apt update -qq
    sudo apt install -y git
  fi
fi

# Bootstrap the repository

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || echo "")"

if [[ -z "$SCRIPT_DIR" ]] || [[ ! -f "$SCRIPT_DIR/.git/HEAD" ]]; then
  if [[ -d "$DOTS_DIR/.git" ]]; then
    echo "Updating existing repo at $DOTS_DIR..."
    git -C "$DOTS_DIR" pull --ff-only
  else
    echo "Cloning dotfiles to $DOTS_DIR..."
    git clone --depth 1 "$REPO_URL" "$DOTS_DIR"
  fi
  # exec bash "$DOTS_DIR/install.sh"
fi

DOTS_DIR="$SCRIPT_DIR"
echo "Running from cloned repo at $DOTS_DIR"

# Installing system packages

# Installing homebrew
if ! command -v brew &>/dev/null; then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> /Users/julien/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> /Users/julien/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

# Installing dotter
if ! command -v dotter &>/dev/null; then
  brew install dotter
fi

# Applying dotter config

# Applying homebrew config

# Creating the directory for source code
if [[ "$OS" == "Darwin" ]]; then
  mkdir -p "$HOME/Developer"
else
  mkdir -p "$HOME/Sources"
fi

# TODO: Think about a minimal VIM config with system packages
