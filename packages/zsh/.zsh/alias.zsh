# ls
alias ls="lsd"
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
alias g='grep --color=auto'
alias grep='grep --color=auto'

alias pr="gh pr view --web"
alias fzf='fzf --preview "head -100 {}"'

# kubectl
alias k="kubectl"
