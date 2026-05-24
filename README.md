# Dotfiles

Dotfiles managed with [dotter](https://github.com/SuperCuber/dotter) and bash scripts for macOS and Linux.

## Quick Start

### Fresh Linux install (apollo / gaia / hermes)

Two layers. **Cloud-init** brings the box to a known baseline at first
boot: user `julien` with my SSH key (locked password), common apt packages,
`doas` (initially `permit nopass`), hardened sshd drop-in, and the dotfiles
repo cloned to `~julien/sources/dotfiles`. See `cloud-init/README.md` for
delivery (Pi boot partition, NoCloud seed ISO, Scaleway paste).

**Layer 2** runs as julien after first boot and is idempotent:

```bash
ssh julien@<host>
~/sources/dotfiles/hosts/<host>.sh        # dotter deploy + host-specific extras
~/sources/dotfiles/hosts/harden-doas.sh   # one-time: switch doas to persist
```

`hosts/<host>.sh` is safe to re-run anytime to refresh provisioning.

### Fresh macOS install

```bash
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
cloud-init/
  apollo.yaml         # First-boot user-data per host
  gaia.yaml
  hermes.yaml
  README.md           # Delivery: Pi boot, NoCloud ISO, Scaleway paste
hosts/                # Layer 2 — idempotent, runs as julien post-boot
  install.sh          # Shared helpers: install_dotter, deploy_dotfiles
  apollo.sh           # Headless dev box: brew bundle + rustup + claude-code + aspire
  gaia.sh             # Home LAN server: unbound
  hermes.sh           # RPi3: wakeonlan + etherwake
  harden-doas.sh      # One-time: switch doas from nopass to persist
scripts/
  install-macos.sh    # macOS setup (Homebrew, dotter, apps)
  bootstrap-macos.sh  # macOS system defaults, TouchID sudo
  macos-defaults.sh   # macOS system preferences
  macos-services.sh   # macOS service configuration
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
- **Linux**: headless — ssh + tmux + neovim. Sway/Waybar/Fuzzel/Kanshi configs
  exist under `config/` but aren't deployed by default (the `[linux]` dotter
  package is opt-in for a future wlroots session).

### Terminal

- Alacritty with tmux (primary)
- WezTerm with Basalt color scheme
