#!/bin/bash
set -e

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

echo "Downloading Starship to $BIN_DIR..."
curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "$BIN_DIR" --yes

echo "Done. Starship installed at $BIN_DIR/starship"
echo "PATH and shell init are handled by .shell_common — just open a new shell."
