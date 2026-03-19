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

### Apply Changes

```bash
# Using the dots helper (recommended)
dots apply

# Or directly with dotter
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
  Brewfile             # Homebrew packages
```

## What's Included

### Editor (Neovim)
- LSP support for 20+ languages (Rust, Go, .NET, TypeScript, etc.)
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
