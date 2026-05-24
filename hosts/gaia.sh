#!/bin/bash
# Layer 2 for gaia (aarch64 home LAN server, runs unbound).
# The unbound config in /etc/unbound/unbound.conf.d/ is managed out-of-band
# and preserved across re-runs.

set -euo pipefail
dir="$(cd "$(dirname "$0")" && pwd)"
. "$dir/install.sh"

require_julien
install_dotter
deploy_dotfiles

# doas wipes env, so DEBIAN_FRONTEND won't carry through — use `doas env`.
doas env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends unbound
