[ -f ~/.bashrc ] && . ~/.bashrc

# Init prompt last — after system profile.d scripts that may clear PROMPT_COMMAND
type _init_prompt &>/dev/null && _init_prompt
