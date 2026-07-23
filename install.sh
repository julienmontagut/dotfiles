#!/usr/bin/env bash
# Dev-machine installer. Same flow on macOS and Linux:
#   1. Install the prerequisites mise needs to exist (curl, git; on macOS Xcode CLT + Homebrew).
#   2. Locate or clone the repo
#   3. Install mise
#   4. Run `mise bootstrap` - it installs everything else (packages, dotfiles, tools, macOS setup).
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
  fi
  # Put brew on PATH for the rest of this run (the mise bootstrap task runs `brew bundle`).
  # Future shells get it from the managed zshenv, not a stray ~/.zprofile edit.
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
else
  # Only the prerequisites needed before mise exists: git to clone, curl to fetch mise.
  # Everything else (build deps, zsh, xclip, fontconfig, …) is in [bootstrap.packages] in
  # mise.toml and gets installed by `mise bootstrap`. The desktop stack lives in bin/install-sway.
  pkgs=(ca-certificates curl git)
  missing=()
  for pkg in "${pkgs[@]}"; do
    dpkg -s "$pkg" &>/dev/null || missing+=("$pkg")
  done
  if (( ${#missing[@]} )); then
    sudo apt update
    sudo apt install -y "${missing[@]}"
  fi
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
# mise bootstrap installs system packages, dotfiles, tools, the login shell, macOS defaults
# and (via [tasks.bootstrap]) the macOS Dock/hotkeys/TouchID setup - all from mise.toml.
# ================================================================================================
(
  cd "$DOTFILES_DIR"
  mise trust --yes .
  force_flag=""
  [[ "$FORCE" == true ]] && force_flag="--force-dotfiles"
  # Apply dotfiles first so the global ~/.config/mise/config.{macos,linux}.toml and miserc.toml
  # exist before the packages step of the full bootstrap (on a fresh box they aren't linked yet).
  mise bootstrap --only dotfiles --yes $force_flag
  mise bootstrap --yes $force_flag
)
