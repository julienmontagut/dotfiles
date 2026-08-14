#!/bin/bash
# TouchID for sudo. The one macOS service that mise can't do declaratively: it edits a
# root-owned file under /etc/pam.d. JankyBorders and SketchyBar are
# [bootstrap.macos.launchd.agents] entries in config/mise/config.macos.toml.
# Run by [tasks.bootstrap] during `mise bootstrap` (macOS only).
set -euo pipefail

pam_file="/etc/pam.d/sudo_local"

if [[ -f "$pam_file" ]] && grep -q "pam_tid.so" "$pam_file" 2>/dev/null; then
    echo "TouchID for sudo already configured."
    exit 0
fi

echo "Creating $pam_file (requires sudo)..."
sudo tee "$pam_file" > /dev/null << 'EOF'
# sudo_local: local config file which survives system update
auth       sufficient     pam_tid.so
EOF

echo "TouchID for sudo enabled."
