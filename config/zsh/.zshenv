# .zshenv - Loaded for all shells (login, interactive, scripts)
# This file should be symlinked to ~/.zshenv

# Set XDG directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Set ZDOTDIR to use XDG config location
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# mise: pick the OS overlay (~/.config/mise/config.<env>.toml) so the global tool
# environment resolves the same way in every shell.
export MISE_ENV="${MISE_ENV:-$([ "$(uname)" = Darwin ] && echo macos || echo linux)}"

# Add local bin to PATH
[[ -d "$HOME/.bin" ]] && export PATH="$HOME/.bin:$PATH"

# Add local bin to PATH
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

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

# Theme
export THEME="basalt"
export THEME_VARIANT="dark"

# Tool themes (use terminal base16 colors)
export BAT_THEME="base16"
export FZF_DEFAULT_OPTS="--color=bg+:8,fg:7,fg+:15,hl:4,hl+:12,info:6,marker:2,prompt:4,spinner:5,pointer:5,header:8,border:8,gutter:-1 --bind 'ctrl-p:up,ctrl-n:down,ctrl-y:accept'"

# Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
