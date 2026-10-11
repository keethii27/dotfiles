#!/bin/sh

# macOS の設定（defaults）を確認・反映する
# オプションなし: 現在の値との差分を表示するだけで、変更しない
# -a, --apply:   差分のある設定を書き込む

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

changed=

to_bool() {
    case "$1" in
        true|1) echo 1 ;;
        false|0) echo 0 ;;
        *) echo "$1" ;;
    esac
}

# 使い方: setting <domain> <key> <type> <value>
# type は defaults write の型（bool, int, float, string）
setting() {
    domain=$1
    key=$2
    type=$3
    value=$4

    current=$(defaults read "$domain" "$key" 2>/dev/null || echo '(unset)')
    # defaults read は bool を 1 / 0 で返す。文字列の true / false で保存されている場合もあるため、比較用にそろえる
    expected=$value
    if [ "$type" = bool ]; then
        expected=$(to_bool "$value")
        current=$(to_bool "$current")
    fi

    if [ "$current" = "$expected" ]; then
        return
    fi

    echo "$domain $key: $current -> $expected"
    changed=1
    if [ "$apply" ]; then
        defaults write "$domain" "$key" "-$type" "$value"
    fi
}

# キーボード
setting -g KeyRepeat int 2
setting -g InitialKeyRepeat int 15
# F1〜F12 を標準のファンクションキーとして使う
setting -g com.apple.keyboard.fnState bool true

# 文字入力の自動修正・自動変換を無効にする
setting -g NSAutomaticSpellingCorrectionEnabled bool false
setting -g NSAutomaticCapitalizationEnabled bool false
setting -g NSAutomaticPeriodSubstitutionEnabled bool false
setting -g NSAutomaticQuoteSubstitutionEnabled bool false
setting -g NSAutomaticDashSubstitutionEnabled bool false

# トラックパッド
setting com.apple.AppleMultitouchTrackpad Clicking bool true
setting com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking bool true
setting com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag bool true
setting com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag bool true
setting -g com.apple.trackpad.scaling float 3

# 外観
setting -g AppleInterfaceStyle string Dark
setting -g AppleShowAllExtensions bool true

# Dock
setting com.apple.dock autohide bool true
setting com.apple.dock tilesize int 69

# スクリーンショット
# スクリーンショットアプリで保存先を選ぶと ~ 始まりで保存されるため、同じ形にそろえる
# shellcheck disable=SC2088
setting com.apple.screencapture location string '~/Documents/screenshots'
setting com.apple.screencapture show-thumbnail bool false

# Finder
setting com.apple.finder AppleShowAllFiles bool true
setting com.apple.finder ShowPathbar bool true
setting com.apple.finder ShowStatusBar bool true
# リスト表示
setting com.apple.finder FXPreferredViewStyle string Nlsv
# 新しいウィンドウで書類フォルダを開く
setting com.apple.finder NewWindowTarget string PfDo

# 共有フォルダで .DS_Store ファイルを作成しない
setting com.apple.desktopservices DSDontWriteNetworkStores bool true

# メニューバーの時計に秒を表示する
setting com.apple.menuextra.clock ShowSeconds bool true

if [ ! "$changed" ]; then
    echo 'No changes'
    exit 0
fi

if [ ! "$apply" ]; then
    echo 'Run with --apply to write these settings'
    exit 0
fi

mkdir -p "$HOME/Documents/screenshots"
# Dock・Finder・メニューバーの設定を反映する。キーボードなどはログインし直すと反映される
killall Dock Finder SystemUIServer 2>/dev/null || true
echo 'Applied. Some settings take effect after logging in again'
