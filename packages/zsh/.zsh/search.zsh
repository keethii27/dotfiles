export FZF_DEFAULT_COMMAND="rg --files --hidden -l --glob '!**/.git/*' --glob '!**/node_modules/*'"
export FZF_DEFAULT_OPTS="-m --height 50% --reverse --ansi"

function is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

# Ctrl + G = ghq list
function fzf-ghq-look () {
    local selected_dir
    selected_dir=$(ghq list | fzf --preview=)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd $(ghq root)/$selected_dir"
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

# fzf + git switch
function fgs {
    local branches branch
    branches=$(git --no-pager branch -vv --color=always) &&
    branch=$(echo "$branches" | fzf --preview=) &&
    # 行頭の記号（今のブランチの *、別の作業ツリーで使っているブランチの +）を除いてからブランチ名を取り出す
    git switch "$(echo "$branch" | sed 's/^[*+ ]*//' | awk '{print $1}')"
}
