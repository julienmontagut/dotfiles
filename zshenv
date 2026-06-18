# .zshenv - Loaded for every shell (symlinked to ~/.zshenv by mise)

# XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Pick the mise environment (macos / linux) so config resolves the same way
# in every shell, including before `mise activate` runs in .zshrc.
export MISE_ENV="${MISE_ENV:-$([ "$(uname)" = Darwin ] && echo macos || echo linux)}"

# PATH
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d "$HOME/.dotnet/tools" ]] && path=("$HOME/.dotnet/tools" $path)
[[ -d "$HOME/.aspire/bin" ]] && path=("$HOME/.aspire/bin" $path)
export PATH

# Homebrew: opt out of analytics and env hints (declarative, no ~/.zshrc edits)
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

# Theme
export THEME="basalt"
export THEME_VARIANT="dark"

# Tool themes (use terminal base16 colors)
export BAT_THEME="base16"
export FZF_DEFAULT_OPTS="--color=bg+:8,fg:7,fg+:15,hl:4,hl+:12,info:6,marker:2,prompt:4,spinner:5,pointer:5,header:8,border:8,gutter:-1 --bind 'ctrl-p:up,ctrl-n:down,ctrl-y:accept'"
