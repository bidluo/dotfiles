set fish_greeting
fish_ssh_agent

fish_add_path -g ~/.local/bin

set -gx GPG_TTY (tty)
set -gx DIRENV_LOG_FORMAT ""
direnv hook fish | source

#/Users/david/.local/bin/mise activate fish | source
