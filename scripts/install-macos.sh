#!/bin/bash
# macOS installation script
# Installs Homebrew packages, applies dotfiles via mise, and sets up the system

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
    brew bundle --file="$DOTFILES_DIR/Brewfile"

    # Initialize rustup if installed
    if command -v rustup &>/dev/null; then
        if ! rustup show &>/dev/null 2>&1; then
            echo "Initializing Rust toolchain..."
            rustup-init -y --no-modify-path
        fi
    fi
}

# =============================================================================
# Apply dotfiles
# =============================================================================

apply_dotfiles() {
    echo "Applying dotfiles via mise..."

    cd "$DOTFILES_DIR"
    export MISE_EXPERIMENTAL=1 MISE_ENV=macos
    mise trust --yes .

    # Dry run first
    echo ""
    echo "Dry run:"
    mise dotfiles apply --dry-run || true

    echo ""
    read -p "Apply dotfiles? [y/N] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mise dotfiles apply --yes --force
        echo "Dotfiles applied."
    else
        echo "Skipping dotfiles."
    fi
}

# =============================================================================
# Install mise-managed tools
# =============================================================================

install_mise_tools() {
    if command -v mise &>/dev/null; then
        echo "Installing mise-managed tools (runtimes, k8s, LSPs)..."
        mise install
    else
        echo "mise not found on PATH; skipping mise install."
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
}

# =============================================================================
# Main
# =============================================================================

main() {
    backup_configs
    install_xcode_cli
    install_homebrew
    install_packages
    apply_dotfiles
    install_mise_tools
    apply_defaults
    configure_services
    post_install
}

main "$@"
