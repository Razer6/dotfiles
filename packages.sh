# Same names across Homebrew, DNF, and APT
COMMON_PACKAGES=(
    "git"
    "neovim"
    "zsh"
    "antidote"
    "tmux"
    "fzf"
    "ripgrep"
    "make"
    "zoxide"
    "starship"
)

# Truly OS-specific tools or different names
MAC_PACKAGES=(
    "fd"
    "gcc"
    "visual-studio-code"
    "ghostty"
)

# RHEL/Rocky specific
RHEL_PACKAGES=(
    "fd-find"
    "gcc"
    "gcc-c++"
    "unzip"
)

# Ubuntu/Debian specific
DEBIAN_PACKAGES=(
    "fd-find"
    "gcc"
    "g++"
    "unzip"
    "code"
    "ghostty"
)
