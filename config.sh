#!/usr/bin/env bash

#***********************************************#
#
# File:
#   config.sh
#
# Purpose:
#   forge's global config for use within itself
#   and any bash script. All globals are set
#   to readonly where possible to prevent
#   mutation.
#
#***********************************************#

# Paths
readonly PROJECT_ROOT=$(pwd)
readonly FORGE_ROOT=$PROJECT_ROOT/.forge
readonly FORGE_CACHE=$FORGE_ROOT/.cache
readonly FORGE_TASKS=$FORGE_ROOT/tasks

# Colors
readonly BLACK='\033[0;30m'
readonly CYAN='\033[0;34m'
readonly GREEN='\033[0;32m'
readonly NO_COLOR='\033[0m'
readonly PURPLE='\033[0;35m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[0;33m'

# Vars
readonly PROJECT_NAME="Forge"

# Mutables
DEBUG=${DEBUG:-false}       # debug mode
PERF=${PERF:-false}         # performance mode
