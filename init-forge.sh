#!/usr/bin/env bash

#***********************************************#
#
# File:
#   init-forge.sh
#
# Purpose:
#  Initialize forge in a project
#
#***********************************************#

##
# Initialize forge in a project. This is done by
# running "forge install". This cmd is checked for
# before the rest of the forge app is initialized,
# and will terminate the app once a project is
# initialized with forge.
#
# Arguments:
#   None
#
# Returns:
#   None
##
init_forge () {
    if [[ $1 == "install" ]]; then
        echo -e "\033[0;34m ~~~ [Forge]\033[0m Installing..."
        mkdir -p .forge
        cp -Rn $FORGE_PROCESS/tasks .forge
        echo -e "\033[0;34m ~~~ [Forge]\033[0m Project Setup Complete"
        exit
    fi
}

init_forge $@
