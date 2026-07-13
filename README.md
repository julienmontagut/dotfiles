# Dotfiles

Dotfiles managed with [mise](https://mise.jdx.dev) (`[dotfiles]`) and bash scripts for macOS and Linux.

## Quick Start

`./install.sh` is a cross-platform dotfiles install script that runs on `linux` and on `macos`. 
Run it from a repository clone or via `curl https://raw.github.../install.sh | sh`.

```bash
./install.sh            # provision this machine
./install.sh --force    # also overwrite existing dotfiles
```

The install script supports `linux` and `macos`

### Apply dotfiles

The `[dotfiles]` mappings live in `mise.toml`
`dotfiles.root = ""` resolves to the repo wherever it is cloned.
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
Brewfile              # Homebrew packages (macOS GUI apps)
```

## What's Included

- Neovim 
- Zsh
- Zellij
- Ghostty
- And many more...
