#!/usr/bin/env bash

#***********************************************#
#
# File:
#   utils.sh
#
# Purpose:
#   Contains the forge api
#
#***********************************************#

##
# Tests if a bash command exists
#
# Arguments:
#   1. Command to test
#
# Returns
#   True, if the command exists; false, otherwise.
##
command_exists () {
    command -v $1 >/dev/null 2>&1
}

##
# Proxy debug logger that logs when DEBUG flag is set to true
#
# Arguments:
#   1. String to log
##
debug () {
    if [ "$DEBUG" = true ] ; then
        echo -e "${PURPLE} ~~~ [$PROJECT_NAME DEBUG] ${NO_COLOR}"$1
    fi
}

##
# Proxy error logger
#
# Arguments:
#   1. String to log
##
error () {
    echo -e "${RED} ~~~ [$PROJECT_NAME ERROR] ${NO_COLOR}"$1
}

##
# Prints the current forge version
#
# Arguments:
#   None
##
forge_version () {
    echo "Forge v$(cat $FORGE_PROCESS/.forge-version)"
}

##
# Get a timestamp in milliseconds.
# CAUTION: this function can add overhead,
# especially for MacOS calls. It
# may be better to use the "time" cmd
# and run it against the forge invocation
# i.e. "time forge"
#
# Arguments:
#   None
#
# Returns:
#   Current timestamp
##
get_time () {
    if [[ is_mac_os ]]; then
        # attempt to use the GNU date if coreutils have
        # been installed, otherwise falllback to ruby
        if command_exists gdate; then
            gdate +%s%3N
        else
            ruby -e "puts (Time.now.to_f.round(3)*1000).to_i"
        fi
    else
        date +%s%3N
    fi
}

##
# Is the current OS MacOS?
#
# Arguments:
#   None
#
# Returns:
#   True, if the current OS is MacOS; false, otherwise.
##
is_mac_os () {
    [[ uname == "Darwin" ]]
}

##
# List available forge tasks
#
# Arguments:
#   None
##
list_tasks () {
    echo ""
    echo "    Forge Tasks: "
    echo -e "${GREEN}"
    for filepath in $FORGE_TASKS/*; do
        t=${filepath##*/}
        echo -e "        - $t"
    done
    echo -e "${NO_COLOR}"
}

##
# Proxy logger
#
# Arguments:
#   1. String to log
##
log () {
    echo -e "${CYAN} ~~~ [$PROJECT_NAME] ${NO_COLOR}"$1
}

##
# Run a forge task. Task will be invoked with
# the given cmd line options.
#
# Arguments:
#   1. Task to run
##
run_task () {
    log "Starting $1..."

    if [ "$PERF" = true ]; then
        local start_time=$(get_time)
    fi

    # is this a non-bash script?
    if grep -Rq "/usr/bin/env bash" $FORGE_TASKS/$1; then
        # source to allow forge api to be used
        (source $FORGE_TASKS/$1 $OPTIONS)
    else
        # invoke the task in a sub-shell
        (exec $FORGE_TASKS/$1 $OPTIONS)
    fi

    if [[ $? -eq 0 ]]; then
        if [ "$PERF" = true ]; then
            local end_time=$(get_time)
            log "$1 completed in $((end_time-start_time)) ms"
        else
            log "$1 completed"
        fi
    else
        error "Aborting: Error when running task $1"
        exit 1
    fi
}

##
# Print the usage for a specific task by searching
# for multiline comments with @forge anotations
# and printing the contents between them.
#
# Arguments:
#   1. Task to get usage for
##
task_usage () {
    echo ""
    echo -e "Usage:${GREEN}"
    echo ""
    sed '/@forge/,/@forge/!d;//d' $FORGE_TASKS/$1
    echo -e "${NO_COLOR}"
}

##
# Print forge usage
#
# Arguments:
#   None
##
usage () {
    echo "
        USAGE:
            forge task options

        OPTIONS:
            -d --debug      Enable debug mode
            -h --help       Show help
            -p --perf       Show timestamps
            -t --tasks      List all tasks
            -v --version    List the current forge version

        NOTES:
            The desired task name must be the first arg.
            If no task is given, the default task will be used.

            All options will be passed down to the invoked task.

        EXAMPLES:
            Run default task:
                forge

            List all tasks:
                forge -t

            Run a task:
                forge task

            Get help for a specific task:
                forge task -h
    "
}
