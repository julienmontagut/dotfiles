#!/bin/bash
# Linux installation script
# Installs packages via apt and Linuxbrew, deploys configs via Dotter

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d)"

echo "=============================================="
echo "       Linux Dotfiles Installation"
echo "=============================================="
echo ""
echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

# =============================================================================
# Backup existing configs
# =============================================================================

backup_configs() {
    echo "Backing up existing configs to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"

    local configs=(
        "$HOME/.config/git"
        "$HOME/.config/zsh"
        "$HOME/.config/nvim"
        "$HOME/.config/wezterm"
        "$HOME/.config/zed"
        "$HOME/.config/sway"
        "$HOME/.config/waybar"
        "$HOME/.config/kanshi"
        "$HOME/.config/fuzzel"
        "$HOME/.config/keyd"
        "$HOME/.config/starship.toml"
        "$HOME/.zshrc"
        "$HOME/.zshenv"
        "$HOME/.gitconfig"
    )

    for config in "${configs[@]}"; do
        if [[ -e "$config" ]]; then
            echo "  Backing up: $config"
            cp -R "$config" "$BACKUP_DIR/" 2>/dev/null || true
        fi
    done

    echo "Backup complete."
    echo ""
}

# =============================================================================
# Install apt packages
# =============================================================================

install_apt_packages() {
    echo "Installing apt packages..."
    "$DOTFILES_DIR/scripts/linux-packages.sh"
}

# =============================================================================
# Install Linuxbrew
# =============================================================================

install_linuxbrew() {
    if command -v brew &>/dev/null; then
        echo "Linuxbrew already installed."
    else
        echo "Installing Linuxbrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Linuxbrew to PATH for this session
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    echo "Updating Homebrew..."
    brew update
}

# =============================================================================
# Install packages from Brewfile
# =============================================================================

install_brew_packages() {
    echo "Installing CLI tools from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/scripts/Brewfile" --no-lock

    # Initialize rustup if installed
    if command -v rustup &>/dev/null; then
        if ! rustup show &>/dev/null 2>&1; then
            echo "Initializing Rust toolchain..."
            rustup-init -y --no-modify-path
        fi
    fi
}

# =============================================================================
# Setup Dotter
# =============================================================================

setup_dotter() {
    echo "Setting up Dotter..."

    cd "$DOTFILES_DIR"

    # Create local.toml if it doesn't exist
    if [[ ! -f ".dotter/local.toml" ]]; then
        echo "Creating .dotter/local.toml..."
        cat > ".dotter/local.toml" << 'EOF'
packages = ["linux"]
EOF
    fi

    echo "Dotter configuration ready."
}

# =============================================================================
# Deploy configs
# =============================================================================

deploy_configs() {
    echo "Deploying configs via Dotter..."

    cd "$DOTFILES_DIR"

    # Dry run first
    echo ""
    echo "Dry run:"
    dotter deploy --dry-run || true

    echo ""
    read -p "Deploy configs? [y/N] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        dotter deploy --force
        echo "Configs deployed."
    else
        echo "Skipping config deployment."
    fi
}

# =============================================================================
# Configure keyd
# =============================================================================

configure_keyd() {
    echo ""
    echo "Configuring keyd..."

    if ! command -v keyd &>/dev/null; then
        echo "keyd not installed. Skipping keyboard configuration."
        return
    fi

    # Copy keyd config if it exists
    if [[ -f "$DOTFILES_DIR/config/keyd/default.conf" ]]; then
        sudo mkdir -p /etc/keyd
        sudo cp "$DOTFILES_DIR/config/keyd/default.conf" /etc/keyd/default.conf
        sudo systemctl restart keyd
        echo "keyd configured and restarted."
    fi
}

# =============================================================================
# Set default shell
# =============================================================================

set_default_shell() {
    echo ""
    local zsh_path
    zsh_path=$(which zsh)

    if [[ "$SHELL" != "$zsh_path" ]]; then
        read -p "Set zsh as default shell? [y/N] " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Add zsh to /etc/shells if not present
            if ! grep -q "$zsh_path" /etc/shells; then
                echo "$zsh_path" | sudo tee -a /etc/shells
            fi
            chsh -s "$zsh_path"
            echo "Default shell set to zsh."
        fi
    else
        echo "zsh is already the default shell."
    fi
}

# =============================================================================
# Post-install notes
# =============================================================================

post_install() {
    echo ""
    echo "=============================================="
    echo "       Installation Complete!"
    echo "=============================================="
    echo ""
    echo "Next steps:"
    echo "  1. Log out and back in for shell changes"
    echo "  2. Run 'nvim' to let plugins install"
    echo "  3. Start Sway with 'sway' if using Wayland"
    echo ""
    echo "Your old configs are backed up at: $BACKUP_DIR"
    echo ""
    echo "To uninstall Nix (if installed), run:"
    echo "  $DOTFILES_DIR/scripts/uninstall-nix.sh"
    echo ""
}

# =============================================================================
# Main
# =============================================================================

main() {
    backup_configs
    install_apt_packages
    install_linuxbrew
    install_brew_packages
    setup_dotter
    deploy_configs
    configure_keyd
    set_default_shell
    post_install
}

main "$@"
