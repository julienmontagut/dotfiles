#!/bin/bash
# Layer 2: idempotent user-level provisioning. Cloud-init has already created
# julien, installed common packages, installed doas (permit nopass), and
# hardened sshd. This script:
#   - installs dotter if missing
#   - deploys dotter configs
#
# Per-host scripts (hosts/<name>.sh) source this then add their specifics.
# Run `hosts/harden-doas.sh` separately to switch doas from nopass to
# persist (5-min password cache) once you've set a password for julien.
#
# Safe to re-run. Run as julien, not root.

set -euo pipefail

DOTTER_VERSION=v0.13.4
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/sources/dotfiles}"

log() { echo ">> $*"; }
die() { echo "error: $*" >&2; exit 1; }

require_julien() {
    [[ "$(id -un)" == julien ]] || die "run as julien, not $(id -un)"
}

install_dotter() {
    if command -v dotter >/dev/null; then
        log "dotter already installed ($(dotter --version))"
        return
    fi
    local asset
    case "$(uname -m)" in
        x86_64)  asset=dotter-linux-x64-musl ;;
        aarch64) asset=dotter-linux-arm64-musl ;;
        *)       die "no dotter binary for arch $(uname -m)" ;;
    esac
    local url="https://github.com/SuperCuber/dotter/releases/download/${DOTTER_VERSION}/${asset}"
    local tmp; tmp="$(mktemp)"
    log "downloading dotter from $url"
    curl -fsSL "$url" -o "$tmp"
    doas install -m 755 "$tmp" /usr/local/bin/dotter
    rm -f "$tmp"
}

deploy_dotfiles() {
    [[ -d "$DOTFILES_DIR/.git" ]] || die "$DOTFILES_DIR not present — cloud-init should have cloned it"
    local local_toml="$DOTFILES_DIR/.dotter/local.toml"
    local want='packages = ["default"]'
    if [[ ! -f "$local_toml" ]] || [[ "$(cat "$local_toml")" != "$want" ]]; then
        log "writing $local_toml"
        printf '%s\n' "$want" > "$local_toml"
    fi
    log "running dotter deploy"
    (cd "$DOTFILES_DIR" && dotter deploy)
}

main() {
    require_julien
    install_dotter
    deploy_dotfiles
}

# Only run main when invoked directly (allow per-host scripts to source this).
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
