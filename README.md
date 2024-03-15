# Dotfiles

This repository contains my dotfiles, which I use to configure my development
environment. It is targeted at macOS, but I would love to update it to work on
linux as well.

## Installation

```sh
git clone git://github.com/julienmontagut/dotfiles.git
    && cd dotfiles
    && ./install.sh
```

## TODO

- [X] Install script
- [X] Configure macOS defaults on install
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
