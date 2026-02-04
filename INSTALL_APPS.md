# Linux Application Installation Guide

This document describes the consolidated `install-apps` script that automates the installation of essential applications and configurations for Linux systems.

## Overview

The `install-apps` script is a unified installation tool that consolidates multiple individual installation scripts into a single, well-organized bash script. It handles the installation of:

- **WezTerm** - Modern terminal emulator
- **Zed** - High-performance code editor
- **JetBrains Toolbox** - IDE and tool manager
- **GPU Drivers** - Configuration for Nix packages to access system GPU drivers

## Features

- **Comprehensive Logging** - Color-coded output for easy readability
- **Idempotent** - Safe to run multiple times; skips already-installed applications
- **Error Handling** - Robust error checking and recovery
- **Modular Design** - Each installation is self-contained and can be run independently
- **Linux-Only** - Validates that it's running on Linux before proceeding
- **XDG Compliance** - Respects XDG Base Directory specification

## Usage

### Basic Usage

Run the script to install all applications:

```bash
./scripts/install-apps
```

### What Gets Installed

1. **System Package Updates** - Updates APT package cache
2. **WezTerm** - Terminal emulator from Fury.io repository
3. **Zed Editor** - Downloaded from zed.dev
4. **JetBrains Toolbox** - Latest version from JetBrains services
5. **GPU Drivers** - Configures Nix packages for GPU access

## Directory Locations

The script respects XDG Base Directory conventions:

| Component | Location |
|-----------|----------|
| JetBrains Toolbox | `$HOME/.local/share/JetBrains/Toolbox` |
| Symlink | `$HOME/.local/bin/jetbrains-toolbox` |
| GPU Config Marker | `$HOME/.cache/nix-gpu-configured` |

## Prerequisites

The script requires the following system utilities:

- `bash` (v4+)
- `curl` - For downloading installers
- `wget` - For downloading JetBrains Toolbox
- `tar` - For extracting archives
- `gpg` - For handling GPG keys
- `sudo` - For privileged operations
- `apt-get` - For system package management (on Debian/Ubuntu systems)

## What Each Installation Does

### WezTerm Installation

- Adds the WezTerm APT repository (Fury.io)
- Imports and verifies the GPG key
- Updates APT cache
- Installs WezTerm via apt-get

**Skip Condition**: Skipped if `wezterm` is already in PATH

### Zed Editor Installation

- Downloads the official Zed installer script from zed.dev
- Executes the installer script
- Installs to system-wide location

**Skip Condition**: Skipped if `zed` is already in PATH

### JetBrains Toolbox Installation

- Fetches the latest Linux release information from JetBrains API
- Downloads the latest tarball
- Extracts to `$HOME/.local/share/JetBrains/Toolbox`
- Creates a symlink in `$HOME/.local/bin`

**Skip Condition**: Skipped if symlink already exists

### GPU Driver Setup

- Locates the `non-nixos-gpu-setup` script from Nix store
- Runs GPU configuration with sudo privileges
- Creates a marker file to track completion

**Skip Condition**: Skipped if marker file `$HOME/.cache/nix-gpu-configured` exists

## Output Example

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Linux Application Installation Script
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ Starting Linux application installation...
ℹ System: Linux 6.1.0
ℹ Architecture: x86_64

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[1/5] System Package Manager Setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ Updating system package cache...
✓ System package cache updated

... (installation steps) ...

✓ All installations completed!
```

## Troubleshooting

### "This script is only for Linux"

This script only runs on Linux systems. If you're on macOS, use the `bootstrap-macos.sh` script instead.

### "GPU setup script not found yet"

This is normal on first installation. Run `home-manager switch --flake .` first to set up Nix configuration, then run this script again.

### Sudo password prompts

The script requires sudo access for:
- Adding APT repositories
- Installing system packages
- Running GPU driver setup

### Network connectivity issues

All installations require internet access. Common causes:
- No internet connection
- Firewall blocking package repositories
- DNS resolution issues

## Integration with Home Manager

After running this script, apply your Home Manager configuration:

```bash
home-manager switch --flake .#linux
```

Then re-run the GPU driver setup if needed:

```bash
./scripts/install-apps
```

## Architecture

The script is organized into functional sections:

1. **Header & Configuration** - Script metadata and variables
2. **Logging Functions** - Color-coded output utilities
3. **Platform Check** - Validates Linux environment
4. **Utility Functions** - Helper functions like `command_exists()`
5. **Installation Functions** - Five modular installation routines
6. **Main Function** - Orchestrates the installation flow

## Environment Variables

You can customize behavior using these environment variables:

```bash
# Override XDG directories
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_BIN_HOME="$HOME/.local/bin"

# Then run the script
./scripts/install-apps
```

## Exit Codes

- `0` - Successful completion
- `1` - Script not running on Linux
- `1` - Installation failed

## Related Scripts

The following scripts have been consolidated into `install-apps`:

- `install-wezterm.sh` - WezTerm installation
- `install-zed.sh` - Zed editor installation
- `install-jetbrains-toolbox.sh` - JetBrains Toolbox installation
- `linux-setup-gpu.sh` - GPU driver configuration

These original scripts can be removed once you've validated that `install-apps` works correctly on your system.

## Next Steps

After installation completes:

1. Verify installations: `which wezterm zed jetbrains-toolbox`
2. Add `$XDG_BIN_HOME` to your PATH if needed
3. Run Home Manager: `home-manager switch --flake .#linux`
4. Restart your terminal to apply new environment
5. Optionally re-run the GPU setup: `./scripts/install-apps`

## Support

For issues or feature requests related to this script, please refer to the main dotfiles repository.