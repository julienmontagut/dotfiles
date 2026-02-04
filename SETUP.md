# Setup Documentation

This document describes the setup process for both macOS and Linux systems.

## Architecture: The Three-Layer Model

This dotfiles repository uses a layered strategy that plays to each tool's strengths:

### Layer 1: Nix/Home Manager (Configuration + Stable CLI)

Managed by Home Manager (`home-manager switch --flake .#macos` or `.#linux`):
- Shell configuration (zsh, starship, fzf, etc.)
- Neovim configuration and plugins
- CLI development tools (ripgrep, fd, jq, kubectl, etc.)
- Git configuration
- Dotfile symlinks (XDG config files)
- Environment variables and PATH management

### Layer 2: Native Package Managers (GUI Applications)

**macOS (Homebrew):** Window managers (AeroSpace, Karabiner), terminals (WezTerm), browsers (Firefox), IDEs (JetBrains Toolbox)

**Linux (APT/DNF):** Sway, Waybar, WezTerm, system packages

### Layer 3: Tracked Documentation (Manual Setup)

Items documented in this file: GNOME/KDE settings, system-level configs, SSH/GPG keys, cloud sync services.

---

## macOS Setup

### Quick Start

```bash
# Run the bootstrap script (installs Nix, Homebrew, and GUI apps)
./scripts/bootstrap.sh

# Apply Home Manager configuration
home-manager switch --flake .#macos
```

### What Gets Installed

**Via Homebrew (scripts/Brewfile):**
- Window management: AeroSpace, Karabiner Elements, JankyBorders
- Terminal: WezTerm
- Browser: Firefox
- IDE: JetBrains Toolbox

**Via Home Manager:**
- CLI tools, Neovim, Zsh, Git configuration
- Application configs (WezTerm, Karabiner, AeroSpace)

### JetBrains IDE Setup

1. Install JetBrains Toolbox via Homebrew (included in Brewfile)
2. Open JetBrains Toolbox and sign in
3. Install desired IDEs (GoLand, Rider, WebStorm, etc.)
4. IDEs auto-update via Toolbox

---

## Linux (Ubuntu 24.04 / Debian 13) Setup

This section describes setting up a fresh Ubuntu 24.04 LTS, Debian 13, or Debian Testing installation.

### Quick Start

```bash
# 1. Run system setup (installs sway, podman, etc.)
sudo ./platforms/wsl/setup-ubuntu.sh

# 2. Log out and log back in

# 3. Apply Home Manager configuration
home-manager switch --flake .#linux
```

### What Gets Installed

**Via APT (system packages):**
- Sway, Waybar, WezTerm (system)
- Podman, build tools, SSH, fail2ban

**Via Home Manager:**
- CLI tools, Neovim, Zsh, Git configuration
- Sway/Waybar configuration (config only, not packages)

### JetBrains IDE Setup on Linux

