#!/bin/bash

set -e
set -o pipefail

INSTALL_DIR="$HOME/.local/share/JetBrains/Toolbox"
SYMLINK_DIR="$HOME/.local/bin"

echo "Fectching jetbrains toolbox URL"
ARCHIVE_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}' | sed 's/[", ]//g')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

echo "Downloading $ARCHIVE_FILENAME..."
rm "/tmp/$ARCHIVE_FILENAME" 2>/dev/null || true
wget -q --show-progress -cO "/tmp/$ARCHIVE_FILENAME" "$ARCHIVE_URL"

echo "Extracting to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
rm "$INSTALL_DIR/jetbrains-toolbox" 2>/dev/null || true
tar -xzf "/tmp/$ARCHIVE_FILENAME" -C "$INSTALL_DIR" --strip-components=1
rm "/tmp/$ARCHIVE_FILENAME"
chmod +x "$INSTALL_DIR/bin/jetbrains-toolbox"

echo "Symlinking to $SYMLINK_DIR/jetbrains-toolbox..."
mkdir -p "$SYMLINK_DIR"
rm "$SYMLINK_DIR/jetbrains-toolbox" 2>/dev/null || true
ln -s "$INSTALL_DIR/bin/jetbrains-toolbox" "$SYMLINK_DIR/jetbrains-toolbox"

echo "Installation complete! Run jetbrains-toolbox"
