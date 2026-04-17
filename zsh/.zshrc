# ---------------------------------------------------------
# 1. Source shared config
# ---------------------------------------------------------
[ -f ~/.shell_common ] && source ~/.shell_common

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
    fpath+=($(antidote path zsh-users/zsh-completions)/src)
fi

autoload -Uz compinit
compinit -i

if [[ -n "${ANTIDOTE_DIR:-}" ]]; then
    antidote load ~/.zsh_plugins.txt
fi

# ---------------------------------------------------------
# 3. History
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
# 4. Completion
# ---------------------------------------------------------
_comp_options+=(globdots)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:paths' accept-exact 'path'

bindkey '^I' complete-word
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(complete-word)

# ---------------------------------------------------------
# 5. Prompt
# ---------------------------------------------------------
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    PROMPT='%F{cyan}%n@%m %F{blue}%1~ %F{white}%# '
fi

# ---------------------------------------------------------
# 6. History Substring Search
# ---------------------------------------------------------
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
zstyle ':history-substring-search:*' highlight-color 'fg=cyan,bold'

# ---------------------------------------------------------
# 7. Local Overrides
# ---------------------------------------------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
