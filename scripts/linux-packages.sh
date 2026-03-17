#!/bin/bash
# Linux package installation script
# Installs core packages via apt and sets up third-party repos

set -euo pipefail

echo "=============================================="
echo "       Linux Package Installation"
echo "=============================================="
echo ""

# =============================================================================
# Detect distribution
# =============================================================================

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO="$ID"
        DISTRO_VERSION="$VERSION_ID"
    else
        echo "Error: Cannot detect distribution"
        exit 1
    fi

    echo "Detected: $DISTRO $DISTRO_VERSION"
}

# =============================================================================
# Core packages via apt
# =============================================================================

install_apt_packages() {
    echo ""
    echo "Installing core packages via apt..."

    sudo apt update

    sudo apt install -y \
        build-essential \
        curl \
        git \
        wget \
        zsh \
        unzip \
        fontconfig \
        pkg-config \
        libssl-dev

    # Optional: Sway and Wayland tools (uncomment if using Sway)
    # sudo apt install -y sway waybar kanshi fuzzel wl-clipboard
}

# =============================================================================
# extrepo for third-party repos
# =============================================================================

setup_extrepo() {
    echo ""
    echo "Setting up extrepo..."

    if ! command -v extrepo &>/dev/null; then
        sudo apt install -y extrepo
    fi

    # List available repos
    echo "Available extrepo repositories:"
    extrepo search || true
}

# =============================================================================
# WezTerm
# =============================================================================

install_wezterm() {
    echo ""
    echo "Installing WezTerm..."

    if command -v wezterm &>/dev/null; then
        echo "WezTerm already installed."
        return
    fi

    # Check if available via extrepo
    if extrepo search wezterm &>/dev/null; then
        sudo extrepo enable wezterm
        sudo apt update
        sudo apt install -y wezterm
    else
        # Manual installation
        echo "Installing WezTerm from GitHub releases..."
        local wezterm_deb="/tmp/wezterm.deb"
        curl -fsSL "https://github.com/wez/wezterm/releases/download/nightly/wezterm-nightly.Debian12.deb" -o "$wezterm_deb"
        sudo dpkg -i "$wezterm_deb" || sudo apt-get install -f -y
        rm -f "$wezterm_deb"
    fi
}

# =============================================================================
# Zed Editor
# =============================================================================

install_zed() {
    echo ""
    echo "Installing Zed editor..."

    if command -v zed &>/dev/null; then
        echo "Zed already installed."
        return
    fi

    # Zed official install script
    curl -f https://zed.dev/install.sh | sh
}

# =============================================================================
# JetBrains Toolbox
# =============================================================================

install_jetbrains_toolbox() {
    echo ""
    echo "Installing JetBrains Toolbox..."

    local toolbox_dir="$HOME/.local/share/JetBrains/Toolbox"

    if [[ -d "$toolbox_dir" ]]; then
        echo "JetBrains Toolbox already installed."
        return
    fi

    # Download and extract
    local toolbox_tar="/tmp/jetbrains-toolbox.tar.gz"
    local download_url

    # Get latest version URL
    download_url=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' \
        | grep -Po '"linux":{"link":"\K[^"]+')

    if [[ -n "$download_url" ]]; then
        curl -fsSL "$download_url" -o "$toolbox_tar"
        mkdir -p "$HOME/.local/bin"
        tar -xzf "$toolbox_tar" -C /tmp
        mv /tmp/jetbrains-toolbox-*/jetbrains-toolbox "$HOME/.local/bin/"
        rm -rf /tmp/jetbrains-toolbox-* "$toolbox_tar"
        echo "JetBrains Toolbox installed to ~/.local/bin/jetbrains-toolbox"
        echo "Run it once to complete setup."
    else
        echo "Warning: Could not download JetBrains Toolbox"
    fi
}

# =============================================================================
# keyd (keyboard remapping)
# =============================================================================

install_keyd() {
    echo ""
    echo "Installing keyd..."

    if command -v keyd &>/dev/null; then
        echo "keyd already installed."
        return
    fi

    # Build from source
    local keyd_dir="/tmp/keyd"
    git clone https://github.com/rvaiya/keyd.git "$keyd_dir"
    cd "$keyd_dir"
    make
    sudo make install
    sudo systemctl enable keyd
    sudo systemctl start keyd
    cd -
    rm -rf "$keyd_dir"

    echo "keyd installed and started."
}

# =============================================================================
# Fonts
# =============================================================================

install_fonts() {
    echo ""
    echo "Installing fonts..."

    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    # Lilex Nerd Font
    if ! fc-list | grep -qi "lilex"; then
        echo "Installing Lilex Nerd Font..."
        local font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Lilex.zip"
        local font_zip="/tmp/Lilex.zip"
        curl -fsSL "$font_url" -o "$font_zip"
        unzip -o "$font_zip" -d "$font_dir/Lilex"
        rm -f "$font_zip"
        fc-cache -fv
    fi
}

# =============================================================================
# Main
# =============================================================================

main() {
    detect_distro
    install_apt_packages
    setup_extrepo

    echo ""
    read -p "Install GUI apps (WezTerm, Zed, JetBrains Toolbox)? [y/N] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_wezterm
        install_zed
        install_jetbrains_toolbox
    fi

    read -p "Install keyd for keyboard remapping? [y/N] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_keyd
    fi

    install_fonts

    echo ""
    echo "Linux packages installed!"
    echo "Run install-linux.sh for full setup including Linuxbrew."
}

main "$@"
