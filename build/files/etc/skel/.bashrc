#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Don't put commands prefixed with space, or duplicate commands in history
export HISTCONTROL=ignoreboth

# Load a Kies menu, but only if this is the first shell
[ SHLVL -eq 1 ] && kiesmenu
