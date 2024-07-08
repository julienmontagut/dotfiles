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
# Prompt
autoload -U promptinit; promptinit
prompt pure

#
# Plugins
#
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
#eval "$(starship init zsh)"

#
# Aliases
#
alias ls='ls -G'
alias vim='nvim'
alias vimdiff='nvim -d'

#
# Editor
#
export EDITOR=nvim

#
# Color settings
#
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export GREP_COLORS=auto


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
