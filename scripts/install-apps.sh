#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
XDG_DATA_HOME=${XDG_DATA_HOME:-"${HOME}/.local/share"}
XDG_BIN_HOME=${XDG_BIN_HOME:-"${HOME}/.local/bin"}
DOTFILES_DIR=${DOTFILES_DIR:-"${XDG_DATA_HOME}/dotfiles"}

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Check if running on Linux
if [[ "$(uname -s)" != "Linux" ]]; then
    log_error "This script is only for Linux. Detected: $(uname -s)"
    exit 1
fi

log_header "Linux Application Installation Script"

# ============================================================================
# Utility Functions
# ============================================================================

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# APT Package Manager Updates
# ============================================================================

install_apt_packages() {
    log_header "[1/5] System Package Manager Setup"

    if ! command_exists apt-get; then
        log_warning "APT package manager not found. Skipping system package updates."
        return
    fi

    log_info "Updating system package cache..."
    sudo apt-get update -qq
    log_success "System package cache updated"
}

# ============================================================================
# WezTerm Installation
# ============================================================================

install_wezterm() {
    log_header "[2/5] Installing WezTerm Terminal"

    if command_exists wezterm; then
        log_success "WezTerm is already installed"
        return
    fi

    if ! command_exists apt-get; then
        log_warning "APT package manager not found. Cannot install WezTerm."
        return
    fi

    log_info "Adding WezTerm repository..."
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null
    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

    log_info "Updating package cache..."
    sudo apt-get update -qq

    log_info "Installing WezTerm..."
    sudo apt-get install -y wezterm >/dev/null
    log_success "WezTerm installed successfully"
}

# ============================================================================
# Zed Editor Installation
# ============================================================================

install_zed() {
    log_header "[3/5] Installing Zed Editor"

    if command_exists zed; then
        log_success "Zed is already installed"
        return
    fi

    if ! command_exists curl; then
        log_error "curl is required but not installed"
        return
    fi

    log_info "Downloading and installing Zed..."
    if curl -f https://zed.dev/install.sh | sh; then
        log_success "Zed installed successfully"
    else
        log_error "Failed to install Zed"
        return
    fi
}

# ============================================================================
# JetBrains Toolbox Installation
# ============================================================================

install_jetbrains_toolbox() {
    log_header "[4/5] Installing JetBrains Toolbox"

    if [ -f "$XDG_BIN_HOME/jetbrains-toolbox" ]; then
        log_success "JetBrains Toolbox is already installed"
        return
    fi

    if ! command_exists curl; then
        log_error "curl is required but not installed"
        return
    fi

    if ! command_exists tar; then
        log_error "tar is required but not installed"
        return
    fi

    local INSTALL_DIR="$HOME/.local/share/JetBrains/Toolbox"

    log_info "Fetching JetBrains Toolbox download URL..."
    local ARCHIVE_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}' | sed 's/[", ]//g')

    if [ -z "$ARCHIVE_URL" ]; then
        log_error "Failed to fetch JetBrains Toolbox URL"
        return
    fi

    local ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

    log_info "Downloading $ARCHIVE_FILENAME..."
    rm "/tmp/$ARCHIVE_FILENAME" 2>/dev/null || true

    if ! wget -q --show-progress -cO "/tmp/$ARCHIVE_FILENAME" "$ARCHIVE_URL"; then
        log_error "Failed to download JetBrains Toolbox"
        return
    fi

    log_info "Extracting to $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
    rm "$INSTALL_DIR/jetbrains-toolbox" 2>/dev/null || true
    tar -xzf "/tmp/$ARCHIVE_FILENAME" -C "$INSTALL_DIR" --strip-components=1
    rm "/tmp/$ARCHIVE_FILENAME"
    chmod +x "$INSTALL_DIR/bin/jetbrains-toolbox"

    log_info "Creating symlink to $XDG_BIN_HOME/jetbrains-toolbox..."
    mkdir -p "$XDG_BIN_HOME"
    rm "$XDG_BIN_HOME/jetbrains-toolbox" 2>/dev/null || true
    ln -s "$INSTALL_DIR/bin/jetbrains-toolbox" "$XDG_BIN_HOME/jetbrains-toolbox"

    log_success "JetBrains Toolbox installed successfully"
}

# ============================================================================
# GPU Driver Setup (for Nix packages)
# ============================================================================

setup_gpu_drivers() {
    log_header "[5/5] Configuring GPU Drivers for Nix Packages"

    local MARKER_FILE="$HOME/.cache/nix-gpu-configured"

    if [ -f "$MARKER_FILE" ]; then
        log_success "GPU drivers already configured"
        return
    fi

    log_info "Checking GPU driver setup for Nix packages..."

    # Find the non-nixos-gpu setup script
    local GPU_SETUP=$(find /nix/store -maxdepth 1 -name '*non-nixos-gpu*' -type d 2>/dev/null | \
                grep -m1 'non-nixos-gpu' | \
                awk '{print $1"/bin/non-nixos-gpu-setup"}' || echo "")

    if [ -z "$GPU_SETUP" ] || [ ! -f "$GPU_SETUP" ]; then
        log_warning "GPU setup script not found yet"
        log_info "This is normal if this is your first install."
        log_info "Run 'home-manager switch --flake .' first, then run this script again."
        return
    fi

    log_info "Found GPU setup script: $GPU_SETUP"
    log_info "This will configure Nix packages to access your system GPU drivers."

    if sudo "$GPU_SETUP"; then
        mkdir -p "$(dirname "$MARKER_FILE")"
        touch "$MARKER_FILE"
        log_success "GPU drivers configured successfully"
        log_info "Terminal apps like Alacritty and Ghostty should now work."
    else
        log_error "GPU setup failed"
        return 1
    fi
}

# ============================================================================
# Main Installation Flow
# ============================================================================

main() {
    log_info "Starting Linux application installation..."
    log_info "System: $(uname -s) $(uname -r)"
    log_info "Architecture: $(uname -m)"

    # Run installations in sequence
    install_apt_packages
    install_wezterm
    install_zed
    install_jetbrains_toolbox
    setup_gpu_drivers

    log_header "Installation Summary"
    log_success "All installations completed!"

    echo ""
    echo "Installed applications:"
    command_exists wezterm && echo "  • WezTerm (Terminal)" || echo "  • WezTerm (Terminal) - ${YELLOW}Not installed${NC}"
    command_exists zed && echo "  • Zed (Editor)" || echo "  • Zed (Editor) - ${YELLOW}Not installed${NC}"
    [ -f "$XDG_BIN_HOME/jetbrains-toolbox" ] && echo "  • JetBrains Toolbox" || echo "  • JetBrains Toolbox - ${YELLOW}Not installed${NC}"

    echo ""
    log_info "Next steps:"
    echo "  1. Add '\$XDG_BIN_HOME' to your PATH if not already done"
    echo "  2. Run 'home-manager switch --flake .' to apply Nix configuration"
    echo "  3. If on non-NixOS, run this script again to configure GPU drivers"
    echo ""
    log_success "Setup complete!"
}

# Run main function
main "$@"
