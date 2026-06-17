#!/usr/bin/env bash
# Top-level installer.
#   macOS: Xcode CLT → Homebrew → mise → `mise bootstrap` (dotfiles, tools
#          incl. rust/dotnet/aspire/claude-code, then the macOS Brewfile).
#   Linux: delegate to hosts/$(hostname).sh — cloud-init has done the base
#          bootstrap; layer-2 handles per-host provisioning.
# Run from a checkout to bootstrap that checkout; via curl|bash it clones to
# DOTS_DIR first.
set -euo pipefail

DOTS_DIR="${DOTS_DIR:-$HOME/.local/share/dotfiles}"
REPO_URL="https://github.com/julienmontagut/dotfiles.git"
FORCE=false

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=true ;;
  esac
done

OS="$(uname -s)"

# --- Linux: hand off to layer-2 ---
if [[ "$OS" == "Linux" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || echo "")"
  [[ -n "$SCRIPT_DIR" ]] || { echo "run install.sh from a cloned checkout (cloud-init does this)" >&2; exit 1; }
  HOST="$(hostname -s)"
  exec "$SCRIPT_DIR/hosts/$HOST.sh"
fi

# --- macOS ---
if [[ "$OS" != "Darwin" ]]; then
  echo "Unsupported OS: $OS" >&2
  exit 1
fi

if ! command -v git &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do sleep 5; done
fi

# Bootstrap the repository when invoked via curl|bash.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || echo "")"
if [[ -z "$SCRIPT_DIR" ]] || [[ ! -f "$SCRIPT_DIR/.git/HEAD" ]]; then
  if [[ -d "$DOTS_DIR/.git" ]]; then
    git -C "$DOTS_DIR" pull --ff-only
  else
    git clone --depth 1 "$REPO_URL" "$DOTS_DIR"
  fi
  exec bash "$DOTS_DIR/install.sh" "$@"
fi
DOTS_DIR="$SCRIPT_DIR"

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

# mise bootstrap orchestrates the rest: dotfiles (symlinks the global mise config
# + ~/.Brewfile), the mise-managed tools (rust, dotnet, aspire, claude-code, all
# CLIs), then the bootstrap task (brew bundle for the macOS GUI apps).
(
  cd "$DOTS_DIR"
  export MISE_EXPERIMENTAL=1 MISE_ENV=macos
  mise trust --yes .
  if [[ "$FORCE" == true ]]; then
    mise bootstrap --yes --force-dotfiles
  else
    mise bootstrap --yes
  fi
)
