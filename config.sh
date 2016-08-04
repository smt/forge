#!/usr/bin/env bash

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
readonly DEBUG=false
readonly PROJECT_NAME="Forge"
