# dotfiles

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/keethii27/dotfiles/main/packages/cli/scripts/dotfiles.sh)"
```

## Claude Code の設定

`~/.claude/settings.json` は次の 2 ファイルから生成する。直接のリンクはしない。

- `packages/claude/.claude/settings.default.json`: 全端末共通（git 管理。個人情報・社内情報は書かない）
- `packages/claude/.claude/settings.local.json`: 端末固有（git 管理外）

生成: `~/scripts/claude-settings.sh`（変更がなければ何もしない。変更があればバックアップを取り、差分を表示する）

`dotfiles.sh` は `settings.json` がない場合のみ生成する。既存の端末で生成する場合は `-c`（`--claude-settings`）を付ける。

Claude Code 自身の変更（`/plugin` など）も `settings.json` に書き込まれる。
残したい変更は上の 2 ファイルに反映してから生成し直す。
生成時の差分で `-` の行は反映し忘れた変更で、戻す場合はバックアップ（`settings.json.bak.*`）から復元する。
