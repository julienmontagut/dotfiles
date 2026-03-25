# .zshrc - Interactive shell configuration
# This file should be at $ZDOTDIR/.zshrc (~/.config/zsh/.zshrc)

# =============================================================================
# History
# =============================================================================

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

# Create history directory if it doesn't exist
[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# =============================================================================
# Options
# =============================================================================

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

# =============================================================================
# Completion
# =============================================================================

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Create cache directory if it doesn't exist
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"

# Menu-style completion
zstyle ':completion:*' menu select
zmodload zsh/complist

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# =============================================================================
# Vi mode
# =============================================================================

bindkey -v
export KEYTIMEOUT=1

# Tab triggers completion in insert mode
bindkey -M viins '^I' expand-or-complete

# In menu: Tab/Enter/Ctrl-y accepts, Ctrl-e cancels
bindkey -M menuselect '^I' accept-line
bindkey -M menuselect '^M' accept-line
bindkey -M menuselect '^Y' accept-line
bindkey -M menuselect '^E' send-break

# Use vim keys in completion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history

# =============================================================================
# Shell plugins (via Homebrew)
# =============================================================================

# Syntax highlighting
if [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Autosuggestions
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# History substring search (part of zsh-history-substring-search or built-in)
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Ctrl-n/Ctrl-p navigate history
bindkey -M viins '^P' history-beginning-search-backward-end
bindkey -M viins '^N' history-beginning-search-forward-end
bindkey -M vicmd '^P' history-beginning-search-backward-end
bindkey -M vicmd '^N' history-beginning-search-forward-end

# Up/down arrow keys
bindkey -M viins '^[[A' history-beginning-search-backward-end
bindkey -M viins '^[[B' history-beginning-search-forward-end
bindkey -M vicmd 'k' history-beginning-search-backward-end
bindkey -M vicmd 'j' history-beginning-search-forward-end

# =============================================================================
# Tool initializations
# =============================================================================

# Starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# Zoxide (cd replacement)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
fi

# Direnv
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# FZF
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

# =============================================================================
# Aliases
# =============================================================================

source "$ZDOTDIR/aliases.zsh"

# =============================================================================
# Local overrides (not tracked in git)
# =============================================================================

[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"
eval "$(mise activate zsh)"

# TODO: Add the following path if they exist to prepend path
# export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# export PATH="$HOME/.aspire/bin:$PATH"
