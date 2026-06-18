# .zshrc - Interactive shell configuration
# Managed by mise as a marker-delimited block in ~/.zshrc; tools may append
# their own lines below the block freely.

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

# Create cache directory if it doesn't exist
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Menu-style completion
zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect '^p' up-line-or-history
bindkey -M menuselect '^n' down-line-or-history
bindkey -M menuselect '^y' accept-search

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# =============================================================================
# mise (activate before tool inits so mise-provided binaries are on PATH)
# =============================================================================

eval "$(mise activate zsh)"

# =============================================================================
# Emacs mode
# =============================================================================

bindkey -e

# History substring search
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Ctrl-n/Ctrl-p navigate history
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end

# Up/down arrow keys
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end

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
# Aliases & local overrides
# =============================================================================

zsh_config="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
source "$zsh_config/aliases.zsh"
source "$zsh_config/upgrade-notice.zsh"

# Local overrides (not tracked in git)
[[ -f "$zsh_config/local.zsh" ]] && source "$zsh_config/local.zsh"
unset zsh_config

# =============================================================================
# Shell plugins (antidote — installed by `mise run antidote`)
# Loaded last so zsh-syntax-highlighting wraps the final widgets/keybindings.
# The plugin list is tracked in the repo; the generated bundle goes to the
# cache dir (regenerated only when the list changes) so nothing is written
# into the symlinked config dir.
# =============================================================================

antidote_dir="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"
if [[ -f "$antidote_dir/antidote.zsh" ]]; then
    source "$antidote_dir/antidote.zsh"
    plugins_txt="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zsh_plugins.txt"
    plugins_zsh="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/plugins.zsh"
    [[ -d "${plugins_zsh:h}" ]] || mkdir -p "${plugins_zsh:h}"
    [[ "$plugins_zsh" -nt "$plugins_txt" ]] || antidote bundle <"$plugins_txt" >| "$plugins_zsh"
    source "$plugins_zsh"
    unset plugins_txt plugins_zsh
fi
unset antidote_dir
