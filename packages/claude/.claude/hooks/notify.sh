#!/bin/sh
# VS Code のターミナルでのみ通知する（cmux とデスクトップアプリは自前で通知するため）
[ "$TERM_PROGRAM" = vscode ] || exit 0

input=$(cat)
message=$(printf '%s' "$input" | jq -r '
  if .hook_event_name == "Stop" then "作業が完了しました"
  elif .notification_type == "permission_prompt" then "承認待ちです"
  else "入力待ちです" end')
dir=$(printf '%s' "$input" | jq -r '.cwd')
repo=$(basename "$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null || echo "$dir")")
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-')

osascript \
    -e 'on run argv' \
    -e 'display notification (item 1 of argv) with title "Claude Code" subtitle (item 2 of argv) sound name "Glass"' \
    -e 'end run' \
    "$message" "$repo ($branch)"
