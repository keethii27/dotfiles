### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

## コマンド補完強化
zinit ice wait'0' lucid; zinit light zsh-users/zsh-completions

## コマンドライン自体の色付け
zinit ice wait'0' lucid; zinit light zsh-users/zsh-syntax-highlighting

## 履歴補完
zinit light zsh-users/zsh-autosuggestions

## 既存の cd をオーバライドして強化したコマンド
# osをアップグレードしてうまくうごかなくなったのでコメントアウト
# zinit light b4b4r07/enhancd
# export ENHANCD_FILTER=fzf
# export ENHANCD_ENABLE_DOUBLE_DOT=false
# export ENHANCD_ENABLE_SINGLE_DOT=false
# export ENHANCD_ENABLE_HOME=false
