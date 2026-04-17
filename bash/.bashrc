# ---------------------------------------------------------
# 1. Source shared config
# ---------------------------------------------------------
[ -f ~/.shell_common ] && . ~/.shell_common

# ---------------------------------------------------------
# 2. History
# ---------------------------------------------------------
HISTFILE="$HOME/.bash_history"
HISTSIZE=10000000
HISTFILESIZE=10000000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# ---------------------------------------------------------
# 3. Shell Options
# ---------------------------------------------------------
shopt -s checkwinsize
shopt -s globstar 2>/dev/null
shopt -s cdspell

# ---------------------------------------------------------
# 4. Completion
# ---------------------------------------------------------
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ "$(uname)" = "Darwin" ] && command -v brew > /dev/null 2>&1; then
    _brew_prefix="$(brew --prefix)"
    [ -f "$_brew_prefix/etc/profile.d/bash_completion.sh" ] && . "$_brew_prefix/etc/profile.d/bash_completion.sh"
    unset _brew_prefix
fi

# ---------------------------------------------------------
# 5. Prompt
# ---------------------------------------------------------
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init bash)"
else
    PS1='\[\033[36m\]\u@\h \[\033[34m\]\W \[\033[0m\]\$ '
fi

# ---------------------------------------------------------
# 6. Local Overrides
# ---------------------------------------------------------
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
