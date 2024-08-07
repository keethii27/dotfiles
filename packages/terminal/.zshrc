# inport plugin
source ~/.zsh/plugins.zsh

# history
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

# completion
autoload -Uz compinit && compinit
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1

# cdr
# 開いたディレクトリの履歴からディレクトリを開く
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-max 1000
zstyle ':chpwd:*' recent-dirs-file ~/.cache/chpwd-recent-dirs

# color
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# 補完候補にもシンタックスハイライトが反映される設定
# verboseスタイルにyes
zstyle ':completion:*' verbose yes
# 補完候補一覧をカラー表示
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# less
export LESS='-R'
# man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# option
# ファイル種別の記号を補完候補の末尾から非表示
unsetopt list_types
# ビープ音の停止
setopt no_beep
# ビープ音の停止(補完時)
setopt nolistbeep
# 環境変数を補完
setopt AUTO_PARAM_KEYS

# FZF
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
fi

# pronpt
# homebrew
export PATH=/opt/homebrew/bin:$PATH
# starship
eval "$(starship init zsh)"
# タブにカレントディレクトリを表示
# ログイン時
echo -ne "\033]0;$(pwd | rev | awk -F "/" '{print "/"$1"/"$2}'| rev)\007"
# ディレクトリが変わった時
function chpwd() {
    echo -ne "\033]0;$(pwd | rev | awk -F "/" '{print "/"$1"/"$2}'| rev)\007"
}

# other
# script
export PATH=$PATH:$HOME/scripts
# my git repository
export GIT_CLONE_PATH="$HOME"/src/github.com/keethii27
# neovim
export XDG_CONFIG_HOME=~/.config
# # openssl
# export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# # golang
# GOROOT="$(go env GOROOT)"
# export GOROOT
# GOPATH=$(go env GOPATH)
# export GOPATH
# export PATH=$PATH:$GOPATH/bin
# # goenv
export GOENV_ROOT=$HOME/.goenv
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
# rbenv
eval "$(rbenv init -)"
# # ndenv
# export PATH=$PATH:$HOME/.ndenv/bin
# eval "$(ndenv init -)"
# # volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
# kubectl
source <(kubectl completion zsh)
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
# gcloud
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# function
# PRをブラウザで開く
function pr-open {
    local url
    url=$(hub pr list -h "$(git symbolic-ref --short HEAD)" -f "%U")
    if [[ -z $url ]]; then
        echo "The PR based this branch not found."
        return 1
    fi
    open "$url"
}

# sub files
# alias
source ~/.zsh/alias.zsh
# fzf
source ~/.zsh/search.zsh
# local setting
if [[ -e ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi
