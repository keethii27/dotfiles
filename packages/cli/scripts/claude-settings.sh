#!/bin/sh

# ~/.claude/settings.json を settings.default.json と settings.local.json から生成する
# オプションなし: 現在の設定との差分を表示するだけで、変更しない
# -a, --apply:   差分があればバックアップを取って書き込む
# 運用ルールは README の「Claude Code の設定」を参照

set -e

apply=
for i in "$@"; do
    case "$i" in
        -a|--apply)
            apply=1 ;;
        *)
            echo "Unknown option: $i" >&2
            exit 1 ;;
    esac
done

SOURCE_PATH=~/src/github.com/keethii27/dotfiles/packages/claude/.claude
default_settings="$SOURCE_PATH"/settings.default.json
local_settings="$SOURCE_PATH"/settings.local.json
target=~/.claude/settings.json

[ -f "$local_settings" ] || local_settings=/dev/null

tmp_dir=$(mktemp -d)
# 書き込み時に置き換えを原子的にするため、生成先と同じディレクトリに置く一時ファイル
target_tmp="$target.tmp"
trap 'rm -rf "$tmp_dir" "$target_tmp"' EXIT

new="$tmp_dir"/settings.json
jq -s '.[0] * (.[1] // {})' "$default_settings" "$local_settings" > "$new"

if [ -f "$target" ]; then
    jq -S . "$target" > "$tmp_dir"/before.sorted.json
    jq -S . "$new" > "$tmp_dir"/after.sorted.json

    if cmp -s "$tmp_dir"/before.sorted.json "$tmp_dir"/after.sorted.json; then
        echo 'No changes'
        exit 0
    fi

    diff -u --label "$target" --label "$target (generated)" \
        "$tmp_dir"/before.sorted.json "$tmp_dir"/after.sorted.json || true
else
    echo "Will be created: $target"
fi

if [ ! "$apply" ]; then
    echo 'Run with --apply to write these settings'
    exit 0
fi

if [ -f "$target" ]; then
    backup="$target.bak.$(date +%Y%m%d%H%M%S)"
    cp -p "$target" "$backup"
    echo "Backup: $backup"
fi

mkdir -p ~/.claude
cp "$new" "$target_tmp"
mv "$target_tmp" "$target"
echo "Applied: $target"
