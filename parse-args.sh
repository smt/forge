#!/usr/bin/env bash

parse_args () {
    if [[ $# -eq 0 ]] || [[ ${1:0:1} == "-"  ]]; then
        readonly TASK="default"
    else
        readonly TASK=$1; shift
    fi

    for ((i = 1; i <= $#; i++)) ; do
        case ${!i} in
            -d | --debug)
                readonly DEBUG=true
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
        readonly OPTIONS=$@; shift
        debug "Options: $OPTIONS"
    fi
}

parse_args $@
