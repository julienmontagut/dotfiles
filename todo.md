# TODO

- Forbid edition of the .config/karabiner file after addition by using 
  xdg.configFile."karabiner/karbiner.json".onChange

MacOS: Set a system-wide karabiner config if needed
MacOS: Update the system setup to install karabiner with homebrew
Automatically handle terminal title updates in zsh.

```zsh
precmd () { print -Pn "\e]0;$TITLE\a" }
title() { export TITLE="$*" }
```

Store session when quitting zellij

