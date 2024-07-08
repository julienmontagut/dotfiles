# Disable zsh sessions from macos
export SHELL_SESSIONS_DISABLE=1

# Configuring XDG directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:=$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:=$HOME/.local/run}"

# Configuring an XDG bin directory
export XDG_BIN_HOME="${XDG_BIN_HOME:=$HOME/.local/bin}"
if [ ! -d "$XDG_BIN_HOME" ]; then
  mkdir -p "$XDG_BIN_HOME"
fi
export PATH="$XDG_BIN_HOME:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

if [ -f "$CARGO_HOME/env" ]; then
  . "$CARGO_HOME/env"
fi

# Less with version < 590
export LESSKEY="${LESSKEY:-$XDG_CONFIG_HOME/less/lesskey}"
export LESSHISTFILE="${LESSHISTFILE:-$XDG_CACHE_HOME/less/history}"

# nb 
export NB_DIR="$XDG_DATA_HOME/nb"
export NBRC_PATH="$XDG_CONFIG_HOME/nbrc"

# Terminfo
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# Hammerspoon
# TODO: defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
