#!/usr/bin/env bash

##
# Proxy debug logger that logs when DEBUG flag is set to true
#
# Arguments:
#   1. String to log
#
# Returns:
#   None
##
debug () {
    local colorless='\033[0m'
    local purple='\033[0;35m'

    if [ "$DEBUG" = true ]; then
        echo -e "${purple} ~~~ [FORGE DEBUG] ${colorless}$1"
    fi
}

##
# Throw an error. Acts as a proxy logger
# and will terminate the script
#
# Arguments:
#   1. String to log
#   2. Error exit code (Defaults to 1)
#
# Returns:
#   None
##
error () {
    local code=${2:-1}
    local colorless='\033[0m'
    local red='\033[0;31m'

    echo -e "${red} ~~~ [FORGE ERROR] ${colorless}$1"
    exit $code
}


##
# Proxy logger
#
# Arguments:
#   1. String to log
#
# Returns:
#   None
##
log () {
    local cyan='\033[0;34m'
    local colorless='\033[0m'

    echo -e "${cyan} ~~~ [FORGE] ${colorless}$1"
}
