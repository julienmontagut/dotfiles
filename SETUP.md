# Setup Documentation

This document describes the setup process for both macOS and Linux systems.

## Architecture: The Three-Layer Model

This dotfiles repository uses a layered strategy:

### Layer 1: Package Managers (CLI tools + GUI apps)

**macOS (Homebrew):** All CLI tools and GUI apps via `brew bundle` from `./Brewfile`.

**Linux (APT + Linuxbrew):** System packages via APT (`scripts/linux-packages.sh`), CLI tools via Linuxbrew (`./Brewfile`).

### Layer 2: Dotter (Configuration deployment)

Symlinks config files from this repo to their correct locations. Managed by `.dotter/global.toml` with platform-specific overrides in `.dotter/local.toml`.

### Layer 3: Tracked Documentation (Manual setup)

Items documented in this file: GNOME/KDE settings, system-level configs, SSH/GPG keys, cloud sync services.

---

## macOS Setup

### Quick Start

```bash
# 1. Install CLI tools and GUI apps from Brewfile
brew bundle --file=./Brewfile

# 2. Deploy configs via Dotter
dotter deploy

# 3. Apply macOS defaults
bash scripts/macos-defaults.sh
```

### What Gets Installed

**Via Homebrew (`./Brewfile`):**
- CLI tools: neovim, ripgrep, fd, fzf, bat, eza, jq, starship, zoxide, lazygit, etc.
- Window management: AeroSpace, Karabiner Elements, JankyBorders
- Terminals: Alacritty, WezTerm
- Editors: Zed
- IDE: JetBrains Toolbox
- Other: Claude, OrbStack, Spotify, etc.

**Via Dotter:**
- Shell config (zsh, starship)
- Git config
- Editor configs (Neovim, Zed, IdeaVim)
- Terminal configs (Alacritty, WezTerm, tmux)
- Window manager configs (AeroSpace, Karabiner, Borders)

### JetBrains IDE Setup

1. Install JetBrains Toolbox via Homebrew (included in Brewfile)
2. Open JetBrains Toolbox and sign in
3. Install desired IDEs (GoLand, Rider, WebStorm, etc.)
4. IDEs auto-update via Toolbox

---

## Linux (Ubuntu 24.04 / Debian 13) Setup

### Quick Start

```bash
# 1. Run the full Linux install script
bash scripts/install-linux.sh
```

This script runs the following steps in order:
1. Backs up existing configs
2. Installs APT packages (`scripts/linux-packages.sh`)
3. Installs Linuxbrew
4. Installs CLI tools from Brewfile
5. Sets up Dotter and deploys configs
6. Configures keyd (keyboard remapping)
7. Sets zsh as default shell

### Or step-by-step

```bash
# 1. Install system packages
bash scripts/linux-packages.sh

# 2. Install CLI tools from Brewfile
brew bundle --file=./Brewfile --no-lock

# 3. Deploy configs via Dotter
cp .dotter/local.toml.example .dotter/local.toml  # edit for your platform
dotter deploy

# 4. Set zsh as default shell
chsh -s $(which zsh)
```

### What Gets Installed

**Via APT (scripts/linux-packages.sh):**
- Core: build-essential, curl, git, wget, zsh, unzip
- Optional GUI apps: WezTerm, Zed, JetBrains Toolbox
- Keyboard remapping: keyd
- Fonts: Lilex Nerd Font

**Via Linuxbrew (Brewfile):**
- CLI tools: neovim, ripgrep, fd, fzf, bat, eza, jq, starship, zoxide, lazygit, etc.
- Language servers: bash-language-server, lua-language-server, helm-ls, yaml-language-server, etc.
- Kubernetes: kubectl, kubectx, k9s, kind, helm

**Via Dotter:**
- Shell config (zsh, starship)
- Git config
- Editor configs (Neovim, Zed, IdeaVim)
- Terminal configs (Alacritty, WezTerm, tmux)
- Sway, Waybar, Kanshi, Fuzzel configs
- keyd config

### JetBrains IDE Setup on Linux

1. Run `scripts/linux-packages.sh` which offers to install JetBrains Toolbox
2. Run `jetbrains-toolbox` once to complete setup
3. Install desired IDEs via Toolbox

Or use Flatpak:
```bash
flatpak install flathub com.jetbrains.GoLand
flatpak install flathub com.jetbrains.WebStorm
```

---

## Detailed Linux System Setup

### System Packages (via APT on a fresh install)

If setting up a fresh Ubuntu/Debian machine, you may also need:

**Sway & Wayland:**
- `sway`, `waybar`, `kanshi`, `fuzzel`, `wl-clipboard`
- `xdg-desktop-portal-wlr`, `xdg-desktop-portal-gtk`

**Containerization:**
- `podman`, `podman-compose`, `podman-docker`

**Active Directory Integration:**
- `realmd`, `sssd`, `sssd-tools`, `adcli`
- `samba`, `samba-common`, `samba-common-bin`
- `oddjob`, `oddjob-mkhomedir`

**Security:**
- `fail2ban`, `openssh-server`

