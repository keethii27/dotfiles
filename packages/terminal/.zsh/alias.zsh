# ls
alias ls="exa"
alias ll="ls -la --git"
alias lt="ll -TL 3 --ignore-glob=.git"

# cd
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'

# vim
alias vi="nvim"

# grep
alias g='grep --color=always'
alias grep='grep --color=always'
alias rgrep='grep --include="*.rb"'
alias ggrep='grep --include="*.go"'
alias fgrep='find ./ | grep'

alias cat="bat"
alias lscmd="ls ~/scripts"
alias pr="gh pr view --web"
alias fzf='fzf --preview "bat --color=always --style=header,grid --line-range :100 {}"'

# script
alias cdrepo=". cdrepo"
