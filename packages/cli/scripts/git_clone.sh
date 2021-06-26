#!/bin/sh

set -e

GIT_CLONE_PATH=~/src/github.com/edm20627
repositories=(docker_tmp go_chat go_mosaic_app go_playground go_study_api gopherdojo-studyroom minna_no_go_gengo)

for repository in ${repositories[@]}
do
    if [ ! -d "$GIT_CLONE_PATH"/"$repository" ]; then
        echo git clone edm20627/"$repository"
        cd "$GIT_CLONE_PATH"
        git clone https://github.com/edm20627/"$repository".git
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
