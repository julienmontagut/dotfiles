# TODO

Automatically handle terminal title updates in zsh.

```zsh
precmd () { print -Pn "\e]0;$TITLE\a" }
title() { export TITLE="$*" }
```

Store session when quitting zellij
