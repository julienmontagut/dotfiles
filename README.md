# Dotfiles

Dotfiles managed with [dotter](https://github.com/SuperCuber/dotter) and bash scripts for macOS and Linux.

## Quick Start

### Fresh Install

```bash
# Linux
./scripts/install-linux.sh

# macOS
./scripts/install-macos.sh
./scripts/bootstrap-macos.sh
```

### Configure Dotter (platform selection)

Dotter uses a local configuration file to determine which packages/profiles to deploy for each platform.
Before running `dotter` directly, copy the example and enable the profile for your OS:

```bash
cp .dotter/local.toml.example .dotter/local.toml
# Then edit .dotter/local.toml and enable the appropriate profiles for:
# - macOS
# - Linux
```

### Apply Changes

```bash
# Using the dots helper (recommended)
dots apply

# Or directly with dotter (requires a configured .dotter/local.toml)
dotter deploy
```

## The `dots` Command

A helper script for managing dotfiles:

```bash
dots edit     # Open editor, apply changes, optionally push
dots apply    # Apply configuration
dots pull     # Pull from remote and apply
dots push     # Commit and push changes
dots sync     # Pull then push
dots status   # Show git status
```

## Repository Structure

```
Brewfile              # Homebrew packages
config/
  nvim/                # Neovim configuration
  zsh/                 # Zsh configuration
  wezterm/             # WezTerm terminal
  zed/                 # Zed editor
  aerospace/           # Window management (macOS)
  karabiner/           # Keyboard remapping (macOS)
  sway/                # Window management (Linux)
  waybar/              # Status bar (Linux)
  starship.toml        # Starship prompt
bin/
  dots                 # Dotfiles management script
scripts/
  install-linux.sh     # Linux setup (apt packages, dotter, apps)
  install-macos.sh     # macOS setup (Homebrew, dotter, apps)
  bootstrap-macos.sh   # macOS system defaults, TouchID sudo
```

## What's Included

### Editor (Neovim)
- LSP support for 20+ languages
- Treesitter for syntax highlighting and indentation
- Telescope for fuzzy finding
- Format on save with conform.nvim
- Tokyo Night Storm theme

### Shell (Zsh)
- Vim keybindings
- Autosuggestions and syntax highlighting
- Modern tools: eza, bat, fzf, fd, ripgrep, zoxide
- Starship prompt
- Direnv

### Window Management
- **macOS**: AeroSpace + Karabiner + JankyBorders
- **Linux**: Sway + Waybar + Fuzzel

### Terminal
- WezTerm with Tokyo Night Storm theme
- Zellij terminal multiplexer
