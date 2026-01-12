#!/bin/bash

set -euo pipefail

# Set non-interactive frontend for package installations
export DEBIAN_FRONTEND=noninteractive

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SCRIPT_USER="${SUDO_USER:-$USER}"
SCRIPT_HOME=$(getent passwd "$SCRIPT_USER" | cut -d: -f6)
SKIP_NIX=false

# Parse arguments
if [[ "${1:-}" == "--skip-nix" ]]; then
    SKIP_NIX=true
fi

log() {
    echo -e "${BLUE}[INFO]${NC} $1"; 
}
success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1";
}
error() {
    echo -e "${RED}[ERROR]${NC} $1"; exit 1;
}

# Check root
if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root (use sudo)"
fi

# Detect package manager and define functions (ready for multi-OS support)
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    pkg() {
        case "$1" in
            update)   apt update ;;
            upgrade)  apt upgrade -y ;;
            install)  shift; apt install -y "$@" ;;
            remove)   shift; apt remove --purge -y "$@" ;;
            cleanup)  apt autoremove -y && apt autoclean ;;
            *)        error "Unknown package command: $1" ;;
        esac
    }
else
    error "Unsupported package manager. Currently only apt-based systems are supported."
fi

# Define packages to install (categorized for readability)
# Note: Package names may need to be adjusted for different distributions
#
PACKAGES_CORE=(
    build-essential
    curl
    neovim
)

PACKAGES_SWAY=(
    sway
    sway-backgrounds
    swayidle
    swaylock
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
)

PACKAGES_GNOME=(
    gnome-console
    gnome-boxes
    gnome-firmware
    gnome-builder
    gnome-software
    gnome-software-plugin-flatpak
)

PACKAGES_CONTAINERS=(
    podman
    podman-compose
    podman-docker
)

# Update system
log "Updating system packages..."
pkg update
pkg upgrade

# Install packages by category
log "Installing core utilities..."
pkg install "${PACKAGES_CORE[@]}"

log "Installing Wayland/Sway..."
pkg install "${PACKAGES_SWAY[@]}"

log "Installing GNOME applications..."
pkg install "${PACKAGES_GNOME[@]}"

log "Installing container tools..."
pkg install "${PACKAGES_CONTAINERS[@]}"

# Configure keyboard (US Dvorak, Caps Lock as Hyper/Ctrl)
log "Configuring keyboard..."
cat > /etc/default/keyboard <<'EOF'
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT="dvorak"
XKBOPTIONS="ctrl:hyper_capscontrol"
BACKSPACE="guess"
EOF
setupcon -k || true

# Configure locale
log "Configuring locale..."
locale -a | grep -q "^en_US.utf8$" || locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

# Block snapd (Debian/Ubuntu specific)
log "Blocking snapd..."
if dpkg -l | grep -q snapd; then
    systemctl stop snapd.service snapd.socket || true
    pkg remove snapd
fi
cat > /etc/apt/preferences.d/nosnap <<'EOF'
Package: snapd
Pin: release *
Pin-Priority: -1
EOF
apt-mark hold snapd 2>/dev/null || true

# Configure Flatpak and install Firefox
log "Installing Flatpak..."
pkg install flatpak

log "Configuring Flatpak and installing Firefox..."
sudo -u "$SCRIPT_USER" flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo -u "$SCRIPT_USER" flatpak install -y --user flathub org.mozilla.firefox
sudo -u "$SCRIPT_USER" xdg-settings set default-web-browser org.mozilla.firefox.desktop

# Setup zsh as user shell
log "Installing and configuring zsh..."
pkg install zsh
if [[ $(getent passwd "$SCRIPT_USER" | cut -d: -f7) != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)" "$SCRIPT_USER"
    success "User shell changed to zsh"
else
    log "User shell already set to zsh"
fi

# Install Nix
if [[ "$SKIP_NIX" == "false" ]]; then
    if [[ -d "/nix" ]] && sudo -u "$SCRIPT_USER" bash -c 'command -v nix' &> /dev/null; then
        log "Nix already installed"
    else
        log "Installing Nix..."
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

        # Add Nix to .profile
        if ! grep -q "nix-daemon.sh" "$SCRIPT_HOME/.profile" 2>/dev/null; then
            sudo -u "$SCRIPT_USER" tee -a "$SCRIPT_HOME/.profile" > /dev/null <<'EOF'

# Nix package manager
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
EOF
        fi
    fi
fi

# Set neovim as default editor
if command -v nvim &> /dev/null; then
    update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 30 || true
    update-alternatives --set vim /usr/bin/nvim 2>/dev/null || true
    update-alternatives --set editor /usr/bin/nvim 2>/dev/null || true
fi

# Cleanup
log "Cleaning up..."
pkg cleanup

# Print instructions
cat <<EOF

${GREEN}========================================${NC}
${GREEN}Setup completed successfully!${NC}
${GREEN}========================================${NC}

${BLUE}Next steps:${NC}

1. Log out and log back in for group changes to take effect

2. Install Home Manager:
   $ nix run home-manager/master -- init --switch

3. Install additional Flatpak applications:
   $ flatpak install flathub org.mozilla.Thunderbird
   $ flatpak install flathub com.github.IsmaelMartinez.teams_for_linux

4. Configure SSH keys:
   $ ssh-keygen -t ed25519 -C "your_email@example.com"

5. Configure git:
   $ git config --global user.name "Your Name"
   $ git config --global user.email "your.email@example.com"

EOF

success "Setup completed!"
