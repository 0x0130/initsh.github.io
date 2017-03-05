# profile.d

# Edit 20170306

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# commands
cat <<__EOD__

        date | $(date -Is)
    hostname | $(uname -n)
      whoami | $(id)

__EOD__

# aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias crontab='crontab -i'
alias ls='ls --color=auto'
alias l='ls'
alias ll='ls -l'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
[ -f '/usr/bin/vi'  ] && alias visudo="EDITOR='/usr/bin/vi' visudo"
[ -f '/usr/bin/vim' ] && alias visudo="EDITOR='/usr/bin/vim' visudo"

# interactive shells
[ "$(echo "$PS1" | grep date)" ] || PS1="$(echo "$PS1" | sed -r -e 's/\\h/\\h $(date +%H:%M:%S)/g')"

# history timestamp ISO 8601
HISTTIMEFORMAT='%Y-%m-%dT%T%z '

# functions
HeadHighlight() { head $@ | sed -r -e 's/^(==>.+<==)$/'$'\e[31m''\1'$'\e[0m''/g'; }
alias head='HeadHighlight'

TailHighlight() { tail $@ | sed -r -e 's/^(==>.+<==)$/'$'\e[31m''\1'$'\e[0m''/g'; }
alias tail='TailHighlight'


# EOF
