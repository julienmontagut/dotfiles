#!/bin/bash
# Layer 2 for hermes (aarch64 Raspberry Pi 3, wake-on-LAN trigger).

set -euo pipefail
dir="$(cd "$(dirname "$0")" && pwd)"
. "$dir/install.sh"

require_julien
install_dotter
deploy_dotfiles

# doas wipes env, so DEBIAN_FRONTEND won't carry through — use `doas env`.
doas env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wakeonlan etherwake
