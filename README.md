# Dotfiles

This repository contains my dotfiles, which I use to configure my development environments.

## Installation

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

- [ ] Install script
- [ ] Configure macOS defaults on install
- [ ] Load installed ZSH config for next installation steps
    > This might need the install script to be written in ZSH
- [ ] Install configurations from `config` to `$XDG_CONFIG_HOME`
- [ ] Install of binaries
- [ ] If installation of bash is required on macOS, then:
  - [ ] Install bash with brew
  - [ ] Install bash-completion
  - [ ] Link bash to `/usr/local/bin/bash`
  - [ ] Add bash to `/etc/shells`
- [ ] Change shell to bash
- [ ] Split by platform and by package
- [ ] Install pass on Fedora (with custom path PASSWORD_STORE_DIR see https://git.zx2c4.com/password-store/tree/src/password-store.sh)

