#!/usr/bin/env bash

find_project () {
    while [[ ! -d $(pwd)/.forge ]] && [[ $(pwd) != $HOME ]]; do
        cd ..
    done

    if [[ $(pwd) == $HOME ]]; then
        echo -e "\033[0;31m ~~~ [FORGE ERROR] Unable to find .forge directory. Terminating...\033[0m"
        exit 1
    fi
}

find_project $@
