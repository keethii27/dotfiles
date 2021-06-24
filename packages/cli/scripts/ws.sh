#!/bin/sh

attach_target="$1"

ensure_session() {
  session_name="$1"
  repo="$2"

  if ! tmux has-session -t "$session_name" 2>/dev/null; then
    tmux new -d -s "$session_name" -c "$HOME/src/github.com/$repo"
  fi
}

ensure_session Personal edm20627/dotfiles
ensure_session xxx xxx/xxxx

if [ -z "$TMUX" ]; then
  if [ -n "$attach_target" ]; then
    tmux a "$attach_target"
  else
    tmux a
  fi
fi
