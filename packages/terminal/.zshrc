# inport plugin {{{
source ~/.zsh/plugins.zsh
# }}}

# history {{{
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
# }}}

# completion {{{
autoload -Uz compinit && compinit
# ## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1
# }}}

# cdr {{{
# 開いたディレクトリの履歴からディレクトリを開く
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-max 1000
zstyle ':chpwd:*' recent-dirs-file ~/.cache/chpwd-recent-dirs
# }}}

# color {{{
# export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# 補完候補にもシンタックスハイライトが反映される設定
# verboseスタイルにyes
zstyle ':completion:*' verbose yes
# 補完候補一覧をカラー表示
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-colors ""

# less
export LESS='-R'

# man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# }}}

# option {{{
# ファイル種別の記号を補完候補の末尾から非表示
unsetopt list_types
# ビープ音の停止
setopt no_beep
# ビープ音の停止(補完時)
setopt nolistbeep
# 環境変数を補完
setopt AUTO_PARAM_KEYS
# }}}

# asdf
if [[ -f $(brew --prefix asdf)/asdf.sh ]]; then
    . "$(brew --prefix asdf)"/asdf.sh
fi
# }}}

# FZF {{{
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
fi
# }}}

# pronpt {{{
# starship
eval "$(starship init zsh)"

# タブにカレントディレクトリを表示
# ログイン時
echo -ne "\033]0;$(pwd | rev | awk -F "/" '{print "/"$1"/"$2}'| rev)\007"
# ディレクトリが変わった時
function chpwd() {
    echo -ne "\033]0;$(pwd | rev | awk -F "/" '{print "/"$1"/"$2}'| rev)\007"
    }
# }}}

# other {{{
# script
export PATH=$PATH:$HOME/scripts

# tmux script
export PATH=$PATH:$HOME/.tmux/bin

# my git repository
export GIT_CLONE_PATH="$HOME"/src/github.com/edm20627

# neovim
export XDG_CONFIG_HOME=~/.config

# golang
GOROOT="$(go env GOROOT)"
export GOROOT
GOPATH=$(go env GOPATH)
export GOPATH
export PATH=$PATH:$GOPATH/bin

# function {{{
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
# }}}

# sub files {{{
# alias
source ~/.zsh/alias.zsh
# completion
source ~/.zsh/completion.zsh
# fzf
source ~/.zsh/search.zsh
# local setting
if [[ -e ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi
# }}}
