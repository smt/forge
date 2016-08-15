#!/usr/bin/env bash

##
# Finds the nearest directory with forge
# installed. This works by starting in the
# current directory and cd-ing up the file
# structure until the root directory is hit
# or a forge project is found.
#
# Arguments:
#   None
#
# Returns:
#   Forge project directory or root directory if no forge project is found
##
find_project () {
    local start_dir=$(pwd)

    while [[ ! -d $(pwd)/forge ]] && [[ $(pwd) != "/" ]]; do
        cd ..
    done

    local project_dir=$(pwd)

    cd $start_dir

    echo $project_dir
}
