#!/bin/sh
# Claude Code status line: project · branch · model · context used · cost
# Colours are Vesper, to match tmux and Ghostty.
input=$(cat)
get() { printf '%s' "$input" | jq -r "$1 // empty" 2>/dev/null; }

dir=$(get '.workspace.current_dir // .cwd')
model=$(get '.model.display_name')
ctx=$(get '.context_window.used_percentage')
cost=$(get '.cost.total_cost_usd')
branch=$(git -C "$dir" branch --show-current 2>/dev/null)

c() { printf '\033[38;2;%sm%s\033[0m' "$1" "$2"; }
blue='255;199;153' mauve='153;255;228' green='144;185;159'
yellow='255;199;153' red='255;128;128' dim='126;126;126'

out=$(c "$blue" "${dir##*/}")
[ -n "$branch" ] && out="$out $(c "$mauve" " $branch")"
[ -n "$model" ] && out="$out $(c "$dim" "· $model")"
if [ -n "$ctx" ]; then
  pct=${ctx%.*}
  col=$green; [ "$pct" -ge 50 ] && col=$yellow; [ "$pct" -ge 80 ] && col=$red
  out="$out $(c "$dim" '·') $(c "$col" "${pct}% ctx")"
fi
[ -n "$cost" ] && out="$out $(c "$dim" "· \$$(printf '%.2f' "$cost")")"
printf '%s' "$out"
