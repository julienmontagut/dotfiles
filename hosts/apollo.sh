#!/bin/bash
# Layer 2 for apollo (x86_64 headless dev box).
# Runs as julien after cloud-init has done the base bootstrap.
# Idempotent — safe to re-run.

set -euo pipefail
dir="$(cd "$(dirname "$0")" && pwd)"
. "$dir/install.sh"

require_julien
install_mise

# --- dev tooling ---

# Linuxbrew (formulas only on Linux; casks in the Brewfile are silently
# skipped). Must precede `mise bootstrap` so the bootstrap task's `brew bundle`
# sees brew on PATH.
if ! command -v brew >/dev/null; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# dotfiles + mise tools (runtimes, k8s, LSPs) + bootstrap task (brew bundle, rustup).
run_bootstrap

# claude-code (Linux installer script — brew cask is macOS-only).
if ! command -v claude >/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

# .NET Aspire CLI.
if ! command -v aspire >/dev/null; then
    curl -fsSL https://aspire.dev/install.sh | bash
fi
