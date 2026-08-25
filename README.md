# Dotfiles

Dotfiles managed with [mise](https://mise.jdx.dev) (`[dotfiles]`) and bash scripts for macOS and Linux.

## Quick Start

`./install.sh` is a cross-platform dotfiles install script that runs on `linux` and on `macos`. 
Run it from a repository clone or straight from Codeberg, which is where the repository lives
(the GitHub copy is a read-only mirror):

```bash
curl -fsSL https://codeberg.org/julienmontagut/dotfiles/raw/branch/main/install.sh | bash

./install.sh            # provision this machine, from a clone
./install.sh --force    # also overwrite existing dotfiles
```

The install script supports `linux` and `macos`

### Apply dotfiles

The `[dotfiles]` mappings live in `config/mise/config.toml`, which is symlinked to
`~/.config/mise`. Their sources are relative and climb out through that symlink, so they resolve
to the repo wherever it is cloned - and `mise bootstrap` works from any directory, not just the
clone. Moving the checkout only needs `~/.config/mise` re-pointed at it.

To pull and re-converge the whole machine - packages, dotfiles, login shell, tools, and the
`bootstrap` task. It converges, so re-running is safe:

```bash
dotfiles && git pull --rebase
mise bootstrap
```

Dotfiles only:

```bash
mise trust --yes .                        # first run only, from the clone
mise bootstrap dotfiles status            # show drift (applied / missing / differs)
mise bootstrap dotfiles apply --dry-run   # preview
mise bootstrap dotfiles apply             # apply
```

Two things to know:

- `--force` is needed when a target already exists as a real file rather than a symlink mise owns.
  Without it, apply reports `differs` and skips that entry.
- mise never prunes. Deleting an entry leaves its symlink behind - run
  `mise bootstrap dotfiles unapply <target>` *before* removing the entry.

If `~/.config/mise` is ever missing or not a symlink, every source fails at once and mise refuses
to apply anything, including the entry that would fix it. That entry lives in this repo's
`mise.toml`, not in the machine config, so recover from inside the clone:

```bash
cd <clone> && mise bootstrap dotfiles apply ~/.config/mise --force
```

## Repository Structure

```
bin/                  # Custom scripts and programs, linked into ~/.local/bin
claude/               # Claude Code layer, linked into ~/.claude
claude-upcast/        # Upcast-only skills, linked into ~/.claude/skills
config/               # Programs and tools configurations
config/mise/          # The machine definition, linked to ~/.config/mise
hosts/                # cloud-init for the home machines
scripts/              # macOS setup steps that aren't declarative
Brewfile              # Homebrew packages (macOS GUI apps)
mise.toml             # Tooling for working on this repo, and the ~/.config/mise seed
```

## What's Included

- Neovim 
- Zsh
- Zellij
- Ghostty
- And many more...
