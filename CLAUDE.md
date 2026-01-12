# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix-based dotfiles repository using Home Manager to manage configuration for development tools, window managers, and shell environments targeting macOS (aarch64-darwin) and Linux (x86_64-linux).

## Key Commands

### Home Manager

```bash
# Apply configuration changes (macOS)
home-manager switch --flake .#macos

# Apply configuration changes (Linux)
home-manager switch --flake .#linux

# Or use the dots helper script
dots apply

# Test configuration without activating
home-manager build --flake .#macos
```

### Nix Development

```bash
# Format all Nix files
nixfmt **/*.nix

# Check flake
nix flake check

# Update flake inputs
nix flake update

# Show flake outputs
nix flake show
```

## Architecture

### Flake Structure

**flake.nix** defines:
- **Inputs**: nixpkgs (unstable), home-manager, stylix
- **Outputs**: Two homeConfigurations - `macos` (aarch64-darwin) and `linux` (x86_64-linux)

### File Organization

```
flake.nix              # Entry point, defines home configurations
home.nix               # Shared configuration (packages, programs, imports)
platforms/
  macos.nix            # macOS-specific (AeroSpace, JankyBorders, Karabiner)
  linux.nix            # Linux-specific (Sway, Waybar, Fuzzel)
modules/
  neovim.nix           # Neovim with LSP, treesitter, telescope, conform
  zsh.nix              # Zsh with modern tools (fzf, ripgrep, zoxide, etc.)
config/
  karabiner/           # Karabiner keyboard remapping (macOS)
  sketchybar/          # Status bar config (macOS)
bin/
  dots                 # Dotfiles management helper script
scripts/
  bootstrap.sh         # Initial setup script (installs Nix, clones repo)
  bootstrap-macos.sh   # macOS system configuration (TouchID, defaults)
  Brewfile             # Homebrew packages for macOS
```

### Module Imports

From `home.nix`:
- `modules/neovim.nix` - Editor configuration
- `modules/zsh.nix` - Shell and CLI tools

From `flake.nix`:
- `platforms/macos.nix` or `platforms/linux.nix` depending on target

### Neovim Configuration

Configured in `modules/neovim.nix` with:

**Plugins**: blink-cmp, conform-nvim, flash-nvim, nvim-lspconfig, nvim-treesitter (all grammars), oil-nvim, telescope-nvim, tokyonight-nvim

**LSP Servers**: bashls, biome, cssls, dockerls, gopls, helm_ls, html, htmx, jsonls, lua_ls, marksman, nickel_ls, nixd, postgres_lsp, roslyn, rust_analyzer, tailwindcss, taplo, terraformls, vtsls, yamlls

**Formatters** (via conform.nvim): shfmt (bash), gofmt (go), stylua (lua), nixfmt (nix), rustfmt (rust), with LSP fallback

**Key Bindings**:
- `<leader>` = Space
- `<leader>sf/sg/sb/sh/sr/ss/sd` - Telescope search
- `gd/gD/gi/gr` - LSP navigation
- `K` - Hover documentation
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `<leader>cf` - Format
- `-` - Oil file explorer

### Shell Environment

Configured in `modules/zsh.nix`:
- **Zsh**: vim mode, autosuggestions, syntax highlighting, history substring search
- **Tools**: eza, bat, fzf, fd, ripgrep, zoxide (aliased to cd), direnv with nix-direnv
- **Prompt**: Starship

### Window Management

**macOS** (in `platforms/macos.nix`):
- **AeroSpace**: Tiling window manager with Karabiner integration
- **JankyBorders**: Window borders (Tokyo Night Storm colors)
- **Karabiner**: Remaps Cmd to hyper key for window management

**Linux** (in `platforms/linux.nix`):
- **Sway**: Wayland tiling compositor with Alt-based keybindings

### Cross-Platform Keybindings

| Action | macOS (via Karabiner) | Linux (Sway) |
|--------|----------------------|--------------|
| Workspace 1-4 | Cmd + 1/2/3/4 | Alt + 1/2/3/4 |
| Move to workspace | Cmd + Shift + 1/2/3/4 | Alt + Shift + 1/2/3/4 |
| Focus hjkl | Cmd + Ctrl + Alt + Shift + hjkl | Alt + Shift + hjkl |
| Terminal | Cmd + Ctrl + Alt + Enter | Alt + Return |
| Close window | Cmd + Ctrl + Alt + Shift + q | Alt + Shift + c |
| Resize mode | Cmd + Ctrl + Alt + Shift + r | Alt + Shift + r |

## Development Workflow

1. Edit the relevant .nix file
2. Run `dots apply` or `home-manager switch --flake .#macos`
3. Format with `nixfmt` if needed

## Important Notes

- Home configurations are named `macos` and `linux`, not by username
- Unfree packages are allowed (`config.allowUnfree = true`)
- XDG directories are preferred (`preferXdgDirectories = true`)
- Stylix is included but not actively configured
- The `dots` script in `bin/` provides convenient commands for managing dotfiles
