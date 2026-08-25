#!/usr/bin/env bash
# Dev-machine installer for macOS and Linux: prerequisites, then the repo, mise, and
# `mise bootstrap`. Idempotent, and runs standalone, from `curl … | sh`, or from a clone.
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.local/share/dotfiles}"
REPO_URL="${REPO_URL:-https://codeberg.org/julienmontagut/dotfiles.git}"
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

if [[ "$OS" == "Darwin" ]]; then
  if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    until xcode-select -p &>/dev/null; do sleep 5; done
  fi
  if ! command -v brew &>/dev/null; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
else
  # Only what is needed before mise exists. The rest is in [bootstrap.packages].
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

# pwd -P: ~/.config/mise must point at the real checkout, not at a symlink to it.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd -P || echo "")"
if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/.git/HEAD" ]]; then
  DOTFILES_DIR="$SCRIPT_DIR"
else
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    # Re-point checkouts made back when the repo still lived on GitHub.
    git -C "$DOTFILES_DIR" remote set-url origin "$REPO_URL"
    git -C "$DOTFILES_DIR" pull --ff-only
  else
    git clone "$REPO_URL" "$DOTFILES_DIR"
  fi
  export DOTFILES_DIR
  exec bash "$DOTFILES_DIR/install.sh" "$@"
fi
export DOTFILES_DIR

# Unguarded on purpose: an existing mise can be too old for newer cask metadata (see min_version).
curl -fsSL https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

# Borrow a gh login when there is no token, to keep mise off the anonymous GitHub rate limit.
if [[ -z "${GITHUB_TOKEN:-}" ]] && command -v gh &>/dev/null; then
  GITHUB_TOKEN="$(gh auth token 2>/dev/null || true)"
fi
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  export GITHUB_TOKEN
fi

force_flag=""
if [[ "$FORCE" == true ]]; then
  force_flag="--force-dotfiles"
fi

# First pass links ~/.config/mise from the clone, second pass reads it and converges the machine.
# Only that one entry: a full --only dotfiles pass here would also load an existing (possibly
# broken) ~/.config/mise and fail before it could repair it. --force for the same reason.
(
  cd "$DOTFILES_DIR"
  mise trust --yes .
  mise bootstrap dotfiles apply '~/.config/mise' --force
)
mise bootstrap --yes $force_flag
