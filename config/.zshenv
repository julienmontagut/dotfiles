# Reads configuration from local zshenv if provided
if [ -f .zshenv.local ]; then
  source .zshenv.local
fi

# Sets xdg config to use a standard location for zsh configuration
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Reads configuration from zsh config directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
if [ -f $ZDOTDIR/.zshenv ]; then
  source $ZDOTDIR/.zshenv
fi
