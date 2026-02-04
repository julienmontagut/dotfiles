# Dotfiles

Nix-based dotfiles using Home Manager for macOS and Linux.

## Quick Start

### Fresh Install

```bash
# Run the bootstrap script (installs Nix, Homebrew on macOS, clones repo)
curl -fsSL https://raw.githubusercontent.com/julienmontagut/dotfiles/main/scripts/bootstrap.sh | bash

# On macOS, also run the system configuration script
~/.local/share/dotfiles/scripts/bootstrap-macos.sh
```

### Apply Changes

```bash
# Using the dots helper (recommended)
dots apply

# Or directly with home-manager
home-manager switch --flake ~/.local/share/dotfiles#macos  # macOS
home-manager switch --flake ~/.local/share/dotfiles#linux  # Linux
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
flake.nix              # Nix flake entry point
home.nix               # Shared Home Manager configuration
platforms/
  macos.nix            # macOS: AeroSpace, JankyBorders, Karabiner
  linux.nix            # Linux: Sway, Waybar, Fuzzel
programs/
  neovim.nix           # Neovim with LSP, treesitter, telescope
  zsh.nix              # Zsh with modern CLI tools
config/
  karabiner/           # Keyboard remapping (macOS)
  sketchybar/          # Status bar (macOS)
bin/
  dots                 # Dotfiles management script
scripts/
  bootstrap.sh         # Initial setup (Nix, repo clone)
  bootstrap-macos.sh   # macOS system defaults, TouchID sudo
  Brewfile             # Homebrew packages
```

## What's Included

### Editor (Neovim)
- LSP support for 20+ languages (Rust, Go, .NET, Nix, TypeScript, etc.)
- Treesitter for syntax highlighting and indentation
- Telescope for fuzzy finding
- Format on save with conform.nvim
- Tokyo Night Storm theme

### Shell (Zsh)
- Vim keybindings
- Autosuggestions and syntax highlighting
- Modern tools: eza, bat, fzf, fd, ripgrep, zoxide
- Starship prompt
- Direnv with nix-direnv

### Window Management
- **macOS**: AeroSpace + Karabiner + JankyBorders
- **Linux**: Sway + Waybar + Fuzzel

### Terminal
- Alacritty with Tokyo Night Storm theme
- Zellij terminal multiplexer

## Maintenance

```bash
# Update flake inputs
nix flake update

# Garbage collect old generations
nix-collect-garbage -d

# Format Nix files
nixfmt **/*.nix
```
