# Dotfiles

Dotfiles managed with [mise](https://mise.jdx.dev) (`[dotfiles]`) and bash scripts for macOS and Linux.

## Quick Start

`./install.sh` is the single entry point for both platforms. Run it from a checkout, or pipe it
via `curl | bash` to clone and run.

- **macOS:** Xcode CLT -> Homebrew -> mise -> `mise bootstrap` (dotfiles, tools, then `brew bundle`
  for the GUI apps) -> optional system defaults + services.
- **Linux:** delegates to `hosts/$(hostname).sh` for per-host provisioning (dotfiles + mise tools;
  no Homebrew). `hosts/<host>.sh` is safe to re-run anytime to refresh provisioning.

```bash
./install.sh            # provision this machine
./install.sh --force    # also overwrite existing dotfiles
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
Brewfile              # Homebrew packages (macOS GUI apps)
```

## What's Included

- Neovim 
- Zsh
- Zellij
- Ghostty
- And many more...
