# ── Every shell (incl. non-interactive, e.g. tmux/ssh commands) ─────────────
fish_add_path -g ~/.local/bin
set -gx GPG_TTY (tty)
test -f ~/.cargo/env.fish; and source ~/.cargo/env.fish
if type -q direnv
    set -gx DIRENV_LOG_FORMAT ""
    direnv hook fish | source
end

if status is-interactive
    # ── Environment ──────────────────────────────────────────────────────────
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx BAT_THEME base16-256          # follows the terminal (matugen) palette
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT -c

    # fzf: colours inherit the 16 ANSI (matugen) colours; tidy layout
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
    set -gx FZF_DEFAULT_OPTS '--height 45% --layout=reverse --border=rounded --prompt="  " --pointer="▶" --marker="✓"'

    # ── Prompt ───────────────────────────────────────────────────────────────
    if type -q starship
        starship init fish | source
    end

    # ── Tool integrations ────────────────────────────────────────────────────
    type -q zoxide; and zoxide init fish | source
    type -q fzf; and fzf --fish | source

    # ── Abbreviations ────────────────────────────────────────────────────────
    # Listings (eza)
    abbr -a ls 'eza --icons --group-directories-first'
    abbr -a ll 'eza -l --icons --group-directories-first --git'
    abbr -a la 'eza -la --icons --group-directories-first --git'
    abbr -a lt 'eza --tree --icons --level=2'
    # Git
    abbr -a g git
    abbr -a gs 'git status -sb'
    abbr -a ga 'git add'
    abbr -a gc 'git commit'
    abbr -a gp 'git push'
    abbr -a gl 'git pull'
    abbr -a gd 'git diff'
    abbr -a gco 'git checkout'
    abbr -a lg lazygit
    # Editor / tools
    abbr -a v nvim
    abbr -a vim nvim
    abbr -a y yazi
    abbr -a cl clear
    # Claude Code
    abbr -a cc claude
    abbr -a ccc claude --continue
    abbr -a ccr claude --resume
    # Rice
    abbr -a wl wall

    # ── Greeting ─────────────────────────────────────────────────────────────
    function fish_greeting
        type -q fastfetch; and fastfetch
    end
end
