# dotfiles

## 端末の移行

### 旧端末

1. git 管理外の端末固有ファイルをバックアップする
   - `packages/terminal/.zsh/.zshrc_local`
   - `packages/claude/.claude/settings.local.json`
2. Raycast の設定を書き出す

### 新端末

1. `HOMEBREW_MACHINE_TYPE`（`personal` / `work`）を指定し、`-m` を付けて `dotfiles.sh` を実行する。指定しないと Brewfile の `personal` / `work` のブロックがインストールされない
   ```
   HOMEBREW_MACHINE_TYPE=personal sh -c "$(curl -fsSL https://raw.githubusercontent.com/keethii27/dotfiles/main/packages/cli/scripts/dotfiles.sh)" dotfiles.sh -m
   ```
2. バックアップした端末固有ファイルを元の場所に戻し、`~/scripts/claude-settings.sh` で Claude Code の設定を生成し直す
   - `.zshrc_local` がない場合は作成し、`export HOMEBREW_MACHINE_TYPE=personal`（または `work`）を書く
3. `gh auth login` を実行する（Git の認証に gh を使うため）
4. 旧端末で書き出した Raycast の設定を読み込む

## Claude Code の設定

`~/.claude/settings.json` は次の 2 ファイルから生成する。直接のリンクはしない。

- `packages/claude/.claude/settings.default.json`: 全端末共通（git 管理。個人情報・社内情報は書かない）
- `packages/claude/.claude/settings.local.json`: 端末固有（git 管理外）

生成: `~/scripts/claude-settings.sh`（変更がなければ何もしない。変更があればバックアップを取り、差分を表示する）

`dotfiles.sh` は `settings.json` がない場合のみ生成する。既存の端末で生成する場合は `-c`（`--claude-settings`）を付ける。

Claude Code 自身の変更（`/plugin` など）も `settings.json` に書き込まれる。
残したい変更は上の 2 ファイルに反映してから生成し直す。
生成時の差分で `-` の行は反映し忘れた変更で、戻す場合はバックアップ（`settings.json.bak.*`）から復元する。

## macOS の設定

`packages/cli/scripts/macos-defaults.sh` で管理する。

- `~/scripts/macos-defaults.sh`: 現在の値との差分を表示する（変更しない）
- `~/scripts/macos-defaults.sh --apply`: 差分のある設定を書き込む

`dotfiles.sh` は差分を表示するだけで、`-m`（`--macos-defaults`）を付けた場合のみ書き込む。新しい端末では `-m` を付けて実行する。

設定アプリなどで変えた値は `--apply` で上書きされる。残したい場合は `macos-defaults.sh` に反映する。
