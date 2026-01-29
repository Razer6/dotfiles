#!/bin/bash

set -e
set -u
set -o pipefail

# Discover the absolute path of the script's directory
# This works even if you run the script from a different folder
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS=$(uname)

# 1. Load Package Manifest
if [ -f "$DOTFILES_DIR/packages.sh" ]; then
    source "$DOTFILES_DIR/packages.sh"
else
    echo "Error: packages.sh not found at $DOTFILES_DIR"
    exit 1
fi

echo "Starting installation for $OS..."

# ---------------------------------------------------------
# 2. Operating System Specific Setup
# ---------------------------------------------------------
case "$OS" in
    Darwin)
        echo "Detected macOS (Apple Silicon)"
        
        # Install Homebrew if missing
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        echo "Installing packages via Homebrew..."
        brew install "${COMMON_PACKAGES[@]}" "${MAC_PACKAGES[@]}"
        
        # Run macOS system defaults
        if [ -f "$DOTFILES_DIR/macos/set-defaults.sh" ]; then
            echo "Applying macOS system defaults..."
            bash "$DOTFILES_DIR/macos/set-defaults.sh"
        fi
        # Ensure Apple's command line tools are installed (provides system clang/make)
        if ! xcode-select -p &>/dev/null; then
            echo "Installing Xcode Command Line Tools..."
            xcode-select --install
            echo "Please finish the Xcode installation UI and then re-run this script."
            exit 0
        fi
        ;;

    Linux)
        # Identify the Linux distribution
        if [ -f /etc/redhat-release ]; then
            echo "Detected RHEL/Rocky Linux"
            sudo dnf install -y epel-release
            sudo dnf install -y "${COMMON_PACKAGES[@]}" "${RHEL_PACKAGES[@]}"
            
        elif [ -f /etc/debian_version ] || [ -f /etc/lsb-release ]; then
            echo "Detected Ubuntu/Debian"
            sudo apt update
            sudo apt install -y "${COMMON_PACKAGES[@]}" "${DEBIAN_PACKAGES[@]}"
            
        else
            echo "Unsupported Linux distribution."
            exit 1
        fi
        ;;

    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# ---------------------------------------------------------
# 3. Antidote Manual Fallback
# ---------------------------------------------------------
# If antidote is not in the system path, check for a manual install
if ! command -v antidote &> /dev/null; then
    if [ ! -d "$HOME/.antidote" ]; then
        echo "Installing Antidote manually..."
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
    fi
fi

# ---------------------------------------------------------
# 4. Symlink configurations with GNU Stow
# ---------------------------------------------------------
echo "Linking configurations..."

# Ensure Stow is available
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is not installed."
    exit 1
fi

cd "$DOTFILES_DIR"

# Loop through top-level directories and link them
# Use find to get list of directories, excluding hidden ones and the macos folder
for dir in $(find . -maxdepth 1 -type d -not -path '*/.*' -not -path '.' -not -path './macos'); do
    folder=$(basename "$dir")
    
    echo "Stowing: $folder"
    stow --adopt -t "$HOME" -R "$folder"
done

echo "Done! Installation finished successfully."
