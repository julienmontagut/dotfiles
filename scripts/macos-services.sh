#!/bin/bash
# macOS services configuration
# Sets up TouchID for sudo, JankyBorders, and other services

set -euo pipefail

echo "Configuring macOS services..."

# =============================================================================
# TouchID for sudo
# =============================================================================

setup_touchid_sudo() {
    echo "Setting up TouchID for sudo..."

    local pam_file="/etc/pam.d/sudo_local"
    local touchid_line="auth       sufficient     pam_tid.so"

    # Check if already configured
    if [[ -f "$pam_file" ]] && grep -q "pam_tid.so" "$pam_file" 2>/dev/null; then
        echo "TouchID for sudo is already configured."
        return
    fi

    # Create sudo_local file with TouchID support
    echo "Creating $pam_file (requires sudo)..."
    sudo tee "$pam_file" > /dev/null << 'EOF'
# sudo_local: local config file which survives system update
auth       sufficient     pam_tid.so
EOF

    echo "TouchID for sudo enabled."
}

# =============================================================================
# JankyBorders LaunchAgent
# =============================================================================

setup_jankyborders() {
    echo "Setting up JankyBorders..."

    local plist_dir="$HOME/Library/LaunchAgents"
    local plist_file="$plist_dir/com.felixkratz.borders.plist"
    local borders_path

    # Find borders binary
    if [[ -x "/opt/homebrew/bin/borders" ]]; then
        borders_path="/opt/homebrew/bin/borders"
    elif [[ -x "/usr/local/bin/borders" ]]; then
        borders_path="/usr/local/bin/borders"
    else
        echo "Warning: borders binary not found. Install via: brew install FelixKratz/formulae/borders"
        return
    fi

    # Create LaunchAgents directory if needed
    mkdir -p "$plist_dir"

    # Unload existing plist if present
    if launchctl list | grep -q "com.felixkratz.borders"; then
        launchctl unload "$plist_file" 2>/dev/null || true
    fi

    # Create plist file
    cat > "$plist_file" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.felixkratz.borders</string>
    <key>ProgramArguments</key>
    <array>
        <string>$borders_path</string>
        <string>active_color=0xff7aa2f7</string>
        <string>inactive_color=0xff565f89</string>
        <string>width=5.0</string>
        <string>style=round</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

    # Load the launch agent
    launchctl load "$plist_file"

    echo "JankyBorders configured and started."
}

# =============================================================================
# AeroSpace
# =============================================================================

setup_aerospace() {
    echo "Setting up AeroSpace..."

    # AeroSpace manages its own startup via start-at-login in config
    # Just verify it's installed
    if [[ -d "/Applications/AeroSpace.app" ]]; then
        echo "AeroSpace is installed. It will start at login based on config."
    else
        echo "Warning: AeroSpace not found in /Applications. Install via: brew install --cask aerospace"
    fi
}

# =============================================================================
# Run setup
# =============================================================================

setup_touchid_sudo
setup_jankyborders
setup_aerospace

echo ""
echo "Services configured successfully!"
echo "Note: TouchID for sudo requires authentication on next sudo use."
