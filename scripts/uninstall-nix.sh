#!/bin/bash
# Nix uninstallation script
# Removes Nix, nix-darwin, and home-manager completely

set -euo pipefail

echo "=============================================="
echo "       Nix Uninstallation"
echo "=============================================="
echo ""
echo "WARNING: This will completely remove Nix from your system!"
echo ""
read -p "Are you sure you want to continue? [y/N] " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# =============================================================================
# Detect platform
# =============================================================================

if [[ "$(uname)" == "Darwin" ]]; then
    IS_MACOS=true
else
    IS_MACOS=false
fi

# =============================================================================
# Stop nix-daemon
# =============================================================================

stop_nix_daemon() {
    echo "Stopping Nix daemon..."

    if $IS_MACOS; then
        sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
        sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist
    else
        sudo systemctl stop nix-daemon.service 2>/dev/null || true
        sudo systemctl disable nix-daemon.socket nix-daemon.service 2>/dev/null || true
        sudo rm -f /etc/systemd/system/nix-daemon.service
        sudo rm -f /etc/systemd/system/nix-daemon.socket
        sudo systemctl daemon-reload
    fi
}

# =============================================================================
# Unload home-manager
# =============================================================================

unload_home_manager() {
    echo "Removing home-manager..."

    # Deactivate home-manager if available
    if command -v home-manager &>/dev/null; then
        home-manager uninstall 2>/dev/null || true
    fi

    # Remove home-manager state
    rm -rf "$HOME/.local/state/home-manager"
    rm -rf "$HOME/.local/state/nix"
}

# =============================================================================
# Unload nix-darwin (macOS only)
# =============================================================================

unload_nix_darwin() {
    if ! $IS_MACOS; then
        return
    fi

    echo "Removing nix-darwin..."

    # Unload nix-darwin services
    if [[ -f /run/current-system/sw/bin/darwin-uninstaller ]]; then
        /run/current-system/sw/bin/darwin-uninstaller 2>/dev/null || true
    fi
}

# =============================================================================
# Remove Nix files
# =============================================================================

remove_nix_files() {
    echo "Removing Nix files..."

    # Remove /nix
    sudo rm -rf /nix

    # Remove Nix config
    sudo rm -rf /etc/nix

    # Remove Nix profiles
    rm -rf "$HOME/.nix-profile"
    rm -rf "$HOME/.nix-defexpr"
    rm -rf "$HOME/.nix-channels"
    rm -rf "$HOME/.cache/nix"
    rm -rf "$HOME/.local/state/nix"

    # Remove from XDG locations
    rm -rf "$HOME/.config/nix"
    rm -rf "$HOME/.config/nixpkgs"
}

# =============================================================================
# Clean shell profiles
# =============================================================================

clean_shell_profiles() {
    echo "Cleaning shell profiles..."

    local profiles=(
        "$HOME/.bashrc"
        "$HOME/.bash_profile"
        "$HOME/.zshrc"
        "$HOME/.zshenv"
        "$HOME/.profile"
    )

    for profile in "${profiles[@]}"; do
        if [[ -f "$profile" ]]; then
            echo "  Cleaning: $profile"
            # Remove nix-related lines
            sed -i.bak '/nix/d' "$profile" 2>/dev/null || true
            sed -i.bak '/home-manager/d' "$profile" 2>/dev/null || true
            rm -f "${profile}.bak"
        fi
    done
}

# =============================================================================
# Remove nixbld users/groups (macOS)
# =============================================================================

remove_nixbld_users() {
    if ! $IS_MACOS; then
        echo "Removing nixbld users (Linux)..."
        for i in $(seq 1 32); do
            sudo userdel "nixbld$i" 2>/dev/null || true
        done
        sudo groupdel nixbld 2>/dev/null || true
        return
    fi

    echo "Removing nixbld users and groups (macOS)..."

    # Remove nixbld users
    for i in $(seq 1 32); do
        local user="_nixbld$i"
        if dscl . -read "/Users/$user" &>/dev/null; then
            sudo dscl . -delete "/Users/$user" 2>/dev/null || true
        fi
    done

    # Remove nixbld group
    if dscl . -read /Groups/nixbld &>/dev/null; then
        sudo dscl . -delete /Groups/nixbld 2>/dev/null || true
    fi
}

# =============================================================================
# Clean synthetic.conf (macOS)
# =============================================================================

clean_synthetic_conf() {
    if ! $IS_MACOS; then
        return
    fi

    echo "Cleaning /etc/synthetic.conf..."

    if [[ -f /etc/synthetic.conf ]]; then
        sudo sed -i.bak '/^nix/d' /etc/synthetic.conf
        sudo rm -f /etc/synthetic.conf.bak

        # Remove file if empty
        if [[ ! -s /etc/synthetic.conf ]]; then
            sudo rm -f /etc/synthetic.conf
        fi
    fi
}

# =============================================================================
# Clean fstab (macOS)
# =============================================================================

clean_fstab() {
    if ! $IS_MACOS; then
        return
    fi

    echo "Cleaning /etc/fstab..."

    if [[ -f /etc/fstab ]]; then
        sudo sed -i.bak '/nix/d' /etc/fstab 2>/dev/null || true
        sudo rm -f /etc/fstab.bak
    fi
}

# =============================================================================
# Restore shell files
# =============================================================================

restore_system_files() {
    if ! $IS_MACOS; then
        return
    fi

    echo "Restoring system files..."

    # Restore /etc/bashrc if backed up
    if [[ -f /etc/bashrc.backup-before-nix ]]; then
        sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
    fi

    # Restore /etc/zshrc if backed up
    if [[ -f /etc/zshrc.backup-before-nix ]]; then
        sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
    fi
}

# =============================================================================
# Main
# =============================================================================

main() {
    stop_nix_daemon
    unload_home_manager
    unload_nix_darwin
    remove_nix_files
    clean_shell_profiles
    remove_nixbld_users
    clean_synthetic_conf
    clean_fstab
    restore_system_files

    echo ""
    echo "=============================================="
    echo "       Nix Uninstallation Complete!"
    echo "=============================================="
    echo ""
    echo "Please reboot your system to complete the uninstallation."
    echo ""

    if $IS_MACOS; then
        echo "After reboot, verify removal with:"
        echo "  ls -la /nix  # Should not exist"
        echo "  which nix    # Should return nothing"
    fi
}

main "$@"
