# TODO

dotfile 化できる設定の候補（2026-10-06 調査）

## 優先度：高

- [ ] Git のグローバル ignore を管理する
  - `~/.config/git/ignore` → `packages/git/.config/git/ignore`
- [ ] VS Code の設定を管理する
  - `~/Library/Application Support/Code/User/settings.json`
  - `~/Library/Application Support/Code/User/keybindings.json`
  - ホーム直下ではないため、`dotfiles.sh` でシンボリックリンクを張る
- [ ] Cursor の設定を管理する
  - `~/Library/Application Support/Cursor/User/settings.json`
  - `~/Library/Application Support/Cursor/User/keybindings.json`
- [ ] VS Code / Cursor の拡張機能リストを管理する
  - `code --list-extensions` / `cursor --list-extensions` の結果を保存し、`dotfiles.sh` でインストールする

## 優先度：中

- [ ] Claude Code の MCP 設定を `dotfiles.sh` で再現する
  - `claude mcp add -s user playwright -- npx -y @playwright/mcp@latest`
  - `~/.claude.json` は状態ファイルが混ざるため丸ごとは管理しない
- [ ] Docker の `~/.docker/daemon.json` を管理する
  - `config.json` は認証情報を含むため対象外
- [ ] macOS の defaults を `dotfiles.sh` に追加する
  - キーリピート、Dock、スクリーンショットの保存先、拡張子の表示など
- [ ] Ghostty / cmux の設定を始めたら `~/.config/ghostty/config` で管理する

## 優先度：低

- [ ] iTerm2 を使い続けるか決め、使うなら custom folder で設定を書き出す
- [ ] Raycast の設定は Settings Export か Cloud Sync で管理する
- [ ] 不要な `~/.bashrc` を削除する
- [ ] Brewfile の `mackup` と dotfiles の役割を整理する

## 管理しないもの

秘密情報を含むため、リポジトリに入れない。

- `~/.aws/config`, `~/.aws/credentials`
- `~/.ssh/`
- `~/.config/gh/hosts.yml`
- `~/.cursor/mcp.json`（`CIRCLECI_TOKEN` を含む）
- `~/.docker/config.json`
