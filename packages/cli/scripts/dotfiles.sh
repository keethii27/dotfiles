#!/bin/sh

set -e

GIT_CLONE_PATH=~/src/github.com/keethii27
STOW_PACKAGES_PATH="$GIT_CLONE_PATH"/dotfiles/packages

skip_apps=
verbose=
claude_settings=
macos_defaults=
unlink_packages=
for i in "$@"; do
    case "$i" in
        -s|--skip-apps)
            skip_apps=1
            shift ;;
        -v|--verbose)
            verbose=1
            shift ;;
        -c|--claude-settings)
            claude_settings=1
            shift ;;
        -m|--macos-defaults)
            macos_defaults=1
            shift ;;
        -u=*|--unlink=*)
            unlink_packages="${i#*=}"
            shift ;;
        *) ;;
    esac
done

log() {
    message=$1
    echo 📌 "$message"
}

is_file() {
    path="$1"
    [ -f "$path" ]
}

is_dir() {
    path="$1"
    [ -d "$path" ]
}

ensure_dir() {
    path="$1"
    if ! is_dir "$path"; then
        mkdir -p "$path"
    fi
}

if [ -n "$unlink_packages" ]; then
    log 'Unlinking dotfiles...'
    stow -vD -d "$STOW_PACKAGES_PATH" -t ~ "$unlink_packages"
    exit
fi

if [ "$(dscl . -read ~/ UserShell)" = "UserShell: /bin/bash" ]; then
    log 'Change default shell to zsh'
    chsh -s /bin/zsh
fi

if ! is_file /opt/homebrew/bin/brew; then
    log 'Setup Homebrew'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    /opt/homebrew/bin/brew doctor || true
fi

# .zshrc はまだ読み込まれていないため、以降で使うツールの PATH をここで通す
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.goenv/shims:$HOME/.rbenv/shims:$PATH"
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"

ensure_dir "$GIT_CLONE_PATH"

if ! is_dir "$GIT_CLONE_PATH"/dotfiles; then
    log 'Clone dotfiles'
    cd "$GIT_CLONE_PATH"
    git clone https://github.com/keethii27/dotfiles.git
fi

if [ ! "$skip_apps" ]; then
    log 'Install Apps and CLIs'
    brew bundle --file "$GIT_CLONE_PATH"/dotfiles/Brewfile ${verbose:+-v}
fi

log 'Link dotfiles'

# アプリが先に作成した設定ファイルがあると stow が衝突するため退避する
for target in \
    ~/.config/ccstatusline/settings.json \
    ~/.config/git/ignore \
    "$HOME/Library/Application Support/Code/User/settings.json" \
    "$HOME/Library/Application Support/Code/User/keybindings.json"; do
    if is_file "$target" && [ ! -L "$target" ]; then
        log "Backup $target"
        mv "$target" "$target.bak"
    fi
done

# --no-folding: ディレクトリごとリンクすると、アプリが書き込むファイルがリポジトリに入るため
# shellcheck disable=SC2046
stow -v --no-folding -d "$STOW_PACKAGES_PATH" -t ~ $(ls $STOW_PACKAGES_PATH)

# Claude Code 自身が書き込んだ変更を上書きしないよう、既存の端末ではオプション指定時のみ生成する
if [ "$claude_settings" ] || ! is_file ~/.claude/settings.json; then
    log 'Generate Claude Code settings'
    "$STOW_PACKAGES_PATH"/cli/scripts/claude-settings.sh
fi

log 'Install Cargo packages'
cargo install tree-sitter-cli

log 'Setup Go'
latest_go=$(goenv install -l | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
goenv install -s "$latest_go"
goenv global "$latest_go"

log 'Setup Ruby'
latest_ruby=$(rbenv install -l | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
rbenv install -s "$latest_ruby"
rbenv global "$latest_ruby"

log 'Setup Node'
fnm install --lts
fnm default lts-latest

log 'Install Claude Code statusline'
fnm exec --using=default npm install -g ccstatusline@latest

log 'Install Playwright CLI'
fnm exec --using=default npm install -g @playwright/cli@latest
fnm exec --using=default playwright-cli install --skills --global
# Playwright は IPv6 を優先して接続するため、IPv6 の通信が途中で止まるネットワーク（会社のセキュリティソフトなど）では
# ダウンロードがタイムアウトする。IPv4 を優先させて回避する
NODE_OPTIONS=--dns-result-order=ipv4first fnm exec --using=default playwright-cli install-browser webkit

log 'Install LSP servers'
pnpm add -g typescript-language-server typescript
go install golang.org/x/tools/gopls@latest
gem install ruby-lsp

log 'Configuring macOS default settings'
# 設定アプリなどで変えた値を上書きしないよう、オプション指定時のみ書き込む。指定がなければ差分を表示する
"$STOW_PACKAGES_PATH"/cli/scripts/macos-defaults.sh ${macos_defaults:+--apply}

log 'Finish!!'
