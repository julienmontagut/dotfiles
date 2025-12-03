# Dotfiles

This repository contains my dotfiles managed by home-manager.

## Installation

TDB

## Structure of the repository

The repository is built around home-manager. The configuration can be found at the root of the repository and is organized by modules.

There are also some additional files installed using home-manager:
- `bin`: Contains scripts that are added to the `$PATH`
- `config`: Contains configuration files for various tools
- `scripts`: Contains scripts that are useful to manage the dotfiles
    - `{platform}`: Contains scripts that are specific to a platform
    - `common/modules`: Contains the modules that are to be installed

## TODO

- [ ] Run `home-manager init` to get a default configuration structure
- [ ] Reorganize home-manager config by modules
