# .zshrc - Interactive shell configuration

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
# Terminal fallback
# =============================================================================

if [[ -n "$TERM" && "$TERM" != "dumb" ]] && ! infocmp "$TERM" &>/dev/null; then
    export TERM=xterm-256color
fi

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

# =============================================================================
# Prompt
# =============================================================================

autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:git:*' formats       ' %F{yellow}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}%b%f%F{red}|%a%f'
add-zsh-hook precmd vcs_info
setopt prompt_subst

PROMPT=$'%F{blue}%(4~|…/%3~|%~)%f${vcs_info_msg_0_} %(?..%F{red}%? %f)\n%F{green}❯%f '

# Blank line above the prompt, but not the first one: preexec only fires once a command has run
prompt_blank_line() { [[ $PROMPT == $'\n'* ]] || PROMPT=$'\n'$PROMPT }
add-zsh-hook preexec prompt_blank_line

# =============================================================================
# Tool initializations
# =============================================================================

# Zoxide (cd replacement)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
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
unset zsh_config

# =============================================================================
# Zim framework for ZSH
# =============================================================================

# Use the systemd-managed user ssh-agent (one shared agent, no per-shell leaks).
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/openssh_agent"

export ZIM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zim"
export ZIM_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zimrc"

# Download zimfw if missing (first run on a new machine).
if [[ ! -e "$ZIM_HOME/zimfw.zsh" ]]; then
    curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
# Install missing modules and rebuild init.zsh when it's missing or older than zimrc.
if [[ ! "$ZIM_HOME/init.zsh" -nt "$ZIM_CONFIG_FILE" ]]; then
    source "$ZIM_HOME/zimfw.zsh" init -q
fi
source "$ZIM_HOME/init.zsh"
