#Enable auto completion
autoload -Uz compinit
compinit

export BETCLI_HOME="$HOME/sources/betclic-cli"
export PATH=$PATH:$BETCLI_HOME

# Add homebrew to the environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Enable starship prompt
eval "$(starship init zsh)"
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
