# Aliases to go to prior directories.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Quick exit.
alias q=exit

# Make watch/sudo work with aliases and other expansions.
alias watch='watch -n0.5 '
alias sudo='sudo '

# Interactive versions - will prompt if something will be overwritten.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Make nested directories without complaint.
alias mkdir='mkdir -p'

# Nicer rename.
autoload -U zmv

# Bind 'j' so it acts like autojump.
alias j='fasd_cd -d'

# Force TERM for ssh as remote systems may not have the same terminfo.
alias ssh='TERM=xterm-color ssh'

# Alias to make a directory then cd into it.
take() {
  mkdir "$1" && cd "$1";
}; compdef take=mkdir

# Man pages for zshell.
zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall;
}

# Set a reminder in the future.
r() {
  local time=$1; shift
  sched "$time" "notify-send --urgency=critical 'Reminder' '$@'";
}; compdef r=sched

# exa
alias exa="exa --group-directories-first"
alias l="exa -1"
alias la="LC_COLLATE=C exa -la"
alias ll="exa -lg"
alias ls="exa"

# git
alias g="git"

# pretty print json logs
ppjson() {
    stdbuf -oL jq -rC '.'  | sed 's/\\n/\n/g; s/\\t/\t/g'
}
