# Same names across Homebrew, DNF, and APT
COMMON_PACKAGES=(
    "stow"
    "git"
    "neovim"
    "zsh"
    "antidote"
    "tmux"
    "fzf"
    "ripgrep"
    "make"
)

# Truly OS-specific tools or different names
MAC_PACKAGES=(
    "fd"
    "gcc"
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
)
