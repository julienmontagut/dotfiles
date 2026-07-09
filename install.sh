#!/usr/bin/env bash
# Top-level installer.
#   macOS: Xcode CLT → Homebrew → mise → `mise bootstrap` (dotfiles, tools
#          incl. rust/dotnet/aspire/claude-code, then the macOS Brewfile).
#   Linux: delegate to hosts/$(hostname).sh — cloud-init has done the base
#          bootstrap; layer-2 handles per-host provisioning.
# Run from a checkout to bootstrap that checkout (it becomes DOTFILES_DIR); via
# curl|bash it clones to DOTFILES_DIR (~/.local/share/dotfiles) and runs there.
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.local/share/dotfiles}"
REPO_URL="https://github.com/julienmontagut/dotfiles.git"
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

# git is required to locate/clone the repo. macOS ships it with the Xcode CLT;
# Linux is expected to have it already (cloud-init installs it).
if ! command -v git &>/dev/null; then
  if [[ "$OS" == "Darwin" ]]; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    until xcode-select -p &>/dev/null; do sleep 5; done
  else
    echo "git is required but not installed" >&2
    exit 1
  fi
fi

# --- Locate the repo and pin DOTFILES_DIR -----------------------------------
# Run from a checkout (the common case for a working copy): that checkout wins,
# regardless of where it lives on disk. Piped via curl|bash (no resolvable
# script dir / no .git): clone the canonical location and re-exec from there.
# Either way DOTFILES_DIR is exported so layer-2 scripts locate the repo.
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

# --- Linux: hand off to layer-2 (per-host) ----------------------------------
# Export FORCE so the host script's `mise bootstrap` adds --force-dotfiles too.
if [[ "$OS" == "Linux" ]]; then
  export FORCE
  HOST="$(hostname -s)"
  exec "$DOTFILES_DIR/hosts/$HOST.sh"
  # TODO: Handle claude desktop install from official repo
fi

# --- macOS ------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

if ! command -v mise &>/dev/null; then
  curl -fsSL https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

mkdir -p "$HOME/Developer"

# gh is a mise tool — install it, log in, and authenticate mise's GitHub API
# calls so bootstrap resolving `latest` for the rest doesn't hit the rate limit.
mise install gh@latest
export GITHUB_TOKEN="$(mise exec gh -- gh auth token 2>/dev/null || true)"
if [[ -z "$GITHUB_TOKEN" ]]; then
  mise exec gh -- gh auth login
  export GITHUB_TOKEN="$(mise exec gh -- gh auth token)"
fi

# mise bootstrap orchestrates the rest: dotfiles (symlinks the global mise config
# + ~/.Brewfile), the mise-managed tools (rust, dotnet, aspire, claude-code, all
# CLIs), then the bootstrap task (brew bundle for the macOS GUI apps).
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
