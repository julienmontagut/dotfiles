#!/usr/bin/env bash
# Top-level installer.
#   macOS: Xcode CLT → Homebrew → dotter → deploy → Brewfile → rustup.
#   Linux: delegate to hosts/$(hostname).sh — cloud-init has done the base
#          bootstrap; layer-2 handles per-host provisioning.
set -euo pipefail

DOTS_DIR="${DOTS_DIR:-$HOME/.local/share/dots}"
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

if ! command -v dotter &>/dev/null; then
  brew install dotter
fi

cat > "$DOTS_DIR/.dotter/local.toml" <<'EOF'
packages = ["default", "macos"]
EOF

if [[ "$FORCE" == true ]]; then
  (cd "$DOTS_DIR" && dotter deploy --force)
else
  (cd "$DOTS_DIR" && dotter deploy)
fi

brew bundle --global

mkdir -p "$HOME/Developer"

if ! command -v rustup &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
