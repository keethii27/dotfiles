#!/bin/sh

set -e

DOTFILES_PATH=~/src/github.com/keethii27/dotfiles
STOW_PACKAGES_PATH="$DOTFILES_PATH"/packages

skip_brew=
apply_claude_settings=
apply_macos_defaults=
unlink_packages=
while [ $# -gt 0 ]; do
    case "$1" in
        -s|--skip-brew)
            skip_brew=1 ;;
        -c|--claude-settings)
            apply_claude_settings=1 ;;
        -m|--macos-defaults)
            apply_macos_defaults=1 ;;
        # 複数指定できる（-u zsh -u git）
        -u|--unlink)
            unlink_packages="$unlink_packages $2"
            shift ;;
        *) ;;
    esac
    shift
done

log() {
    echo "📌 $1"
}

is_file() {
    path="$1"
    [ -f "$path" ]
}

is_dir() {
    path="$1"
    [ -d "$path" ]
}

if [ -n "$unlink_packages" ]; then
    log 'Unlink dotfiles'
    for package in $unlink_packages; do
        stow -vD -d "$STOW_PACKAGES_PATH" -t ~ "$package"
    done
    exit
fi

if ! is_file /opt/homebrew/bin/brew; then
    log 'Set up Homebrew'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# .zshrc はまだ読み込まれていないため、以降で使うツールの PATH をここで通す
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.goenv/shims:$HOME/.rbenv/shims:$PATH"
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"

if ! is_dir "$DOTFILES_PATH"; then
    log 'Clone dotfiles'
    git clone https://github.com/keethii27/dotfiles.git "$DOTFILES_PATH"
fi

if [ ! "$skip_brew" ]; then
    log 'Install Homebrew packages'
    brew bundle --file "$DOTFILES_PATH"/Brewfile
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
for package in "$STOW_PACKAGES_PATH"/*/; do
    stow -v --no-folding -d "$STOW_PACKAGES_PATH" -t ~ "$(basename "$package")"
done

log 'Configure Claude Code settings'
# Claude Code 自身が書き込んだ変更を上書きしないよう、オプション指定時のみ書き込む。指定がなければ差分を表示する
# 新しく作る場合は失う設定がないため、オプションがなくても書き込む
if ! is_file ~/.claude/settings.json; then
    apply_claude_settings=1
fi
"$STOW_PACKAGES_PATH"/scripts/scripts/claude-settings.sh ${apply_claude_settings:+--apply}

log 'Set up Go'
# goenv が Go のインストール時にツールを自動で入れると GOPATH と GOROOT が同じという警告が出るため止める。ツールは Brewfile で入れる
goenv tools default-tools disable
# 最新の安定版を、未インストールの場合はインストールしてから既定の版にする。スクリプトからは確認できないため --yes を付ける
goenv use --global --yes

log 'Set up Ruby'
latest_ruby=$(rbenv install -l | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
rbenv install -s "$latest_ruby"
rbenv global "$latest_ruby"

log 'Set up Node'
latest_node=$(fnm ls-remote --lts --latest | awk '{print $1}')
# インストール済みの版を fnm install すると警告が出るため、未インストールの場合のみ入れる
fnm ls | grep -qw "$latest_node" || fnm install "$latest_node"
fnm default "$latest_node"

log 'Install Claude Code statusline'
fnm exec --using=default npm install -g ccstatusline@latest

log 'Install Playwright CLI'
fnm exec --using=default npm install -g @playwright/cli@latest
fnm exec --using=default playwright-cli install --skills --global
# Playwright は IPv6 を優先して接続するため、IPv6 の通信が途中で止まるネットワーク（会社のセキュリティソフトなど）では
# ダウンロードがタイムアウトする。IPv4 を優先させて回避する
NODE_OPTIONS=--dns-result-order=ipv4first fnm exec --using=default playwright-cli install-browser webkit

log 'Install language tools'
pnpm add -g typescript-language-server typescript
gem install ruby-lsp

log 'Configure macOS default settings'
# 設定アプリなどで変えた値を上書きしないよう、オプション指定時のみ書き込む。指定がなければ差分を表示する
"$STOW_PACKAGES_PATH"/scripts/scripts/macos-defaults.sh ${apply_macos_defaults:+--apply}

log 'Finish'
