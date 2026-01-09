# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix-based dotfiles repository using Home Manager to manage configuration for development tools, window managers, and shell environments primarily targeting macOS (aarch64-darwin).

## Key Commands

### Home Manager

```bash
# Apply configuration changes
home-manager switch --flake .

# Test configuration without activating
home-manager build --flake .

# Check what will change
home-manager generations
```

### Nix Development

```bash
# Format all Nix files
nixfmt-rfc-style **/*.nix

# Check flake
nix flake check

# Update flake inputs
nix flake update

# Show flake outputs
nix flake show
```

## Architecture

### Configuration Entry Points

- **flake.nix**: Nix flake definition with inputs (nixpkgs 25.11, home-manager) and homeConfiguration for user "julien"
- **home.nix**: Main home-manager configuration that imports modular program configs and defines packages, XDG settings, and platform-specific (Darwin) configurations

### Modular Structure

The repository uses a modular approach where configurations are split across files:

- **programs/*.nix**: Self-contained program configurations (zsh.nix, zellij.nix, etc.) that can be imported into home.nix
- **config/**: Configuration files that are symlinked via `xdg.configFile` (nvim, sketchybar, etc.)
- **bin/**: Scripts added to $PATH via `home.file`

### Platform Detection

Platform-specific configurations use `pkgs.stdenv.isDarwin` and `pkgs.stdenv.isLinux` to conditionally enable features. macOS-specific settings are defined in `targets.darwin.defaults`.

### Window Management Stack

The configuration includes tiling window managers for both macOS and Linux:

**macOS:**
1. **AeroSpace**: Tiling window manager configured in home.nix with Karabiner-based Command key bindings for workspace switching, focus navigation, and resize mode
2. **Sketchybar**: Status bar configured inline in home.nix with Tokyo Night Storm theme. Listens to aerospace workspace changes via `exec-on-workspace-change`
3. **JankyBorders**: Window border service that highlights active windows, configured in home.nix with Tokyo Night Storm colors
4. **Karabiner**: Handles all window management keybindings using Command key, providing consistent physical layout with Linux (where Alt is in the same position as Command on macOS)

Sketchybar plugins are bash scripts in config/sketchybar/plugins/ that query system state (aerospace.sh uses `aerospace list-windows` to count apps per workspace).

**Linux:**
1. **Sway**: Wayland tiling window manager configured in programs/sway.nix with alt-ctrl based keybindings matching AeroSpace functionality

### Window Manager Keybindings (Command-Based Approach)

**macOS Strategy**: Use Command key for window management to match the physical layout of Alt on Linux keyboards.

**Core Philosophy:**
- **Physical consistency**: Command on macOS = Alt on Linux (same physical key position)
- **Cross-platform muscle memory**: Same physical key press on both platforms
- **Reliable shortcuts**: Command-based Karabiner bindings are more reliable than Alt-based
- **Vim mnemonics**: hjkl navigation, vsplit (v), zoom (z), close (q), browser (b)
- **Linux-style terminal**: Copy/paste in Alacritty uses `ctrl+shift+c/v` (like Linux terminals)

**Core Bindings** (Command key):
- **Workspace switching**: Cmd + 1/2/3/4
- **Move to workspace**: Cmd + Shift + 1/2/3/4
- **Focus navigation**: Cmd + Shift + h/j/k/l (vim-style)
- **Layout control**: Cmd + Shift + s/v/e/z/space
- **Applications**: Cmd + Enter (terminal), Cmd + b (browser)
- **Window close**: Cmd + Shift + q
- **Resize mode**: Cmd + Shift + r

**System Shortcuts Overridden:**
- Cmd + 1/2/3/4 (previously browser tab switching) → Workspace switching
- Cmd + b (previously bookmarks in browsers) → Open browser

**Accented Characters** (Right Alt/Option only):
- Right Alt + e, then e → é
- Right Alt + c → ç
- Right Alt + \` (backtick), then a → à

**Complete Keybinding Table:**

| Action | macOS Keys | Linux (Sway) Keys | Physical Position |
|--------|-----------|------------------|-------------------|
| **Workspace 1-4** | Cmd + 1/2/3/4 | Alt + 1/2/3/4 | Same physical key + number |
| **Move to workspace** | Cmd + Shift + 1/2/3/4 | Alt + Shift + 1/2/3/4 | Same physical key + Shift + number |
| **Focus left/down/up/right** | Cmd + Shift + h/j/k/l | Alt + Shift + h/j/k/l | Same physical key + Shift + hjkl |
| **Split horizontal** | Cmd + Shift + s | Alt + Shift + s | Same physical key + Shift + s |
| **Split vertical** | Cmd + Shift + v | Alt + Shift + v | Same physical key + Shift + v |
| **Toggle layout** | Cmd + Shift + e | Alt + Shift + e | Same physical key + Shift + e |
| **Fullscreen/zoom** | Cmd + Shift + z | Alt + Shift + z | Same physical key + Shift + z |
| **Float toggle** | Cmd + Shift + Space | Alt + Shift + Space | Same physical key + Shift + Space |
| **Close window** | Cmd + Shift + q | Alt + Shift + q | Same physical key + Shift + q |
| **Terminal** | Cmd + Enter | Alt + Return | Same physical key + Enter |
| **Browser** | Cmd + b | Alt + b | Same physical key + b |
| **Resize mode** | Cmd + Shift + r | Alt + Shift + r | Same physical key + Shift + r |
| **Terminal copy** | Ctrl + Shift + c | Ctrl + Shift + c | Identical |
| **Terminal paste** | Ctrl + Shift + v | Ctrl + Shift + v | Identical |

**In Resize Mode** (all platforms): `h/j/k/l` to resize, `esc` or `enter` to exit

**How the macOS Setup Works:**
- **Karabiner**: Handles all window management keybindings using Command key via shell commands to AeroSpace
- **AeroSpace**: Configured with empty main keybindings (Karabiner does all the work)
- **Physical Layout**: Command key on macOS is in the same position as Alt on Linux keyboards
- **Result**: Same muscle memory across macOS and Linux - press the same physical key for the same action

**Why This Works:**
- ✓ **Physical consistency**: Same key position on both platforms (Command on Mac = Alt on Linux)
- ✓ **Reliable execution**: Karabiner's shell_command approach is more reliable than AeroSpace's built-in Alt bindings
- ✓ **No modifier confusion**: Command key works consistently across all apps
- ✓ **Cross-platform muscle memory**: Your fingers learn one position, works everywhere
- ✓ **No terminal conflicts**: Terminal uses `ctrl-shift+c/v` for copy/paste

**Implementation:**
- **Karabiner**: `config/karabiner/karabiner.json` - All window management bindings using `left_command` + shell commands
- **AeroSpace**: `home.nix` lines 128-144 - Empty main keybindings, resize mode only
- **Linux/Sway**: `programs/sway.nix` - Uses Alt (Mod1) with identical logical bindings

### XDG Configuration Management

The `xdg.configFile` attribute set defines which config directories to symlink:
- nvim config includes an `onChange` hook that copies lazy-lock.json to dataHome
- sketchybar/plugins are recursively copied with execute permissions

### Shell Environment

Zsh configuration in programs/zsh.nix enables modern shell tools (fzf, ripgrep, fd, bat, eza, yazi, zoxide) and sets up vim mode with custom keybindings. Starship provides the prompt. Direnv with nix-direnv integration enables per-directory development environments.

## Development Workflow

When modifying configurations:

1. Edit the relevant .nix file or config/ directory
2. Run `home-manager switch --flake .` to apply changes
3. For Nix formatting, use `nixfmt-rfc-style` (installed via home.packages)
4. Git workflow uses main branch as default with push.autoSetupRemote = true

## Important Notes

- The configuration targets Nix 25.11 release channel
- User home directory is detected via platform: `/Users/julien` on Darwin, `/home/julien` on Linux
- XDG directories are preferred (`preferXdgDirectories = true`)
- Unfree packages are allowed (`config.allowUnfree = true`)
- Some program imports in home.nix are commented out (browser.nix, neovim.nix) - check before enabling
