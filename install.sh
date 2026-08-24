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
# That default is only where a bare `curl | sh` puts the clone - an existing checkout works from
# anywhere, since the machine config finds itself through the ~/.config/mise symlink.
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
  # config/mise/config.linux.toml. The desktop stack lives in bin/install-sway.
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
# pwd -P: resolve to the physical path, so ~/.config/mise ends up pointing at the real checkout
# rather than at a symlink to it - every dotfile source climbs out through that link.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd -P || echo "")"
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

# Unconditional: a guard would leave a stale mise, too old for newer cask metadata (see min_version).
curl -fsSL https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

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
# The machine is defined in config/mise/config.toml (+ config.{macos,linux}.toml), which lives at
# ~/.config/mise. The seed pass below links it there from the repo; the full pass then installs
# system packages, dotfiles, tools, the login shell, macOS defaults, and (via [tasks.bootstrap])
# the Brewfile and macos-setup.sh. After this, `mise bootstrap` works from any directory.
# ================================================================================================
# An `[[ … ]] && x=…` one-liner would return 1 when FORCE is false and `set -e` would abort here.
force_flag=""
if [[ "$FORCE" == true ]]; then
  force_flag="--force-dotfiles"
fi

(
  cd "$DOTFILES_DIR"
  mise trust --yes .
  mise bootstrap --only dotfiles --yes $force_flag
)
mise bootstrap --yes $force_flag
