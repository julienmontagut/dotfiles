#!/bin/bash
# Layer 2 for apollo (x86_64 headless dev box).
# Runs as julien after cloud-init has done the base bootstrap.
# Idempotent — safe to re-run.

set -euo pipefail
dir="$(cd "$(dirname "$0")" && pwd)"
. "$dir/install.sh"

require_julien
install_mise

# dotfiles + the full mise tool set: runtimes (rust, dotnet, node, lua), k8s,
# LSPs, every CLI tool, plus the aspire and claude-code CLIs. No Linuxbrew, no
# curl installers — it's all declarative mise [tools] now.
run_bootstrap
