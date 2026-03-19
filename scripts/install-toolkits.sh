#!/usr/bin/env bash
set -euo pipefail

has() { command -v "$1" &>/dev/null; }

# Homebrew
has brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# .NET
brew list dotnet@8 &>/dev/null || brew install dotnet@8
brew list dotnet@9 &>/dev/null || brew install dotnet@9

# Rust
has rustup || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# JetBrains Toolbox
if [[ "$(uname)" == "Darwin" ]]; then
    brew list --cask jetbrains-toolbox &>/dev/null || brew install --cask jetbrains-toolbox
else
    if ! has jetbrains-toolbox; then
        url=$(curl -s "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" |
            grep -o '"linux":"[^"]*"' | head -1 | cut -d'"' -f4)
        tmp=$(mktemp -d)
        curl -fsSL "$url" | tar xz -C "$tmp"
        mkdir -p "$HOME/.local/bin"
        find "$tmp" -name "jetbrains-toolbox" -exec cp {} "$HOME/.local/bin/" \;
        chmod +x "$HOME/.local/bin/jetbrains-toolbox"
        rm -rf "$tmp"
    fi
fi
