#!/bin/bash
# Installs GNOME extensions and configures the desktop environment

set -euo pipefail

# All required tools are in the gnome-shell dependency tree on Debian 13
for cmd in gnome-shell gsettings dconf curl python3; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd not found. Is GNOME installed?"
        exit 1
    fi
done

# gnome-shell-extensions provides the gnome-extensions CLI
if ! command -v gnome-extensions >/dev/null 2>&1; then
    echo "Installing gnome-shell-extensions..."
    sudo apt install -y gnome-shell-extensions
fi

GNOME_SHELL_VERSION=$(gnome-shell --version | grep -oP '[\d.]+' | head -1 | cut -d. -f1)

ENABLE_EXTENSIONS=(
    "forge@jmmaranan.com"
    "just-perfection-desktop@just-perfection"
    "space-bar@luchrioh"
    "arcmenu@arcmenu.com"
)

DISABLE_EXTENSIONS=(
    "ubuntu-dock@ubuntu.com"
    "tiling-assistant@ubuntu.com"
    "ubuntu-appindicators@ubuntu.com"
    "ding@rastersoft.com"
)

echo "=============================================="
echo "       GNOME Desktop Customization"
echo "=============================================="
echo ""

install_extension() {
    local uuid="$1"

    if echo "$INSTALLED_EXTENSIONS" | grep -q "^${uuid}$"; then
        echo "  Already installed: $uuid"
        return 0
    fi

    echo "  Installing: $uuid"

    local info_url="https://extensions.gnome.org/extension-info/?uuid=${uuid}&shell_version=${GNOME_SHELL_VERSION}"
    local download_url

    download_url=$(curl -s "$info_url" | python3 -c "import sys,json; print(json.load(sys.stdin)['download_url'])" 2>/dev/null) || {
        echo "  Warning: Could not find $uuid for GNOME Shell $GNOME_SHELL_VERSION"
        return 0
    }

    local zip_file="/tmp/gnome-ext-${uuid}.zip"
    curl -fsSL "https://extensions.gnome.org${download_url}" -o "$zip_file"
    gnome-extensions install --force "$zip_file"
    rm -f "$zip_file"

    echo "  Installed: $uuid"
}

echo "Installing GNOME extensions..."

INSTALLED_EXTENSIONS=$(gnome-extensions list 2>/dev/null)

for ext in "${ENABLE_EXTENSIONS[@]}"; do
    install_extension "$ext"
done

# Build gsettings arrays from the extension lists
enabled_str=$(printf "'%s', " "${ENABLE_EXTENSIONS[@]}")
disabled_str=$(printf "'%s', " "${DISABLE_EXTENSIONS[@]}")

echo ""
echo "General settings"

gsettings set org.gnome.desktop.datetime automatic-timezone true

echo "Configuring desktop interface..."

gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface monospace-font-name 'Lilex Nerd Font Mono 13'

echo "Configuring input sources..."

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+dvorak')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"

echo "Configuring mouse and touchpad..."

gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true
gsettings set org.gnome.desktop.peripherals.mouse speed 0.6
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.6
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true

echo "Configuring privacy and session..."

gsettings set org.gnome.desktop.privacy old-files-age 30
gsettings set org.gnome.desktop.privacy recent-files-max-age -1
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.sound event-sounds false

echo "Configuring WM keybindings..."

gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"
gsettings set org.gnome.desktop.wm.keybindings maximize "[]"
gsettings set org.gnome.desktop.wm.keybindings unmaximize "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "[]"

# Move window to workspace by number
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"

echo "Configuring WM preferences..."

gsettings set org.gnome.desktop.wm.preferences auto-raise true
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,close'
gsettings set org.gnome.desktop.wm.preferences focus-mode 'click'
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

echo "Configuring Mutter..."

gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.mutter edge-tiling false
gsettings set org.gnome.mutter workspaces-only-on-primary true

echo "Configuring GNOME Shell..."

gsettings set org.gnome.shell disable-user-extensions false
gsettings set org.gnome.shell disabled-extensions "[${disabled_str%, }]"
gsettings set org.gnome.shell enabled-extensions "[${enabled_str%, }]"

echo "Configuring Forge extension..."

dconf write /org/gnome/shell/extensions/forge/auto-split-enabled false
dconf write /org/gnome/shell/extensions/forge/focus-on-hover-enabled true
dconf write /org/gnome/shell/extensions/forge/move-pointer-focus-enabled true

echo "Configuring Just Perfection extension..."

dconf write /org/gnome/shell/extensions/just-perfection/accessibility-menu false
dconf write /org/gnome/shell/extensions/just-perfection/animation 4
dconf write /org/gnome/shell/extensions/just-perfection/clock-menu-position 1
dconf write /org/gnome/shell/extensions/just-perfection/clock-menu-position-offset 10
dconf write /org/gnome/shell/extensions/just-perfection/events-button false
dconf write /org/gnome/shell/extensions/just-perfection/notification-banner-position 2
dconf write /org/gnome/shell/extensions/just-perfection/overlay-key false
dconf write /org/gnome/shell/extensions/just-perfection/ripple-box false
dconf write /org/gnome/shell/extensions/just-perfection/world-clock false

echo "Configuring Space Bar extension..."

dconf write /org/gnome/shell/extensions/space-bar/behavior/scroll-wheel "'disabled'"
dconf write /org/gnome/shell/extensions/space-bar/behavior/toggle-overview false
dconf write /org/gnome/shell/extensions/space-bar/shortcuts/enable-move-to-workspace-shortcuts true

echo "Configuring ArcMenu extension..."

dconf write /org/gnome/shell/extensions/arcmenu/dash-to-panel-standalone true
dconf write /org/gnome/shell/extensions/arcmenu/default-menu-view-runner "'Frequent Apps'"
dconf write /org/gnome/shell/extensions/arcmenu/force-menu-location "'TopCentered'"
dconf write /org/gnome/shell/extensions/arcmenu/hide-overview-on-arcmenu-open true
dconf write /org/gnome/shell/extensions/arcmenu/hide-overview-on-startup true
dconf write /org/gnome/shell/extensions/arcmenu/menu-button-appearance "'None'"
dconf write /org/gnome/shell/extensions/arcmenu/menu-layout "'Elementary'"
dconf write /org/gnome/shell/extensions/arcmenu/multi-monitor true
dconf write /org/gnome/shell/extensions/arcmenu/position-in-panel "'Center'"
dconf write /org/gnome/shell/extensions/arcmenu/runner-hotkey "['<Alt>space', '<Super>space']"
dconf write /org/gnome/shell/extensions/arcmenu/runner-hotkey-overlay-key-enabled true
dconf write /org/gnome/shell/extensions/arcmenu/runner-show-settings-button false
dconf write /org/gnome/shell/extensions/arcmenu/search-entry-border-radius "(true, 12)"
dconf write /org/gnome/shell/extensions/arcmenu/search-provider-open-windows true
dconf write /org/gnome/shell/extensions/arcmenu/max-search-results 6

echo ""
echo "Done! Log out and back in for changes to take effect."

