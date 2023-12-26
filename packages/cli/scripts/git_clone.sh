#!/bin/sh

set -e

GIT_CLONE_PATH=~/src/github.com/keethii27
REPOSITORIES='docker_tmp go_chat go_mosaic_app go_playground go_study_api gopherdojo-studyroom minna_no_go_gengo'
LENGTH=$(echo "$REPOSITORIES" | tr ' ' '\n' | wc -l)

for i in $(seq "$LENGTH")
do
    repository=$(echo "$REPOSITORIES" | cut -d ' ' -f "$i")
    if [ ! -d "$GIT_CLONE_PATH"/"$repository" ]; then
        echo git clone keethii27/"$repository"
        cd "$GIT_CLONE_PATH"
        git clone https://keethii27@github.com/keethii27/"$repository".git
    fi
done

ghq get github.com/Jimeux/go-samples
ghq get github.com/gohandson/accountbook-ja
ghq get github.com/gohandson/gacha-ja
ghq get github.com/gohandson/goroutine-ja
ghq get github.com/gohandson/testing-ja
ghq get github.com/reireias/dotfiles
ghq get github.com/sasa-nori/nyaitter
ghq get github.com/tenntenn/gohandson
