# Dotfiles

Dotfiles managed with [mise](https://mise.jdx.dev) (`[dotfiles]`) and bash scripts for macOS and Linux.

## Quick Start

- [ ] TODO: Fix the install process now requiring only mise install and base dependencies

### Fresh install on Linux

The following process is deprecated
```bash
~/sources/dotfiles/hosts/<host>.sh        # mise dotfiles apply + host-specific extras
~/sources/dotfiles/hosts/harden-doas.sh   # one-time: switch doas to persist
```

`hosts/<host>.sh` is safe to re-run anytime to refresh provisioning.

### Fresh macOS install

```bash
./scripts/install-macos.sh
./scripts/bootstrap-macos.sh
```

### Apply dotfiles (platform selection)

The `[dotfiles]` mappings live in `mise.toml`
`dotfiles.root = "{{ config_root }}"` resolves to the repo wherever it is cloned.
Run from inside the clone:

```bash
export MISE_EXPERIMENTAL=1
mise trust --yes .               # first run only
mise dotfiles status             # show drift (applied / missing / differs)
mise dotfiles apply --dry-run    # preview
mise dotfiles apply              # apply (add --force to replace existing files)
```

## Repository Structure

```
bin/                  # Custom scripts and programs
config/               # Programs and tools configurations
scripts/              # Install scripts
Brewfile              # Homebrew packages mainly for macOS
```

## What's Included

- Neovim 
- Zsh
- Zellij
- Ghostty
- And many more...
