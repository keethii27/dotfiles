export FZF_DEFAULT_COMMAND="rg --files --hidden -l --glob '!**/.git/*' --glob '!**/node_modules/*'"
export FZF_DEFAULT_OPTS="-m --height 50% --reverse --ansi"

function is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

# Ctrl + R = history search
function fzf-history-selection() {
    BUFFER=$(history -n 1 | tac  | awk '!a[$0]++' | fzf --no-sort --preview=)
    # shellcheck disable=SC2034
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-history-selection
bindkey '^R' fzf-history-selection

# Ctrl + G = ghq list
function fzf-ghq-look () {
    local selected_dir
    selected_dir=$(ghq list | fzf --preview=)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd $(ghq list --full-path | grep --color=never -E "/$selected_dir$")"
        zle accept-line
    fi
}
zle -N fzf-ghq-look
bindkey '^G' fzf-ghq-look

# Ctrl + F = find and vim
function fzf-find () {
    local selected
    if is_in_git_repo; then
        selected=$(git ls-files | fzf)
    else
        selected=$(eval "$FZF_DEFAULT_COMMAND" | fzf)
    fi
    if [ -n "$selected" ]; then
        BUFFER="vi ${selected}"
        zle accept-line
    fi
}
zle -N fzf-find
bindkey '^F' fzf-find

# Ctrl + E = cdr
function fzf-cdr (){
    local selected_dir
    # shellcheck disable=SC2016
    selected_dir=$(cdr -l | awk '{ print $2 }' | fzf --preview 'f() { sh -c "ls -hFGla $1" }; f {}')
    if [ -n "$selected_dir" ]; then
        # shellcheck disable=SC2034
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N fzf-cdr
bindkey '^E' fzf-cdr

# fzf + git switch
function fgs {
  local branches branch
  branches=$(git --no-pager branch -vv --color=always) &&
  branch=$(echo "$branches" | fzf --preview=) &&
  git switch "$(echo "$branch" | awk '{print $1}' | sed "s/.* //")"
}
