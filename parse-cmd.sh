#!/usr/bin/env bash

#***********************************************#
#
# File:
#   parse-cmd.sh
#
# Purpose:
#   Parses the forge cmd for the task name
#   and options
#
#***********************************************#

##
# Parse the cmd line for the forge task and options
#
# Arguments:
#   Cmd line args
#
# Returns:
#   None
##
parse_cmd () {
    if [[ $# -eq 0 ]] || [[ ${1:0:1} == "-"  ]]; then
        readonly TASK="default"
    else
        readonly TASK=$1; shift
    fi

    for ((i = 1; i <= $#; i++)); do
        case ${!i} in
            -d | --debug)
                DEBUG=true
                ;;
            -h | --help)
                if [[ $TASK == "default" ]]; then
                    usage
                else
                    task_usage $TASK
                fi
                exit
                ;;
            -p | --perf)
                PERF=true
                ;;
            -t | --tasks)
                list_tasks
                exit
                ;;
            -v | --version)
                forge_version
                exit
                ;;
            -*) # unknown opt
                ;;
        esac
    done

    # save global options
    if [[ $# -ne 0 ]]; then
        readonly OPTIONS=$@; shift
        debug "Options: $OPTIONS"
    fi
}

parse_cmd $@
