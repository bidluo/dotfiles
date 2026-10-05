# Vesper colours for every fzf picker (fzf.fish, zi, …); bat previews use the
# terminal's own palette. fzf.fish keys: ctrl-r history, ctrl-alt-f files,
# ctrl-alt-l git log, ctrl-alt-s git status, ctrl-alt-p processes, ctrl-v vars.
set -gx FZF_DEFAULT_OPTS "--layout=reverse --border=rounded --info=inline-right \
--color=bg+:#1c1c1c,fg+:#ffffff,hl:#ffc799,hl+:#ffc799,border:#3a3a3a,label:#ffc799 \
--color=prompt:#ffc799,pointer:#ffc799,marker:#99ffe4,spinner:#99ffe4,header:#7e7e7e,info:#7e7e7e"
set -gx BAT_THEME ansi
