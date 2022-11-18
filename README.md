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
