#!/usr/bin/env bash

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
# Get a timestamp in milliseconds
#
# Arguments:
#   None
#
# Returns:
#   Current timestamp
##
get_time () {
    if [[ is_mac_os ]]; then
        ruby -e "puts (Time.now.to_f.round(3)*1000).to_i"
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
        t=$(basename $filepath)
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
# Show the usage for a specific task by searching
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
# forge usage
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
