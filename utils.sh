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
    log "Starting $1"

    # is this a non-bash script?
    if grep -Rq "/usr/bin/env bash" $FORGE_TASKS/$1; then
        # source to allow forge api to be used
        (source $FORGE_TASKS/$1 $OPTIONS)
    else
        # invoke the task in a sub-shell
        (exec $FORGE_TASKS/$1 $OPTIONS)
    fi

    if [ $? -eq 0 ]; then
        log "$1 Completed"
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
    echo ""
    echo "Usage:"
    echo -e "${GREEN}"
    echo -e "    $0 [task] [-d]"
    echo -e "    -d --debug     Enable debug mode"
    echo -e "    -h --help      Show help"
    echo -e "    -t --tasks     List all tasks"
    echo -e "${NO_COLOR}"
    echo "The desired task name must be the first arg."
    echo "If no task is given, the default task will be used."
    echo ""
    echo "All options will be passed down to the invoked task."
    echo ""
}
