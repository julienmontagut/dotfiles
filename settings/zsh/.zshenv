# Rust configuration
export RUSTUP_HOME=$HOME/.local/share/rustup
export CARGO_HOME=$HOME/.local/share/cargo
source $CARGO_HOME/env

# Custom bin path
export PATH="$HOME/.local/bin:$PATH"

export USER_DATA_DIR=$(dirname $0)
export USER_SETTINGS_DIR=
export XDG_CONFIG_HOME=$USER_SETTINGS_DIR
