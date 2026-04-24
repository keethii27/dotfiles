#!/bin/sh

set -e

GIT_CLONE_PATH=~/src/github.com/keethii27
STOW_PACKAGES_PATH="$GIT_CLONE_PATH"/dotfiles/packages

skip_apps=
verbose=
unlink_packages=
for i in "$@"; do
    case "$i" in
        -s|--skip-apps)
            skip_apps=1
            shift ;;
        -v|--verbose)
            verbose=1
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
    brew doctor
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

# shellcheck disable=SC2046
stow -vd "$STOW_PACKAGES_PATH" -t ~ $(ls $STOW_PACKAGES_PATH)

dein_cache_path=~/.cache/dein
if ! is_dir "$dein_cache_path"; then
    log 'Setup dein.vim'
    curl https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh > installer.sh
    sh ./installer.sh
    rm installer.sh

    log 'Install neovim setup'
    # pip3 install --upgrade pip
    # pip3 install --user pynvim
    # ~/.asdf/shims/gem install neovim # bundle installで実行済み
    # npm install -g neovim
fi

log 'Configuring macOS default settings'
# 隠しファイルを表示する
defaults write com.apple.finder AppleShowAllFiles true
# 共有フォルダで .DS_Store ファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

log 'Finish!!'
