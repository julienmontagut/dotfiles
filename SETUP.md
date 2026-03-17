# Setup Documentation

This document describes the setup process for both macOS and Linux systems.

## Architecture

This dotfiles repository uses a layered strategy:

### Layer 1: Dotter (Configuration Symlinks)

Managed by Dotter (`dotter deploy`):
- Shell configuration (zsh, starship)
- Neovim configuration
- Git configuration
- Editor configs (WezTerm, Zed)
- Window manager configs (AeroSpace/Sway, Waybar, etc.)

### Layer 2: Package Managers (CLI Tools + GUI Applications)

**macOS (Homebrew):** CLI tools (neovim, ripgrep, fzf, etc.), window managers (AeroSpace, Karabiner), terminals (WezTerm), browsers (Firefox), IDEs (JetBrains Toolbox)

**Linux (APT + Linuxbrew):** System packages (Sway, Waybar), CLI tools via Linuxbrew

### Layer 3: Shell Scripts (System Configuration)

Platform-specific setup scripts for system defaults, services, and keyboard configuration.

---

## macOS Setup

### Quick Start

```bash
# Run the bootstrap script (installs Homebrew and GUI apps)
./scripts/bootstrap.sh

# Or run the macOS install script directly
./scripts/install-macos.sh
```

### What Gets Installed

**Via Homebrew (scripts/Brewfile):**
- CLI tools: neovim, ripgrep, fd, fzf, bat, eza, starship, etc.
- Window management: AeroSpace, Karabiner Elements, JankyBorders
- Terminal: WezTerm
- Browser: Firefox, Google Chrome
- IDE: JetBrains Toolbox, Zed

**Via Dotter:**
- All config files symlinked to ~/.config/

### JetBrains IDE Setup

1. Install JetBrains Toolbox via Homebrew (included in Brewfile)
2. Open JetBrains Toolbox and sign in
3. Install desired IDEs (GoLand, Rider, WebStorm, etc.)
4. IDEs auto-update via Toolbox

---

## Linux (Ubuntu 24.04 / Debian 13) Setup

### Quick Start

```bash
# 1. Run system setup (installs sway, podman, etc.)
sudo ./scripts/linux-packages.sh

# 2. Run user setup (Linuxbrew, Dotter, configs)
./scripts/install-linux.sh
```

### What Gets Installed

**Via APT (system packages):**
- Sway, Waybar, WezTerm (system)
- Podman, build tools, SSH, fail2ban

**Via Linuxbrew:**
- CLI tools: neovim, ripgrep, fd, fzf, bat, eza, starship, etc.

**Via Dotter:**
- All config files symlinked to ~/.config/

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

## Post-Installation Steps

### 1. Open a New Terminal

For shell changes and new PATH entries to take effect.

### 2. Configure Custom CA Certificates

If you're in a corporate environment with custom CA certificates:

```bash
sudo cp /path/to/your/*.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

### 3. Set Up SSH Keys

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## Maintenance

### Update Packages

```bash
brew update && brew upgrade
```

### Re-deploy Configs

```bash
dots apply
# or
dotter deploy --force
```

### Update Flatpak Applications (Linux)

```bash
flatpak update
```

## File Locations

### System Configuration (Linux)
- Keyboard: `/etc/default/keyboard`
- SSH config: `/etc/ssh/sshd_config`
- fail2ban: `/etc/fail2ban/`

### User Configuration
- Sway config: `~/.config/sway/config`
- Zsh config: `~/.config/zsh/.zshrc`
- Neovim config: `~/.config/nvim/`
- Git config: `~/.config/git/config`

## Design Philosophy

- **System-level**: Installed by platform scripts (requires sudo on Linux)
  - Base OS packages, system services, system configuration

- **User-level**: Managed by Dotter + Homebrew/Linuxbrew
  - CLI tools, editors, shell configuration, application configs

This separation allows:
- Clean system that can be rebuilt reliably
- User environment that's portable via dotfiles
- No conflicts between system and user packages
