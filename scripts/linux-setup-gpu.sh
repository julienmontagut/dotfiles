#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

MARKER_FILE="$HOME/.cache/nix-gpu-configured"

echo -e "${YELLOW}Checking GPU driver setup for Nix packages...${NC}"

# Check if already configured
if [ -f "$MARKER_FILE" ]; then
  echo -e "${GREEN}✓ GPU drivers already configured${NC}"
  exit 0
fi

# Find the non-nixos-gpu setup script
GPU_SETUP=$(find /nix/store -maxdepth 1 -name '*non-nixos-gpu*' -type d 2>/dev/null | \
            grep -m1 'non-nixos-gpu' | \
            awk '{print $1"/bin/non-nixos-gpu-setup"}' || echo "")

if [ -z "$GPU_SETUP" ] || [ ! -f "$GPU_SETUP" ]; then
  echo -e "${YELLOW}⚠ GPU setup script not found yet${NC}"
  echo "This is normal if this is your first install."
  echo "Run 'home-manager switch --flake .' first, then run this script again."
  exit 0
fi

echo -e "${YELLOW}Found GPU setup script: $GPU_SETUP${NC}"
echo "This will configure Nix packages to access your system GPU drivers."
echo ""

# Run with sudo
if sudo "$GPU_SETUP"; then
  mkdir -p "$(dirname "$MARKER_FILE")"
  touch "$MARKER_FILE"
  echo -e "${GREEN}✓ GPU drivers configured successfully!${NC}"
  echo "Terminal apps like Alacritty and Ghostty should now work."
else
  echo -e "${RED}✗ GPU setup failed${NC}"
  exit 1
fi

