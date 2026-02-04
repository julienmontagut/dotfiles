# TODO

Move aerospace, jankyborders, sketchybar, karabiner elements to nix-darwin configuration

Use dotter for configuration files

Automatically handle terminal title updates in zsh.

```zsh
precmd () { print -Pn "\e]0;$TITLE\a" }
title() { export TITLE="$*" }
```

Store session when quitting zellij

