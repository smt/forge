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
    if [ "$DEBUG" = true ]; then
        printf "\e\033[0;35m ~~~ [FORGE DEBUG]\e\033[0m %s\n" "$1"
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

    printf "\e\033[0;31m ~~~ [FORGE ERROR]\e\033[0m %s\n" "$1"
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
    printf "\e\033[0;34m ~~~ [FORGE]\033[0m %s\n" "$1"
}
