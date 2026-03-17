#!/bin/bash
# macOS installation script
# Installs Homebrew packages, deploys configs via Dotter, and sets up the system

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d)"

echo "=============================================="
echo "       macOS Dotfiles Installation"
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
        "$HOME/.config/karabiner"
        "$HOME/.config/aerospace"
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
# Install Xcode Command Line Tools
# =============================================================================

install_xcode_cli() {
    if ! xcode-select -p &>/dev/null; then
        echo "Installing Xcode Command Line Tools..."
        xcode-select --install
        echo "Please complete the Xcode CLI installation and re-run this script."
        exit 0
    else
        echo "Xcode Command Line Tools already installed."
    fi
}

# =============================================================================
# Install Homebrew
# =============================================================================

install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for this session
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo "Homebrew already installed."
    fi

    echo "Updating Homebrew..."
    brew update
}

# =============================================================================
# Install packages from Brewfile
# =============================================================================

install_packages() {
    echo "Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/scripts/Brewfile"

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
packages = ["macos"]
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
# Apply macOS defaults
# =============================================================================

apply_defaults() {
    echo ""
    read -p "Apply macOS system defaults? [y/N] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "$DOTFILES_DIR/scripts/macos-defaults.sh"
    else
        echo "Skipping macOS defaults."
    fi
}

# =============================================================================
# Configure services
# =============================================================================

configure_services() {
    echo ""
    read -p "Configure services (TouchID sudo, JankyBorders, etc.)? [y/N] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "$DOTFILES_DIR/scripts/macos-services.sh"
    else
        echo "Skipping service configuration."
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
    echo "  1. Open a new terminal to use the new shell config"
    echo "  2. Run 'nvim' to let plugins install"
    echo "  3. Configure Karabiner-Elements if needed"
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
    install_xcode_cli
    install_homebrew
    install_packages
    setup_dotter
    deploy_configs
    apply_defaults
    configure_services
    post_install
}

main "$@"
