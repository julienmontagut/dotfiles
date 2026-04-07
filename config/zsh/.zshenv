# .zshenv - Loaded for all shells (login, interactive, scripts)
# This file should be symlinked to ~/.zshenv

# Set XDG directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Set ZDOTDIR to use XDG config location
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Homebrew setup (platform-specific)
if [[ -f /opt/homebrew/bin/brew ]]; then
    # macOS Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    # macOS Intel
    eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    # Linux
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
