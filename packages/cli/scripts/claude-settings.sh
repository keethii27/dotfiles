#!/bin/sh

# ~/.claude/settings.json を settings.default.json と settings.local.json から生成する
# 運用ルールは README の「Claude Code の設定」を参照

set -e

SETTINGS_PATH=~/src/github.com/keethii27/dotfiles/packages/claude/.claude
default_settings="$SETTINGS_PATH"/settings.default.json
local_settings="$SETTINGS_PATH"/settings.local.json
target=~/.claude/settings.json

[ -f "$local_settings" ] || local_settings=/dev/null

mkdir -p ~/.claude
tmp_dir=$(mktemp -d)
# 置き換えを原子的にするため、生成先と同じディレクトリに書き出す
new="$target.tmp"
trap 'rm -rf "$tmp_dir" "$new"' EXIT

jq -s '.[0] * (.[1] // {})' "$default_settings" "$local_settings" > "$new"

if [ -f "$target" ]; then
    jq -S . "$target" > "$tmp_dir"/before.sorted.json
    jq -S . "$new" > "$tmp_dir"/after.sorted.json

    if cmp -s "$tmp_dir"/before.sorted.json "$tmp_dir"/after.sorted.json; then
        echo 'No changes'
        exit 0
    fi

    backup="$target.bak.$(date +%Y%m%d%H%M%S)"
    cp -p "$target" "$backup"
    echo "Backup: $backup"
fi

mv "$new" "$target"
echo "Generated: $target"

if [ -n "$backup" ]; then
    diff -u --label "$backup" --label "$target" \
        "$tmp_dir"/before.sorted.json "$tmp_dir"/after.sorted.json || true
fi
