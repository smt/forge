#!/usr/bin/env bash

# parse out task
if [[ $# -eq 0 ]] || [[ ${1:0:1} == "-"  ]]; then
    TASK="default"
else
    TASK=$1; shift
fi

# parse out options
for ((i = 1; i <= $#; i++)) ; do
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
        -t | --tasks)
            list_tasks
            exit
            ;;
        -*) # unknown opt
            ;;
    esac
done

# save global options
if [[ $# -ne 0 ]]; then
    OPTIONS=$@; shift
    debug "Options: $OPTIONS"
fi
