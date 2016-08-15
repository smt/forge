#!/usr/bin/env bash

##
# Get the forge options
#
# Arguments:
#   1. Cmd line args
#
# Returns:
#   Forge options
##
get_options () {
    local options

    if [[ $# -ne 0 ]]; then
        if [[ ${1:0:1} == "-" ]]; then
            options=$@
        else
            options=${@:2}
        fi
    fi

    echo $options
}

##
# Get the value for a cmd line option
#
# Arguments:
#   1. Option to get the value for
#   2. Cmd line args
#
# Returns:
#   Cmd line option's value
##
get_opt_val () {
    local key=$1; shift
    local val

    for ((i = 1; i <= $#; i++)) ; do
        if [[ ${!i} == $key ]]; then
            i=$((i+1))
            val=${!i}
            if [[ ${val:0:1} == "-" ]]; then
                error "$key is missing a value"
                val=""
                break
            fi
        fi
    done

    echo $val
}

##
# Get the forge task
#
# Arguments:
#   1. Cmd line args
#
# Returns:
#   Forge task name
##
get_task () {
    local task=""

    if [[ $# -ne 0 ]] && [[ ${1:0:1} != "-"  ]]; then
        task=$1
    fi

    echo $task
}

##
# Check to see if a cmd line option is present
#
# Arguments:
#   1. Option to check for
#   2. Cmd line args
#
# Returns:
#   True, if the option is present; false, otherwise.
##
has_opt () {
    local arg=false
    local key=$1

    for ((i = 2; i <= $#; i++)) ; do
        if [[ ${!i} == $key ]]; then
            arg=true
            break
        fi
    done

    echo $arg
}
