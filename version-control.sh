#!/usr/bin/env bash

#***********************************************#
#
# File:
#   version-control.sh
#
# Purpose:
#   forge's version-control api for a project
#
#***********************************************#

##
# Enforce version control for a package manager in a project.
#
# Arguments:
#    1. Dependencies listing file i.e. "package.json"
#    2. Cmd to execute to enforce dependencies are installed on the project i.e. "npm install"
#
# Function works by caching a copy of the dependencies listing file and comparing
# the cached version to the current version. If the two are identical, the project
# is considered up-to-date and no-opt occurs. If the two are a mismatch, the given
# cmd is executed to update the project, and the cached version of the file is
# overwritten by the current version.
##
version_control () {
    local filepath=$1; shift

    debug "filepath: $filepath"
    debug "cmd: $@"

    # test .cache directory exists
    mkdir -p $FORGE_CACHE

    local filename=${filepath##*/}
    local temp_file=$FORGE_CACHE/$filename

    debug "filename: $filename"
    debug "temp_file: $temp_file"

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
}

##
# Enforce version control by executing the version control cmd,
# and by caching a copy of the dependencies listing file for
# future reference.
#
# Arguments:
#   1. Dependencies listing file i.e. "package.json"
#   2. Cmd to execute to enforce dependencies are installed on the project i.e. "npm install"
##
enforce_version () {
    local filepath=$1; shift
    $@

    if [[ $? -eq 0 ]]; then
        debug "Caching $filepath"
        cp -f $filepath $FORGE_CACHE
    else
        error "Aborting: Unable to cache and execute $@"
        exit 1
    fi
}
