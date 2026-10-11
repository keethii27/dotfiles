# Homebrew の PATH、補完の置き場所、man の場所などをまとめて設定する（Homebrew 公式の方法）
# 補完の置き場所は compinit より前に登録する必要があるため先頭で設定する
eval "$(/opt/homebrew/bin/brew shellenv)"

source ~/.zsh/plugins.zsh

## history
# 保存数を増やす
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
# メモリ上の件数（HISTSIZE）を超える分は保存されないため同じ値にする
export SAVEHIST=100000
# 同時に起動しているzshの間でhistoryを共有する（コマンドを打つたびに保存もされる）
setopt share_history
# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups

## completion
autoload -Uz compinit && compinit
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1
# 補完候補にもシンタックスハイライトが反映される設定
zstyle ':completion:*' verbose yes
# 補完候補一覧をカラー表示
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

## color
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export LESS='-R'

## option
# ファイル種別の記号を補完候補の末尾から非表示
unsetopt list_types
# ビープ音の停止（補完時を含む）
setopt no_beep
# 環境変数を補完
setopt AUTO_PARAM_KEYS

## PATH
export PATH=$PATH:$HOME/scripts

## tools
# starship
eval "$(starship init zsh)"
# zoxide
eval "$(zoxide init zsh --cmd cd)"
# fzf
source /opt/homebrew/opt/fzf/shell/completion.zsh
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

## version managers
# goenv
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
# rbenv
eval "$(rbenv init -)"
# fnm
eval "$(fnm env --use-on-cd)"
# uv
export PATH="$HOME/.local/bin:$PATH"
# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"
# rust
export PATH="$HOME/.cargo/bin:$PATH"

## cloud
# kubectl
source <(kubectl completion zsh)
# gcloud
source /opt/homebrew/share/google-cloud-sdk/path.zsh.inc
source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc

## tab title
# 端末でない環境（スクリプトや Claude Code など）では制御文字が出力に混ざるため、端末のときだけ設定する
if [[ -t 1 ]]; then
    set_tab_title() {
        print -n "\e]0;${PWD:h:t}/${PWD:t}/\a"
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd set_tab_title
    set_tab_title
fi

## sub files
source ~/.zsh/alias.zsh
source ~/.zsh/search.zsh
# local setting
if [[ -e ~/.zsh/.zshrc_local ]]; then
    source ~/.zsh/.zshrc_local
fi
