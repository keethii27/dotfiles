# dotfiles

## 構成

- `packages/`: stow のパッケージ。1 ツール 1 パッケージで、ホームディレクトリにリンクする
- `Brewfile`: Homebrew でインストールするもの
- `packages/scripts/scripts/`: セットアップ用のスクリプト（`~/scripts` にリンクする）

## dotfiles.sh

インストール、リンク、各種設定をまとめて行う。何度実行してもよい。

| オプション | 内容 |
|---|---|
| `-s`, `--skip-brew` | `brew bundle` を省く |
| `-c`, `--claude-settings` | Claude Code の設定を書き込む（ない場合は指定しなくても作成する） |
| `-m`, `--macos-defaults` | macOS の設定を書き込む |
| `-u <package>`, `--unlink <package>` | パッケージのリンクを外して終了する。複数指定できる |

ファイルごとにリンクするため、設定ファイルを追加したら `dotfiles.sh -s` を実行してリンクする。

## 端末固有の設定

git 管理外。リポジトリに置けない値（社内情報など）だけを書く。

- `packages/zsh/.zsh/.zshrc_local`: `HOMEBREW_MACHINE_TYPE`（`personal` / `work`）、仕事用のエイリアスなど
- `packages/claude/.claude/settings.local.json`: Claude Code の端末固有の設定

## 端末の移行

### 旧端末

1. 端末固有の設定をバックアップする
2. Raycast の設定を書き出す

### 新端末

1. `HOMEBREW_MACHINE_TYPE` を指定し、`-m` を付けて `dotfiles.sh` を実行する。指定しないと Brewfile の `personal` / `work` のブロックがインストールされない
   ```
   HOMEBREW_MACHINE_TYPE=personal sh -c "$(curl -fsSL https://raw.githubusercontent.com/keethii27/dotfiles/main/packages/scripts/scripts/dotfiles.sh)" dotfiles.sh -m
   ```
2. バックアップした端末固有の設定を戻し、`~/scripts/dotfiles.sh -s -c` を実行する
   - `.zshrc_local` がない場合は `packages/zsh/.zsh/` に作成し、`export HOMEBREW_MACHINE_TYPE=personal`（または `work`）を書く
3. `gh auth login` を実行する（Git の認証に gh を使うため）
4. 旧端末で書き出した Raycast の設定を読み込む

## Claude Code の設定

`~/.claude/settings.json` は、`settings.default.json`（共通、git 管理）と `settings.local.json`（端末固有）を合わせて生成する。直接はリンクしない。

- `~/scripts/claude-settings.sh`: 差分を表示する
- `~/scripts/claude-settings.sh --apply`: バックアップを取って書き込む

Claude Code 自身の変更（`/plugin` など）も `settings.json` に書き込まれるため、残したい変更は上の 2 ファイルに反映してから生成し直す。差分の `-` の行は `--apply` で失われる。戻す場合は `settings.json.bak.*` から復元する。

## macOS の設定

`macos-defaults.sh` で管理する。

- `~/scripts/macos-defaults.sh`: 差分を表示する
- `~/scripts/macos-defaults.sh --apply`: 書き込む

設定アプリなどで変えた値は `--apply` で上書きされるため、残したい場合は `macos-defaults.sh` に反映する。
