#
# Create required directories
#
if [ -n "$XDG_STATE_HOME" ]; then
  if [ ! -d "$XDG_STATE_HOME/zsh" ]; then
    mkdir -p "$XDG_STATE_HOME/zsh"
  fi
  export HISTFILE="$XDG_STATE_HOME/zsh/history"
fi
ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
if [ ! -d "$ZSH_CACHE_DIR" ]; then
  mkdir -p "$ZSH_CACHE_DIR"
fi

#
# Options
#
setopt hist_ignore_dups
setopt share_history
setopt globdots
setopt menu_complete
setopt auto_menu

# Add functions to fpath from brew and cargo
if command -v rustc >/dev/null 2>&1; then
  fpath=($(rustc --print sysroot)/share/zsh/site-functions $fpath)
fi
if command -v brew >/dev/null 2>&1; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

#
# Command line completion
autoload -U compinit
compinit -C -d "$ZSH_CACHE_DIR/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' complete-options true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

#
# Plugins
#
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/opt/spaceship/spaceship.zsh

#
# Aliases
#
alias ls='ls -G'

#
# Color settings
#
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export GREP_COLORS=auto
