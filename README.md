# Dotfiles

This repository contains my dotfiles

## Installation

- [ ] TODO: Upgrade the installation process

```sh
git clone git://github.com/julienmontagut/dotfiles.git
    && cd dotfiles
    && ./install.sh
```

## Structure of the repository

- `bin`: Contains scripts that are added to the `$PATH`
- `config`: Contains configuration files for various tools
- `scripts`: Contains scripts that are useful to manage the dotfiles
    - `{platform}`: Contains scripts that are specific to a platform
    - `common/modules`: Contains the modules that are to be installed

## TODO

- [ ] Update the install script
- [ ] Move macOS defaults to Nix
- [ ] Add missing configurations to Nix
- [ ] Install of binaries
- [ ] If installation of bash is required on macOS, then:
  - [ ] Install bash with brew
  - [ ] Install bash-completion
  - [ ] Link bash to `/usr/local/bin/bash`
  - [ ] Add bash to `/etc/shells`
- [ ] Split by platform and by package

