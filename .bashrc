# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# The pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

[[ $TERM != "screen" ]] && exec tmux

parse_git_branch() {
     git branch --show-current 2>/dev/null | awk '{print "::"$0""}'
}

# Set up PS1
start='${debian_chroot:+($debian_chroot)}'
user_at_machine='\u@\h'
colon=':'
path='\w'
branch='$(parse_git_branch)'
end_promt='\$ '

# If color supported
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # rgb color: '\033[38;2;R;G;Bm'
    ocean='\033[38;2;0;175;175m'
    white='\[\033[00m\]'
    blue='\[\033[01;34m\]'
    orange='\[\033[0;38;5;208m\]'

    PS1=$start$ocean$user_at_machine$white$colon$blue$path$orange$branch$white$end_promt
else
    PS1=$start$user_at_machine$colon$path$branch$end_promt
fi

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
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ll'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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

export PATH=$PATH:/home/tom/.local/bin

# fix vscode cli inside tmux
socket=$(ls -1t /run/user/$UID/vscode-ipc-*.sock 2> /dev/null | head -1)
export VSCODE_IPC_HOOK_CLI=${socket}