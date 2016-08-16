#!/usr/bin/env bash

##
# Bust the forge cache. Will attempt to bust the
# cache of a file if a filepath is passed in;
# will bust the entire forge cache if no filepath
# is passed in.
#
# Arguments:
#   1. filepath to bust cache for
#
# Returns:
#   None
##
bust_cache () {
    if [[ $# -ne 0 ]]; then
        local filepath=$1
        local cached_file=$(get_cache_key $filepath)

        if [[ -f $FORGE_CACHE/$cached_file ]]; then
            log "Busting cache for $filepath"
            rm -f $FORGE_CACHE/$cached_file
        else
            local has_file=false

            for f in $FORGE_CACHE/*; do
                if cmp --silent $f $filepath; then
                    has_file=true
                    break
                fi
            done

            if [ "$has_file" = true ]; then
                log "Busting cache for $f"
                rm -f $FORGE_CACHE/$f
            else
                error "Aborting: Unable to find cache for $filepath"
            fi
        fi
    else
        log "Busting the Forge cache."
        rm -Rf $FORGE_CACHE
    fi
}

##
# Enforce version control by executing the version control cmd,
# and by caching a copy of the dependencies listing file for
# future reference.
#
# Arguments:
#   1. Dependencies listing file i.e. "package.json"
#   2. Cmd to execute to enforce dependencies are installed on the project i.e. "npm install"
#
# Returns:
#   None
##
enforce_version () {
    local filepath=$1; shift
    $@

    if [[ $? -eq 0 ]]; then
        debug "Caching $filepath"
        cp -f $filepath $FORGE_CACHE/$(get_cache_key $filepath)
    else
        error "Aborting: Unable to cache and execute $@"
        exit 1
    fi
}

##
# Get the cache filename for files forge
# has stored in its .cache directory.
#
# Arguments:
#   1. Absolute filepath
#
# Returns:
#   Cache key of the filepath with forward slashes replaced.
##
get_cache_key () {
    printf "%s" "${1//\//_}"
}

##
# Enforce version control for a package manager in a project.
#
# This function works by caching a copy of the dependencies listing file and comparing
# the cached version to the current version. If the two are identical, the project
# is considered up-to-date and no-opt occurs. If the two are a mismatch, the given
# cmd is executed to update the project, and the cached version of the file is
# overwritten by the current version.
#
# Arguments:
#    1. Dependencies listing file i.e. "package.json"
#    2. Cmd to execute to enforce dependencies are installed on the project i.e. "npm install"
#
# Returns:
#   None
##
version_control () {
    local filepath=$1; shift

    debug "filepath: $filepath"
    debug "cmd: $@"

    # test .cache directory exists
    mkdir -p $FORGE_CACHE

    local filename=${filepath##*/}
    local temp_file=$FORGE_CACHE/$(get_cache_key $filepath)

    debug "filename: $filename"
    debug "temp_file: $temp_file"

    if [ "$PERF" = true ]; then
        log "Starting version_control for $filename"
        local start_time=$(get_time)
    fi

    # does cache exist?
    if [[ -f $temp_file ]]; then
        # are files different?
        if cmp --silent $temp_file $filepath; then
            log "No changes in $filename"
        else
            log "$filename is out-of-date: executing $@"
            enforce_version $filepath $@
        fi
    else
        log "No cache for $filename: executing and caching"
        enforce_version $filepath $@
    fi

    if [ "$PERF" = true ]; then
        local end_time=$(get_time)
        log "version_control for $filename completed in $((end_time-start_time)) ms"
    fi
}
