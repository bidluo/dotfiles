#!/bin/sh
# tmux `prefix A`: ask Claude about the last 200 lines of the current pane.
# Runs inside a display-popup; the pane you came from is still the active one.
PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
here=$(dirname "$(readlink -f "$0")")

pane=$(tmux display -p '#{pane_id}')
title=$(tmux display -p '#{=/40/…:pane_title}')
cd "$(tmux display -p '#{pane_current_path}')" 2>/dev/null

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"; printf "\033[?25h"' EXIT INT TERM
tmux capture-pane -t "$pane" -pJS -200 > "$tmp/pane"

claude -p "This is the end of my terminal output. Say what went wrong in one short line, then how to fix it. Use brief Markdown; code blocks for commands." \
  < "$tmp/pane" > "$tmp/answer" 2>&1 &
pid=$!

# Spinner with elapsed time while Claude thinks
peach='\033[38;2;255;199;153m' dim='\033[38;2;126;126;126m' off='\033[0m'
printf '\033[?25l\n'
i=0 start=$(date +%s)
while kill -0 "$pid" 2>/dev/null; do
  case $((i % 10)) in
    0) f='⠋';; 1) f='⠙';; 2) f='⠹';; 3) f='⠸';; 4) f='⠼';;
    5) f='⠴';; 6) f='⠦';; 7) f='⠧';; 8) f='⠇';; *) f='⠏';;
  esac
  printf "\r  ${peach}%s${off} Asking Claude about ${peach}%s${off} ${dim}%ss${off}  " \
    "$f" "$title" "$(( $(date +%s) - start ))"
  i=$((i + 1)); sleep 0.08
done
wait "$pid"; status=$?
printf '\r\033[K\033[?25h'

width=$(( $(tput cols) - 4 ))
{
  if [ "$status" -ne 0 ]; then
    printf "  \033[38;2;255;128;128mclaude exited with %s\033[0m\n\n" "$status"
    cat "$tmp/answer"
  elif command -v glow > /dev/null; then
    glow -s "$here/glow-vesper.json" -w "$width" "$tmp/answer" < /dev/null
  else
    cat "$tmp/answer"
  fi
  printf "\n  ${dim}q to close · / to search${off}\n"
} | less -R --prompt=' ' -~
