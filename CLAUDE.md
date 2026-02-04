# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix-based dotfiles repository using a **three-layer architecture**:

1. **Nix/Home Manager** - CLI tools, shell config, Neovim, dotfiles
2. **Native Package Managers** - GUI apps (Homebrew on macOS, APT on Linux)
3. **Documentation** - Manual setup steps tracked in SETUP.md

Home Manager targets macOS (aarch64-darwin) and Linux (x86_64-linux).

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
home.nix               # Shared configuration (CLI packages, programs, imports)
platforms/
  macos.nix            # macOS-specific (AeroSpace, JankyBorders, Karabiner)
  linux.nix            # Linux-specific (Sway, Waybar, Fuzzel)
programs/
  neovim.nix           # Neovim with LSP, treesitter, telescope, conform
  zsh.nix              # Zsh with modern tools (fzf, ripgrep, zoxide, etc.)
config/
  wezterm/             # WezTerm config (symlinked via xdg.configFile)
  karabiner/           # Karabiner keyboard remapping (macOS)
  sketchybar/          # Status bar config (macOS)
bin/
  dots                 # Dotfiles management helper script
scripts/
  bootstrap.sh         # Initial setup (installs Nix, Homebrew + GUI apps)
  bootstrap-macos.sh   # macOS system configuration (TouchID, defaults)
  Brewfile             # macOS GUI apps (WezTerm, AeroSpace, Firefox, etc.)
SETUP.md               # Manual setup docs, Linux package lists
```

### Module Imports

From `home.nix`:
- `programs/neovim.nix` - Editor configuration
- `programs/zsh.nix` - Shell and CLI tools

From `flake.nix`:
- `platforms/macos.nix` or `platforms/linux.nix` depending on target

### Neovim Configuration

Configured in `programs/neovim.nix` with:

**Plugins**: blink-cmp, conform-nvim, flash-nvim, nvim-lspconfig, nvim-treesitter (all grammars), oil-nvim, snacks-nvim (dashboard, lazygit, picker, terminal, indent, explorer), telescope-nvim, trouble-nvim, tokyonight-nvim

**LSP Servers**: bashls, biome, buf_ls, clangd, cssls, dockerls, gopls, helm_ls, html, htmx, jsonls, lua_ls, marksman, nickel_ls, nixd, postgres_lsp, roslyn_ls, rust_analyzer, tailwindcss, taplo, terraformls, vtsls, yamlls

**Formatters** (via conform.nvim): shfmt (bash), gofmt (go), stylua (lua), nixfmt (nix), rustfmt (rust), with LSP fallback

**Key Bindings**:
- `<leader>` = Space
- `<leader>sf/sg/sb/sh/sr/ss/sd` - Telescope search (files, grep, buffers, help, references, symbols, diagnostics)
- `gd/gD/gi/gr` - LSP navigation (definition, declaration, implementation, references)
- `K` - Hover documentation
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `<leader>cf` - Format
- `[d/]d` - Previous/next diagnostic

### Shell Environment

Configured in `programs/zsh.nix`:
- **Zsh**: vim mode, autosuggestions, syntax highlighting, history substring search
- **Tools**: eza, bat, fzf, fd, ripgrep, zoxide (aliased to cd), direnv with nix-direnv
- **Prompt**: Starship

### Window Management

**macOS** (in `platforms/macos.nix`):
- **AeroSpace**: Tiling window manager with Karabiner integration (installed via Homebrew, config via Home Manager)
- **JankyBorders**: Window borders (installed via Homebrew, config via Home Manager)
- **Karabiner**: Remaps Cmd to hyper key (installed via Homebrew, config via Home Manager)

**Linux** (in `platforms/linux.nix`):
- **Sway**: Wayland tiling compositor with Alt-based keybindings (installed via APT, config via Home Manager)

### GUI Applications (Native Package Managers)

**NOT managed by Home Manager** - installed via native package managers for better OS integration:

**macOS (via Brewfile):**
- WezTerm, Firefox, JetBrains Toolbox
- AeroSpace, Karabiner Elements, JankyBorders

**Linux (via APT/Flatpak):**
- WezTerm, Sway, Waybar (system packages)
- JetBrains IDEs (via Toolbox or Flatpak)

Home Manager only manages the **configuration files** for these apps, not the packages themselves.

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
- For local overrides, create `overrides.nix` (gitignored) and run with `--impure` flag
- State version is `25.11` - check Home Manager release notes before changing
- **GUI apps are NOT in Home Manager** - use Homebrew (macOS) or APT (Linux), see SETUP.md
- WezTerm config is at `config/wezterm/wezterm.lua` and symlinked via `xdg.configFile`
