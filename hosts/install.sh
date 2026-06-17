#!/bin/bash
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

_in_clone() {
    [[ -d "$DOTFILES_DIR/.git" ]] || die "$DOTFILES_DIR not present — cloud-init should have cloned it"
    cd "$DOTFILES_DIR"
    export MISE_EXPERIMENTAL=1 MISE_ENV=linux
    mise trust --yes .
}

# Full provisioning for dev machines: dotfiles, mise-managed tools, then the
# bootstrap task (Brewfile + rustup, gated on `brew`).
run_bootstrap() {
    log "running mise bootstrap"
    ( _in_clone; mise bootstrap --yes )
}

# Dotfiles only — for servers that must not pull the dev runtimes/LSPs from
# [tools] (mise has no --skip flag yet, so use the targeted subcommand).
apply_dotfiles() {
    log "applying dotfiles via mise"
    ( _in_clone; mise dotfiles apply --yes )
}

main() {
    require_julien
    install_mise
    run_bootstrap
}

# Only run main when invoked directly (allow per-host scripts to source this).
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
