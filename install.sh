#!/bin/bash

set -e
set -u
set -o pipefail

SKIP_DEPS=false
SKIP_LIST=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-deps) SKIP_DEPS=true ;;
        --skip)
            IFS=',' read -ra items <<< "$2"
            SKIP_LIST+=("${items[@]}")
            shift
            ;;
    esac
    shift
done

should_skip() {
    local name="$1"
    for item in "${SKIP_LIST[@]+"${SKIP_LIST[@]}"}"; do
        [[ "$item" == "$name" ]] && return 0
    done
    return 1
}

# Discover the absolute path of the script's directory
# This works even if you run the script from a different folder
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS=$(uname)

if [ "$SKIP_DEPS" = false ]; then

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
        if should_skip "macos"; then
            echo "Skipping macOS defaults (--skip)"
        elif [ -f "$DOTFILES_DIR/macos/set-defaults.sh" ]; then
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
            # Debian/Ubuntu repo setup for VS Code
            sudo apt update && sudo apt install -y wget gpg
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
            rm -f packages.microsoft.gpg
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

else
    echo "Skipping dependency installation (--no-deps)"
fi

# ---------------------------------------------------------
# 3. App-Specific Manual Configs
# ---------------------------------------------------------
# Antidote
if ! command -v antidote &> /dev/null && [ ! -d "$HOME/.antidote" ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
fi

# VS Code Settings (Only link if 'code' was actually installed)
if should_skip "vscode"; then
    echo "Skipping VS Code config (--skip)"
elif command -v code &> /dev/null; then
    echo "Linking VS Code Settings..."
    VSCODE_USER_DIR="$HOME/.config/Code/User"
    [[ "$OS" == "Darwin" ]] && VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

    mkdir -p "$VSCODE_USER_DIR"
    [ -f "$DOTFILES_DIR/vscode/settings.json" ] && ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
fi

# ---------------------------------------------------------
# 4. Preserve existing machine-specific configs
# ---------------------------------------------------------
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "Existing .zshrc found, moving to .zshrc.local..."
    if [ -f "$HOME/.zshrc.local" ]; then
        cat "$HOME/.zshrc" >> "$HOME/.zshrc.local"
    else
        mv "$HOME/.zshrc" "$HOME/.zshrc.local"
    fi
fi

if [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
    echo "Existing .gitconfig found, moving to .gitconfig.local..."
    if [ -f "$HOME/.gitconfig.local" ]; then
        cat "$HOME/.gitconfig" >> "$HOME/.gitconfig.local"
    else
        mv "$HOME/.gitconfig" "$HOME/.gitconfig.local"
    fi
fi

# ---------------------------------------------------------
# 5. Symlink configurations with GNU Stow
# ---------------------------------------------------------
echo "Linking configurations..."
cd "$DOTFILES_DIR"

# Ensure Stow is available
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is not installed."
    exit 1
fi

# Folders to ignore (logic handled elsewhere or not meant for $HOME)
IGNORE_LIST=("vscode" "macos" "." ".." ${SKIP_LIST[@]+"${SKIP_LIST[@]}"})

# Loop through all directories
for dir in */; do
    # Remove trailing slash
    folder=${dir%/}
    
    # Check if folder is in the ignore list
    if [[ ! " ${IGNORE_LIST[@]} " =~ " ${folder} " ]]; then
        echo "Stowing: $folder"
        stow --adopt -t "$HOME" "$folder"
        stow -t "$HOME" -R "$folder"
    else
        echo "Skipping ignored folder: $folder"
    fi
done

echo "Done! Installation finished successfully."
