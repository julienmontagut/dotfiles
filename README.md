# Dotfiles

Dotfiles managed with [Dotter](https://github.com/SuperCuber/dotter) and shell scripts for macOS and Linux.

## Quick Start

### Fresh Install

```bash
# Run the bootstrap script (installs Homebrew on macOS, clones repo, deploys configs)
curl -fsSL https://raw.githubusercontent.com/julienmontagut/dotfiles/main/scripts/bootstrap.sh | bash
```

### Apply Changes

```bash
# Using the dots helper (recommended)
dots apply

# Or directly with dotter
cd ~/.local/share/dotfiles && dotter deploy --force
```

## The `dots` Command

A helper script for managing dotfiles:

```bash
dots edit     # Open editor, apply changes, optionally push
dots apply    # Deploy configs via Dotter
dots pull     # Pull from remote and apply
dots push     # Commit and push changes
dots sync     # Pull then push
dots status   # Show git status
```

## Repository Structure

```
.dotter/
  global.toml            # Dotter symlink configuration
config/
  git/                   # Git configuration
  nvim/                  # Neovim configuration
  zsh/                   # Zsh configuration
  wezterm/               # WezTerm terminal
  zed/                   # Zed editor
  starship.toml          # Starship prompt
  karabiner/             # Keyboard remapping (macOS)
  aerospace/             # Tiling window manager (macOS)
  borders/               # Window borders (macOS)
  sway/                  # Tiling window manager (Linux)
  waybar/                # Status bar (Linux)
  kanshi/                # Display management (Linux)
  fuzzel/                # App launcher (Linux)
  keyd/                  # Key remapping (Linux)
bin/
  dots                   # Dotfiles management script
scripts/
  bootstrap.sh           # Initial setup
  install-macos.sh       # macOS setup (Homebrew, Dotter, defaults)
  install-linux.sh       # Linux setup (apt, Linuxbrew, Dotter)
  Brewfile               # Homebrew/Linuxbrew packages
```

## What's Included

### Editor (Neovim)
- LSP support for multiple languages
- Treesitter for syntax highlighting and indentation
- Format on save with conform.nvim
- Tokyo Night Storm theme

### Shell (Zsh)
- Vim keybindings
- Autosuggestions and syntax highlighting
- Modern tools: eza, bat, fzf, fd, ripgrep, zoxide
- Starship prompt

### Window Management
- **macOS**: AeroSpace + Karabiner + JankyBorders
- **Linux**: Sway + Waybar + Fuzzel

### Terminal
- WezTerm with Tokyo Night Storm theme

## Maintenance

```bash
# Update packages
brew update && brew upgrade

# Re-deploy configs after changes
dots apply
```
