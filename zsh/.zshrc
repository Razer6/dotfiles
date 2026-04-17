# ---------------------------------------------------------
# 1. Environment & Pathing
# ---------------------------------------------------------
# Initialize Homebrew for Apple Silicon Macs
if [[ "$(uname)" == "Darwin" ]]; then
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Load completion system
autoload -Uz compinit
compinit -i

# ---------------------------------------------------------
# 2. Antidote Plugin Manager
# ---------------------------------------------------------
if [[ -d "/opt/homebrew/opt/antidote/share/antidote" ]]; then
    ANTIDOTE_DIR="/opt/homebrew/opt/antidote/share/antidote"
elif [[ -d "/usr/share/zsh-antidote" ]]; then
    ANTIDOTE_DIR="/usr/share/zsh-antidote"
elif [[ -d "$HOME/.antidote" ]]; then
    ANTIDOTE_DIR="$HOME/.antidote"
fi

if [[ -n "${ANTIDOTE_DIR:-}" ]]; then
    source "$ANTIDOTE_DIR/antidote.zsh"
    antidote load ~/.zsh_plugins.txt
fi

# ---------------------------------------------------------
# 3. Shell Options & History
# ---------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY
setopt INTERACTIVE_COMMENTS

# ---------------------------------------------------------
# 4. Completion System Settings
# ---------------------------------------------------------
# Include hidden files in autocomplete
_comp_options+=(globdots)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:paths' accept-exact 'path'

# ---------------------------------------------------------
# 5. Aliases & Editor
# ---------------------------------------------------------
if command -v nvim &> /dev/null; then
    alias vim="nvim"
    alias vi="nvim"
    export EDITOR="nvim"
    export VISUAL="nvim"
fi

# Fuzzy Jump (zoxide + fzf)
fj() {
  local dir
  dir=$(zoxide query -l | fzf --height 40% --layout=reverse --border --preview 'ls -F -G {1}') && cd "$dir"
}

if command -v fdfind &> /dev/null; then alias fd='fdfind'; fi

alias ..="cd .."
alias ...="cd ../.."
if [[ "$(uname)" == "Darwin" ]]; then
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi

# ---------------------------------------------------------
# 6. Prompt & Terminal
# ---------------------------------------------------------
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    PROMPT='%F{cyan}%n@%m %F{blue}%1~ %F{white}%# '
fi
if [[ -z "$TMUX" ]]; then
    export TERM="xterm-256color"
fi

# ---------------------------------------------------------
# 7. Zoxide, FZF, and Substring Search
# ---------------------------------------------------------

# --- History Substring Search ---
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
zstyle ':history-substring-search:*' highlight-color 'fg=cyan,bold'

# --- Zoxide ---
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# --- FZF ---
if command -v fzf &> /dev/null; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
  [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
  if [[ "$(uname)" == "Darwin" ]]; then
    [ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
  fi
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=16"
fi

# ---------------------------------------------------------
# 8. Local Overrides
# ---------------------------------------------------------
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi
