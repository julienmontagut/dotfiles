# Dotfiles

This repository contains my dotfiles

## Installation

```sh
curl -sSL https://raw.githubusercontent.com/julienmontagut/dotfiles/main/scripts/install.sh | bash
```

## Structure of the repository

- `bin`: Contains scripts that are added to the `$PATH`
- `config`: Contains configuration files for various tools
- `scripts`: Contains scripts that are useful to manage the dotfiles
    - `{platform}`: Contains scripts that are specific to a platform
    - `common/modules`: Contains the modules that are to be installed

## TODO

- [ ] Update the install script to work on WSL
- [ ] Split by platform and by package
