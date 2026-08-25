#!/bin/sh
# Refuse any git commit carrying a Claude-Session trailer. The attribution
# setting should already prevent it; this is the backstop for when a new
# client version or a stray --trailer reintroduces it.

set -eu

input=$(cat)

case "$input" in
    *'git'*'commit'*) ;;
    *) exit 0 ;;
esac

case "$input" in
    *Claude-Session*|*'claude.ai/code/session'*)
        echo "Refusing: commit message carries a Claude-Session trailer. Strip it and retry." >&2
        exit 2
        ;;
esac
exit 0
