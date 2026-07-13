#!/usr/bin/env bash
# Dev-machine installer. Same flow on macOS and Linux:
#   1. Intall system packages and dev dependencies so it runs first and bootstraps a bare box.
#   2. Locate or clone the repo
#   3. Install mise
#   4. Run `mise bootstrap` 
#
# This install is idempotent, and can be run: 
#  - as a copy/pasted standalone local script
#  - as a remote `curl … | sh` script
#  - run from a cloned git repo
#
# When the script is not run from a git repository, the dotfiles repository is cloned
# to DOTFILES_DIR (~/.local/share/dotfiles) and `install.sh` is executed again from there.
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.local/share/dotfiles}"
REPO_URL="${REPO_URL:-https://github.com/julienmontagut/dotfiles.git}"
FORCE=false

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=true ;;
  esac
done

OS="$(uname -s)"
if [[ "$OS" != "Darwin" && "$OS" != "Linux" ]]; then
  echo "Unsupported OS: $OS" >&2
  exit 1
fi

# ================================================================================================
# System package manager setup and dev dependencies
# ================================================================================================
if [[ "$OS" == "Darwin" ]]; then
  if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    until xcode-select -p &>/dev/null; do sleep 5; done
  fi
  if ! command -v brew &>/dev/null; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  fi
else
  sudo apt update
  sudo apt install -y \
    build-essential \
    ca-certificates \
    curl \
    git
fi

# ================================================================================================
# Locate the dotfiles repository or clone it
# ================================================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || echo "")"
if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/.git/HEAD" ]]; then
  DOTFILES_DIR="$SCRIPT_DIR"
else
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    git -C "$DOTFILES_DIR" pull --ff-only
  else
    git clone "$REPO_URL" "$DOTFILES_DIR"
  fi
  export DOTFILES_DIR
  exec bash "$DOTFILES_DIR/install.sh" "$@"
fi
export DOTFILES_DIR

# ================================================================================================
# On macOS, symlink the Brewfile so `brew bundle --global` can be run
# ================================================================================================
if [[ "$OS" == "Darwin" ]]; then
  mkdir -p "$HOME/Developer"
  ln -sfn "$DOTFILES_DIR/Brewfile" "$HOME/.Brewfile"
fi

if ! command -v mise &>/dev/null; then
  curl -fsSL https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

# Try to authenticate into github so that mise's doesn't hit the rate limit of github. 
# Use a GITHUB_TOKEN from the environment, else borrow an existing gh login if one is around, else 
# continue unauthenticated. 
if [[ -z "${GITHUB_TOKEN:-}" ]] && command -v gh &>/dev/null; then
  GITHUB_TOKEN="$(gh auth token 2>/dev/null || true)"
fi
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  export GITHUB_TOKEN
fi

# ================================================================================================
# Mise bootstraps installing dotfiles, tools and running `brew bundle` on macOS
# ================================================================================================
(
  cd "$DOTFILES_DIR"
  export MISE_EXPERIMENTAL=1
  mise trust --yes .
  if [[ "$FORCE" == true ]]; then
    mise bootstrap --yes --force-dotfiles
  else
    mise bootstrap --yes
  fi
)

# ================================================================================================
# Apply platform specific scripts like macOS defaults
# ================================================================================================
# TODO: Change this to be simpler. A script by platform
if [[ "$OS" == "Darwin" && -t 0 ]]; then
  read -rp "Apply macOS system defaults & services? [y/N] " reply
  if [[ $reply =~ ^[Yy]$ ]]; then
    "$DOTFILES_DIR/scripts/macos-defaults.sh"
    "$DOTFILES_DIR/scripts/macos-services.sh"
  fi
fi
