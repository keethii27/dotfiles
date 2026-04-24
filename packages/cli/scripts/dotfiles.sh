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

log 'Install Cargo packages'
cargo install tree-sitter-cli

log 'Configuring macOS default settings'
# 隠しファイルを表示する
defaults write com.apple.finder AppleShowAllFiles true
# 共有フォルダで .DS_Store ファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

log 'Finish!!'
