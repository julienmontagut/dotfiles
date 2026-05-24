#!/bin/bash
# Transition doas from `permit nopass julien as root` (cloud-init default)
# to `permit persist julien as root` (5-minute password cache).
#
# Cloud-init creates julien with a locked password. This script:
#   1. Unlocks the account (usermod -U)
#   2. Sets a password interactively (passwd)
#   3. Switches /etc/doas.conf to the persist rule
#
# Idempotent: no-op if /etc/doas.conf is already on `persist`. Requires a TTY.
# Run as julien once you're ready to give up nopass convenience for audit.

set -euo pipefail

[[ "$(id -un)" == julien ]] || { echo "run as julien"; exit 1; }
[[ -t 0 ]]                  || { echo "needs a TTY (for the passwd prompt)"; exit 1; }

current="$(doas cat /etc/doas.conf 2>/dev/null || true)"
case "$current" in
    "permit persist julien as root")
        echo "doas already on persist — nothing to do"
        exit 0
        ;;
    "permit nopass julien as root")
        ;;
    *)
        echo "unexpected /etc/doas.conf:"
        echo "$current"
        exit 1
        ;;
esac

echo "About to:"
echo "  1. doas usermod -U julien   (unlock account for password auth)"
echo "  2. doas passwd julien       (you'll be prompted for the new password)"
echo "  3. switch /etc/doas.conf to 'permit persist julien as root'"
read -r -p "Continue? [y/N] " yn
[[ "$yn" =~ ^[Yy]$ ]] || { echo "abort"; exit 1; }

doas usermod -U julien
doas passwd julien
printf 'permit persist julien as root\n' | doas tee /etc/doas.conf >/dev/null
doas chmod 600 /etc/doas.conf
echo "doas now requires your password (cached for 5 minutes per session)."
