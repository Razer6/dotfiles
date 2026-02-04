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
# --- History Settings ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

# Options:
# - Share history across all open terminals
# - Ignore duplicates
# - Don't record commands starting with a space

setopt SHARE_HISTORY          # Share history between different sessions
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded duplicate of a command
setopt HIST_IGNORE_SPACE      # Don't record commands starting with a space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks from history strings
setopt APPEND_HISTORY         # Append to history file, don't overwrite
setopt INTERACTIVE_COMMENTS   # Allow comments in interactive shell

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

# --- History Substring Search Config ---

# 1. Bind the Up/Down keys for normal mode
# These cover most terminal emulators
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# 2. Bind the Up/Down keys for 'Application Mode' (common in tmux/iterm)
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# 3. Optional: Color the matching part of the query
zstyle ':history-substring-search:*' highlight-color 'fg=cyan,bold'

# --- Zoxide (Smarter cd) ---
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"

  # Optional: Replace 'cd' with 'z' entirely
  alias cd='z'
fi

# --- FZF Configuration ---
if command -v fzf &> /dev/null; then
  # Set up shell integration (Standard paths)
  # This enables Ctrl-R for history and Ctrl-T for files
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  # For Debian/Ubuntu/Fedora where fzf is installed via package manager:
  [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
  [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

  # For macOS (Homebrew path)
  [ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

  # Options: Use a popup window and nice colors
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=16"
fi
