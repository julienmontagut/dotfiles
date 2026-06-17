#!/bin/bash
# Layer 2: idempotent user-level provisioning. Cloud-init has already created
# julien, installed common packages, installed doas (permit nopass), and
# hardened sshd. This script:
#   - installs mise if missing
#   - applies dotfiles via `mise dotfiles`
#
# Per-host scripts (hosts/<name>.sh) source this then add their specifics.
# Run `hosts/harden-doas.sh` separately to switch doas from nopass to
# persist (5-min password cache) once you've set a password for julien.
#
# Safe to re-run. Run as julien, not root.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/sources/dotfiles}"

log() { echo ">> $*"; }
die() { echo "error: $*" >&2; exit 1; }

require_julien() {
    [[ "$(id -un)" == julien ]] || die "run as julien, not $(id -un)"
}

install_mise() {
    export PATH="$HOME/.local/bin:$PATH"
    if command -v mise >/dev/null; then
        log "mise already installed ($(mise --version))"
        return
    fi
    log "installing mise from https://mise.run"
    curl -fsSL https://mise.run | sh
    command -v mise >/dev/null || die "mise install failed"
}

apply_dotfiles() {
    [[ -d "$DOTFILES_DIR/.git" ]] || die "$DOTFILES_DIR not present — cloud-init should have cloned it"
    log "applying dotfiles via mise"
    (
        cd "$DOTFILES_DIR"
        export MISE_EXPERIMENTAL=1 MISE_ENV=linux
        mise trust --yes .
        mise dotfiles apply --yes
    )
}

main() {
    require_julien
    install_mise
    apply_dotfiles
}

# Only run main when invoked directly (allow per-host scripts to source this).
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
