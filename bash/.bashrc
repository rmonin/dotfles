# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

XDG_CONFIG_HOME="${HOME}/.config"
XDG_STATE_HOME="${HOME}/.local/state"
XDG_DATA_HOME="${HOME}/.local/share"

# https://github.com/sharkdp/bat?tab=readme-ov-file#integration-with-other-tools
mkdir -p ~/.local/bin
PATH="${PATH}:${HOME}/.local/bin"

init_dir="${XDG_CONFIG_HOME}/sh/init.d"
if [[ -d ${init_dir} && -n $(ls -A ${init_dir}) ]]; then
    for file in ${init_dir}/*; do
        source ${file}
    done
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

mkdir -p ${XDG_STATE_HOME}/sh

HISTFILE="${XDG_STATE_HOME}/sh/history"
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=2000

LANG='en_US.UTF-8'
LC_ALL='en_US.UTF-8'

export LANG LC_ALL
export EDITOR=vim VISUAL=view
export XDG_CONFIG_HOME XDG_STATE_HOME XDG_DATA_HOME
export XDG_RUNTIME_DIR="/run/user/${UID}"
export XDG_CACHE_HOME="${HOME}/.cache"
export TERM=xterm-256color

exports_dir="${XDG_CONFIG_HOME}/sh/exports.d"
if [[ -d ${exports_dir} && -n $(ls -A ${exports_dir}) ]]; then
    for file in ${exports_dir}/*; do
        source ${file}
    done
fi

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ "$color_prompt" = yes ]; then
    PS1='╭ ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='╭ ${debian_chroot:+($debian_chroot)}\u@\h \w\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lh'
alias la='ls -lAh'
alias lr='ls -lrh'
alias lra='ls -lrAh'
alias ldot='ls -ldh .*'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

alias wtf='sudo dmesg | less'

aliases_dir="${XDG_CONFIG_HOME}/sh/aliases.d"
if [[ -d ${aliases_dir} && -n $(ls -A ${aliases_dir}) ]]; then
    for file in ${aliases_dir}/*; do
        source ${file}
    done
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
