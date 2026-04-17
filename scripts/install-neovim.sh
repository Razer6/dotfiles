#!/bin/bash
set -e

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

OS=$(uname)
ARCH=$(uname -m)

case "$OS" in
    Linux)
        case "$ARCH" in
            x86_64)  TARBALL="nvim-linux-x86_64.tar.gz" ;;
            aarch64) TARBALL="nvim-linux-arm64.tar.gz" ;;
            *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
        esac
        ;;
    Darwin)
        case "$ARCH" in
            x86_64)  TARBALL="nvim-macos-x86_64.tar.gz" ;;
            arm64)   TARBALL="nvim-macos-arm64.tar.gz" ;;
            *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
        esac
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

INSTALL_DIR="$HOME/.local/nvim"
URL="https://github.com/neovim/neovim/releases/latest/download/$TARBALL"

echo "Downloading Neovim ($TARBALL)..."
curl -sL "$URL" -o "/tmp/$TARBALL"

echo "Extracting to $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
tar xzf "/tmp/$TARBALL" -C "$INSTALL_DIR" --strip-components=1
rm -f "/tmp/$TARBALL"

ln -sf "$INSTALL_DIR/bin/nvim" "$BIN_DIR/nvim"

echo "Done. Neovim installed at $BIN_DIR/nvim"
echo "PATH is handled by .shell_common — just open a new shell."
