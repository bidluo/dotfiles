#!/bin/sh
# Claude Code hook: mark this tmux window with Claude's state.
# Shown in the status bar and filtered by `prefix a` (see shared/tmux.conf).
# Usage: tmux-flag.sh waiting|done|clear
[ -n "$TMUX_PANE" ] || exit 0
cat > /dev/null # drain the hook's JSON

case "$1" in
  waiting) flag="●" ;;
  done)    flag="✓" ;;
  *)       tmux set -wu -t "$TMUX_PANE" @claude 2>/dev/null; exit 0 ;;
esac

tmux set -w -t "$TMUX_PANE" @claude "$flag" 2>/dev/null
# Ring the bell on the pane so monitor-bell flags the window
tty=$(tmux display -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null)
[ -w "$tty" ] && printf '\a' > "$tty"
exit 0