**Development:**
- `dotnet8` (.NET SDK 8.0)

**Utilities:**
- `keepassxc`, `vlc`, `remmina`, `caffeine`
- `flatpak`, `extrepo`

## System Configuration

### Keyboard Layout
- **Layout:** US Dvorak
- **Caps Lock:** Remapped to Hyper/Ctrl (via keyd)
- keyd config: `config/keyd/default.conf`

### Locale
- **Default:** en_US.UTF-8

### Snapd
- **Blocked** - Snapd is removed and prevented from installation
- Preference file: `/etc/apt/preferences.d/nosnap`

### Sway Configuration
- Config deployed via Dotter to `~/.config/sway/config`
- Start with `sway` if not using a display manager

## Post-Installation Steps

### 1. Log Out and Log Back In

For group changes and Linuxbrew PATH to be available.

### 2. Install Flatpak Applications

```bash
# Web browsers
flatpak install flathub org.mozilla.firefox

# Email client
flatpak install flathub org.mozilla.Thunderbird

# Communication
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
```

### 3. Configure Custom CA Certificates

If you're in a corporate environment with custom CA certificates:

```bash
# Copy your organization's CA certificates
sudo cp /path/to/your/*.crt /usr/local/share/ca-certificates/

# Update certificate store
sudo update-ca-certificates
```

Example certificate names from your environment:
- `ADROOT-CA.chain.crt`
- `CATO-CDBDX-SUBCA.chain.crt`
- `CatoNetworksRootCA.crt`
- `CatoNetworksTrustedRootCA.crt`
- `CDBDX_CA.chain.crt`
- `CDWEB_CA.chain.crt`

### 4. Set Up SSH Keys

```bash
# Generate SSH key (Ed25519 recommended)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## Optional Configurations

### Active Directory Integration

```bash
# Join domain
sudo realm join -U admin_user your.domain.com

# Enable home directory creation
sudo systemctl enable oddjobd.service
sudo systemctl start oddjobd.service
```

### Cato Networks VPN

```bash
# Start VPN connection
cato-sdp start --account your-account --user your.email@domain.com

# Stop VPN
cato-sdp stop

# Reset credentials
cato-sdp start --account your-account --user your.email@domain.com --reset-cred
```

### Podman Configuration

```bash
# Use podman as docker
docker ps  # Actually runs: podman ps

# Docker Compose compatibility
docker-compose up  # Uses podman-compose
```

## Recommended Workflow

1. **Run install script** on fresh OS installation (`scripts/install-linux.sh` or `scripts/install-macos.sh`)
2. **Log out and log back in** (activate Linuxbrew PATH and groups)
3. **Install Flatpak apps** as needed
4. **Configure org-specific items** (CA certs, AD, VPN)

## Troubleshooting

### Linuxbrew Not Available After Installation

```bash
# Manually source Linuxbrew:
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### Podman Permission Issues

```bash
# Verify user is in docker group
groups

# If not, log out and log back in, or run:
newgrp docker
```

### Flatpak Issues

```bash
# Reset Flatpak repositories
flatpak remote-delete flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Repair Flatpak installation
flatpak repair
```

### Dotter Issues

```bash
# Dry-run to see what would be deployed
dotter deploy --dry-run

# Force deploy (overwrite existing files)
dotter deploy --force

# Check local.toml is correct
cat .dotter/local.toml
```

## File Locations

### System Configuration
- Keyboard: `/etc/default/keyboard`, keyd: `/etc/keyd/default.conf`
- Snapd block: `/etc/apt/preferences.d/nosnap`
- SSH config: `/etc/ssh/sshd_config`
- fail2ban: `/etc/fail2ban/`

### User Configuration (managed by Dotter)
- Git: `~/.config/git/config`
- Zsh: `~/.config/zsh/.zshrc`, `~/.zshenv`
- Starship: `~/.config/starship.toml`
- Neovim: `~/.config/nvim/`
- WezTerm: `~/.config/wezterm/`
- Sway: `~/.config/sway/config`
- Waybar: `~/.config/waybar/`

### Logs
- System logs: `journalctl -xe`
- fail2ban: `sudo journalctl -u fail2ban`
- SSH: `sudo journalctl -u ssh`

## Maintenance

### Update System Packages

```bash
sudo apt update && sudo apt upgrade
```

### Update Linuxbrew Packages

```bash
brew update && brew upgrade
```

### Update Flatpak Applications

```bash
flatpak update
```

## Backup Recommendations

Important directories to backup:

```
~/.config/              # User configurations (dotfiles)
~/.ssh/                 # SSH keys
~/.gnupg/              # GPG keys
~/Documents/           # Personal documents
~/Sources/             # Source code repositories
/usr/local/share/ca-certificates/  # Custom CA certificates
```

## Additional Resources

- [Homebrew](https://brew.sh/)
- [Dotter](https://github.com/SuperCuber/dotter)
- [Sway User Wiki](https://github.com/swaywm/sway/wiki)
- [Flatpak Application Repository](https://flathub.org/)
