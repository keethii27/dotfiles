#!/bin/sh

set -e

GIT_CLONE_PATH=~/src/github.com/keethii27
STOW_PACKAGES_PATH="$GIT_CLONE_PATH"/dotfiles/packages

skip_apps=
verbose=
gem=
unlink_packages=
for i in "$@"; do
    case "$i" in
        -s|--skip-apps)
            skip_apps=1
            shift ;;
        -v|--verbose)
            verbose=1
            shift ;;
        -g|--gem)
            gem=1
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

# if ! is_file /usr/local/bin/brew; then
# M1から変更になった？
if ! is_file /opt/homebrew/bin/brew; then
    log 'Setup Homebrew'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew doctor

    # chmod 755 /usr/local/share/zsh/site-functions
    # chmod 755 /usr/local/share/zsh
    # chmod 755 /usr/local/bin
fi

ensure_dir "$GIT_CLONE_PATH"

if ! is_dir "$GIT_CLONE_PATH"/dotfiles; then
    log 'Clone dotfiles'
    cd "$GIT_CLONE_PATH"
    git clone https://github.com/keethii27/dotfiles.git
fi

if [ ! "$skip_apps" ]; then
    log 'Install Apps and CLIs'
    brew bundle --file "$GIT_CLONE_PATH"/dotfiles/Brewfile "$([ -n "$verbose" ] && echo -v)"
fi

log 'Link dotfiles'
ensure_dir ~/.config/alacritty

# shellcheck disable=SC2046
stow -vd "$STOW_PACKAGES_PATH" -t ~ $(ls $STOW_PACKAGES_PATH)

awk '{print $1}' ~/.tool-versions | while IFS= read -r plugin; do
    if ! is_dir ~/.asdf/plugins/"$plugin"; then
        asdf plugin add "$plugin"
    fi
done

is_runtime_versions_changed () {
    plugin="$1"
    specified=$(grep "$plugin" ~/.tool-versions | awk '{$1=""; print $0}')
    installed=$(asdf list "$plugin" 2>&1)

    is_changed=
    for version in $specified; do
        match=$(echo "$installed" | grep "$version")
        [ -z "$match" ] && is_changed=1
    done

    [ "$is_changed" ]
}

for plugin in $(asdf plugin list); do
    if is_runtime_versions_changed "$plugin"; then
        if [ "$plugin" = nodejs ]; then log "Import release team keyring for Node.JS"
            # 不要？
            # bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
        fi

        log "Install runtime: $plugin"
        # ruby 2.6.3 の場合は下記コマンド
        RUBY_CFLAGS=-DUSE_FFI_CLOSURE_ALLOC asdf install ruby
        asdf install "$plugin"
    fi
done

gemfile_path=~/Gemfile
if is_file "$gemfile_path" && [ ! "$gem" ]; then
log 'Install gem'
~/.asdf/shims/gem install bundler
~/.asdf/shims/bundle install
fi

dein_cache_path=~/.cache/dein
if ! is_dir "$dein_cache_path"; then
log 'Setup dein.vim'
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm installer.sh

log 'Install neovim setup'
pip3 install --upgrade pip
pip3 install --user pynvim
# ~/.asdf/shims/gem install neovim # bundle installで実行済み
npm install -g neovim
fi

log 'Configuring macOS default settings'
# 隠しファイルを表示する
defaults write com.apple.finder AppleShowAllFiles -boolean true
# 共有フォルダで .DS_Store ファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

log 'Finish!!'
