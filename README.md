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
  nvim/               # Neovim configuration (vim.pack)
  tvim/               # Experimental Neovim sandbox (lazy.nvim)
  zsh/                # Zsh configuration
  alacritty/          # Alacritty terminal
  wezterm/            # WezTerm terminal
  tmux/               # Tmux configuration
  zed/                # Zed editor
  ideavim/            # IdeaVim (JetBrains)
  git/                # Git configuration
  starship.toml       # Starship prompt
  aerospace/          # Window management (macOS)
  karabiner/          # Keyboard remapping (macOS)
  borders/            # JankyBorders (macOS)
  sketchybar/         # Status bar (macOS)
  sway/               # Window management (Linux)
  waybar/             # Status bar (Linux)
  kanshi/             # Display management (Linux)
  fuzzel/             # Launcher (Linux)
  keyd/               # Keyboard remapping (Linux)
bin/
  dots                # Dotfiles management script
  tvim                # Testable Neovim launcher
scripts/
  install-linux.sh    # Linux setup (apt packages, dotter, apps)
  install-macos.sh    # macOS setup (Homebrew, dotter, apps)
  bootstrap-macos.sh  # macOS system defaults, TouchID sudo
  macos-defaults.sh   # macOS system preferences
  macos-services.sh   # macOS service configuration
  install-apps.sh     # App installation helpers
  install-toolkits.sh # Development toolkit setup
  linux-packages.sh   # Linux APT packages
```

## What's Included

### Editor (Neovim)

- Native `vim.pack` plugin manager (no lazy.nvim)
- LSP support (Lua, Rust, C#, Bash, JSON, HTML, CSS, Swift, Nickel, TOML)
- Treesitter for syntax highlighting and textobjects
- Snacks.nvim for fuzzy finding, notifications, and UI
- Oil.nvim for file exploration
- Flash.nvim for motion
- Basalt color scheme

### Shell (Zsh)

- Vi keybindings
- Autosuggestions and syntax highlighting
- Modern tools: eza, bat, fzf, fd, ripgrep, zoxide
- Starship prompt
- Direnv and mise

### Window Management

- **macOS**: AeroSpace + Karabiner + JankyBorders + Sketchybar
- **Linux**: Sway + Waybar + Fuzzel + Kanshi

### Terminal

- Alacritty with tmux (primary)
- WezTerm with Basalt color scheme