1. Download JetBrains Toolbox from [jetbrains.com/toolbox-app](https://www.jetbrains.com/toolbox-app/)
2. Extract and run the AppImage
3. Install desired IDEs via Toolbox

Or use Flatpak:
```bash
flatpak install flathub com.jetbrains.GoLand
flatpak install flathub com.jetbrains.WebStorm
```

---

## Detailed Linux Setup

### Important: Separation of Concerns

The system setup script **ONLY** installs system-level packages. It does **NOT** install:

- Home Manager or any Home Manager configuration
- User-level packages (zsh, neovim, CLI tools, etc.)
- User dotfiles or configurations
- Applications managed by Nix/Home Manager

After running the system script, you should:
1. Install Home Manager separately
2. Use your own dotfiles installation script to set up your user environment
3. Install user-level packages via Home Manager flake configuration

## Quick Start

```bash
# Run the setup script with sudo on a fresh Ubuntu 24.04 LTS installation
sudo ./setup-ubuntu.sh
```

## Script Options

```bash
sudo ./setup-ubuntu.sh [OPTIONS]

Options:
  --skip-nix    Skip Nix package manager installation
  --skip-apt    Skip APT package installation
  --help        Show help message
```

## What Gets Installed

### System Packages (via APT)

**Core Utilities:**
- Development tools: `build-essential`, `git`, `curl`, `wget`
- Text editor: `neovim` (configured as `vim` replacement via alternatives)
- Compression: `p7zip`, `unrar`, `unzip`, `bzip2`, `gzip`

**Sway & Wayland:**
- `sway`, `sway-backgrounds`, `swayidle`, `swaylock`
- `wdisplays`
- `xdg-desktop-portal-wlr`, `xdg-desktop-portal-gtk`

**GNOME Tools (Minimal):**
- `gnome-console`, `gnome-boxes`, `gnome-firmware`, `gnome-builder`

**Containerization:**
- `podman`, `podman-compose`, `podman-docker`

**Active Directory Integration:**
- `realmd`, `sssd`, `sssd-tools`, `adcli`
- `samba`, `samba-common`, `samba-common-bin`
- `oddjob`, `oddjob-mkhomedir`

**Security:**
- `fail2ban`
- `openssh-server`

**Development:**
- `dotnet8` (.NET SDK 8.0)

**Utilities:**
- `keepassxc`, `vlc`, `remmina`, `caffeine`
- `flatpak`, `extrepo`

### Nix Package Manager

Installed using **Determinate Systems installer** which provides:
- Multi-user daemon mode (systemd service)
- Better performance and reliability
- Automatic updates and maintenance
- Flakes enabled by default

### Packages NOT Installed (Managed by Home Manager)

User-level packages and configurations are managed separately via your dotfiles and Home Manager configuration.

## System Configuration

### Keyboard Layout
- **Layout:** US Dvorak
- **Caps Lock:** Remapped to Hyper/Ctrl
- Configuration file: `/etc/default/keyboard`

### Locale
- **Default:** en_US.UTF-8

### Editor/Vim
- **Neovim** is installed via APT as the system editor
- `vim` command is aliased to `nvim` via update-alternatives
- `editor` is set to `nvim`
- This provides a consistent vim experience for both regular and sudo operations

### Snapd
- **Blocked** - Snapd is removed and prevented from installation
- Preference file: `/etc/apt/preferences.d/nosnap`

### Sway Configuration
- Config directory created: `~/.config/sway/`
- **No config file created** - populate via your dotfiles

## Post-Installation Steps

### 1. Log Out and Log Back In

For group changes (docker group) and Nix to be available in your PATH.

### 2. Install Home Manager

After logging back in, install Home Manager:

```bash
# Initialize Home Manager
nix run home-manager/master -- init --switch

# Or if you have existing dotfiles with Home Manager flake:
# Use your custom dotfiles installation script
```

### 3. Run Your Dotfiles Installation Script

Use your own dotfiles script to:
- Clone your dotfiles repository
- Set up Home Manager with your flake configuration
- Install user-level packages
- Configure shell (zsh), editor (neovim), etc.

### 4. Install Flatpak Applications

```bash
# Web browsers
flatpak install flathub org.mozilla.firefox

# Email client
flatpak install flathub org.mozilla.Thunderbird

# Communication
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
```

### 5. Configure Custom CA Certificates

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

### 6. Set Up SSH Keys

```bash
# Generate SSH key (Ed25519 recommended)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Or RSA if required by your organization
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Add key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### 7. Configure Git

This should be done via your Home Manager config, but if needed manually:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Optional Configurations

### Active Directory Integration

Configure realm for Active Directory authentication:

```bash
# Join domain
sudo realm join -U admin_user your.domain.com

# Enable home directory creation
sudo systemctl enable oddjobd.service
sudo systemctl start oddjobd.service
```

### Start Sway

If not using a display manager (GDM), you can start Sway directly:

```bash
sway
```

### Cato Networks VPN

If using Cato SASE:

```bash
# Start VPN connection
cato-sdp start --account your-account --user your.email@domain.com

# Stop VPN
cato-sdp stop

# Reset credentials
cato-sdp start --account your-account --user your.email@domain.com --reset-cred
```

### Podman Configuration

The script automatically configures Podman with Docker compatibility:

```bash
# Use podman as docker
docker ps  # Actually runs: podman ps

# Or use podman directly
podman run hello-world

# Docker Compose compatibility
docker-compose up  # Uses podman-compose
```

After first login following setup, the user will be in the `docker` group.

## Recommended Workflow

1. **Run this script** on fresh OS installation (system-level setup)
2. **Log out and log back in** (activate Nix and groups)
3. **Clone your dotfiles repository**
4. **Run your dotfiles install script** to set up Home Manager and user environment
5. **Install Flatpak apps** as needed
6. **Configure org-specific items** (CA certs, AD, VPN)

## Troubleshooting

### Nix Not Available After Installation

```bash
# Log out and log back in, or manually source:
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
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

### Home Manager Installation Issues

```bash
# If nix run home-manager fails, ensure flakes are working:
nix-shell -p nix-info --run "nix-info -m"

# Try installing Home Manager explicitly:
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

## File Locations

### System Configuration
- Keyboard: `/etc/default/keyboard`
- Snapd block: `/etc/apt/preferences.d/nosnap`
- SSH config: `/etc/ssh/sshd_config`
- fail2ban: `/etc/fail2ban/`

### User Configuration (Your Responsibility)
- Nix daemon config: `/etc/nix/nix.conf`
- Home Manager: `~/.config/home-manager/` (via your dotfiles)
- Sway config: `~/.config/sway/config` (via your dotfiles)
- Zsh config: `~/.zshrc` (managed by Home Manager)
- Neovim config: `~/.config/nvim/` (via your dotfiles)

### Logs
- System logs: `journalctl -xe`
- Nix daemon: `journalctl -u nix-daemon`
- fail2ban: `sudo journalctl -u fail2ban`
- SSH: `sudo journalctl -u ssh`

## Maintenance

### Update System Packages

```bash
sudo apt update
sudo apt upgrade
```

### Update Nix and Home Manager

```bash
# Update Home Manager (via your flake or dotfiles script)
home-manager switch --flake ~/.config/home-manager

# Update nix flake inputs
cd ~/.config/home-manager
nix flake update
home-manager switch
```

### Update Flatpak Applications

```bash
flatpak update
```

### Clean Up Old Generations

```bash
# Home Manager generations
home-manager generations
home-manager expire-generations "-7 days"

# Nix garbage collection
nix-collect-garbage -d

# Or delete generations older than 30 days
sudo nix-collect-garbage --delete-older-than 30d
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

## Design Philosophy

This script follows the principle of **separation of concerns**:

- **System-level**: Installed by this script (requires sudo)
  - Base OS packages
  - System services (SSH, fail2ban)
  - System configuration (keyboard, locale)
  - Containerization tools
  - AD integration tools

- **User-level**: Managed by Home Manager (your dotfiles)
  - Development tools and languages
  - CLI utilities and enhancements
  - Text editors and IDEs
  - Shell configuration
  - Application configurations

This separation allows:
- Clean system that can be rebuilt reliably
- User environment that's portable via dotfiles
- No conflicts between system and user packages
- Easier troubleshooting and maintenance

## Additional Resources

- [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Sway User Wiki](https://github.com/swaywm/sway/wiki)
- [Nix Package Search](https://search.nixos.org/packages)
- [Flatpak Application Repository](https://flathub.org/)

## License

This setup script is provided as-is for personal use. Customize as needed for your environment.
