#!/bin/sh

repo_alias=$1

repo_name=
case "$repo_alias" in
    dotfiles)
        repo_name=dotfiles
        ;;
    xxx)
        repo_name=xxx
        ;;
    *)
        repo_name=$1
        ;;
esac

cd "$GIT_CLONE_PATH/$repo_name" || {
    echo "moving to $GIT_CLONE_PATH instead"
    cd "$GIT_CLONE_PATH" || exit
}
echo "💻 Happy coding!"
