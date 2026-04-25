source ~/.zsh/plugins.zsh

## history
# 保存数を増やす
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=1000000
# コマンドが入力されるとすぐに追加
setopt inc_append_history
# 同時に起動しているzshの間でhistoryを共有する
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
# ビープ音の停止
setopt no_beep
# ビープ音の停止(補完時)
setopt nolistbeep
# 環境変数を補完
setopt AUTO_PARAM_KEYS

## PATH
export PATH=/opt/homebrew/bin:$PATH
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
export GOENV_ROOT=$HOME/.goenv
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
# rbenv
eval "$(rbenv init -)"
# fnm
export PATH="$HOME/.fnm:$PATH"
eval "$(fnm env --use-on-cd)"
# uv
export PATH="$HOME/.local/bin:$PATH"
# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# rust
export PATH="$HOME/.cargo/bin:$PATH"

## cloud
# kubectl
source <(kubectl completion zsh)
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
# gcloud
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

## tab title
# ログイン時
echo -ne "\033]0;$(pwd | rev | awk -F "/" '{print "/"$1"/"$2}'| rev)\007"
# ディレクトリが変わった時
function chpwd() {
    echo -ne "\033]0;$(pwd | rev | awk -F "/" '{print "/"$1"/"$2}'| rev)\007"
}

## sub files
source ~/.zsh/alias.zsh
source ~/.zsh/search.zsh
# local setting
if [[ -e ~/.zsh/.zshrc_local ]]; then
    source ~/.zsh/.zshrc_local
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
