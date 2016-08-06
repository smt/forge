#!/usr/bin/env bash

#***********************************************#
#
# File:
#   find-project.sh
#
# Purpose:
#   Finds the nearest directory with forge
#   installed. This works by starting in the
#   current directory and cd-ing up the file
#   structure until the $HOME directory is hit;
#   at which point the script terminates, being
#   unable to find a forge install.
#
#***********************************************#

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
