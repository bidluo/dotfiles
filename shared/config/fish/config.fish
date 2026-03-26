set fish_greeting
fish_ssh_agent

set PATH ~/.local/bin $PATH
set -gx PATH /sbin /usr/sbin ~/.local/bin $PATH

set -gx GPG_TTY (tty)
set -gx DIRENV_LOG_FORMAT 
direnv hook fish | source

#/Users/david/.local/bin/mise activate fish | source
