# ~/.dotfiles/zsh/.zshrc

# ---------------------------------------------------------
# 1. Environment & Pathing
# ---------------------------------------------------------
# Initialize Homebrew for Apple Silicon Macs
if [[ "$(uname)" == "Darwin" ]]; then
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

autoload -Uz compinit
compinit -i  # The -i flag ignores insecure directories (common on macOS)

# ---------------------------------------------------------
# 2. Antidote Plugin Manager
# ---------------------------------------------------------
# Identify Antidote location (Mac Brew vs. Linux System vs. Manual Git)
if [[ -d "/opt/homebrew/opt/antidote/share/antidote" ]]; then
    ANTIDOTE_DIR="/opt/homebrew/opt/antidote/share/antidote"
elif [[ -d "/usr/share/zsh-antidote" ]]; then
    ANTIDOTE_DIR="/usr/share/zsh-antidote"
elif [[ -d "$HOME/.antidote" ]]; then
    ANTIDOTE_DIR="$HOME/.antidote"
fi

# Initialize Antidote and load plugins
if [[ -n "${ANTIDOTE_DIR:-}" ]]; then
    source "$ANTIDOTE_DIR/antidote.zsh"
    # Ensure this file is stowed in ~/.zsh_plugins.txt
    antidote load ~/.zsh_plugins.txt
fi

# ---------------------------------------------------------
# 3. Shell Options & History
# ---------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory      # Append to history file, don't overwrite
setopt sharehistory       # Share history between different sessions
setopt hist_ignore_dups   # Don't record transitions that are duplicates
setopt hist_ignore_space  # Don't record commands starting with a space
setopt interactivecomments # Allow comments in interactive shell

# ---------------------------------------------------------
# 4. Completion System
# ---------------------------------------------------------
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive

# ---------------------------------------------------------
# 5. Aliases & Editor
# ---------------------------------------------------------
# Neovim as the primary editor
if command -v nvim &> /dev/null; then
    alias vim="nvim"
    alias vi="nvim"
    export EDITOR="nvim"
    export VISUAL="nvim"
fi

# Linux/RHEL fd-find fix
if command -v fdfind &> /dev/null; then
    alias fd='fdfind'
fi

# Navigation & Listing
alias ..="cd .."
alias ...="cd ../.."
if [[ "$(uname)" == "Darwin" ]]; then
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi

# ---------------------------------------------------------
# 6. Prompt
# ---------------------------------------------------------
# A clean, minimal prompt
# Format: username@hostname current_dir %
PROMPT='%F{cyan}%n@%m %F{blue}%1~ %F{white}%# '
# Ensure 256-color support for Neovim/Plugins
export TERM="xterm-256color"

# ---------------------------------------------------------
# 7. Local Overrides
# ---------------------------------------------------------
# Load a local config for secrets or machine-specific settings
# This file should NOT be in your git repo
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi
