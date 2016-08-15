#!/usr/bin/env bash

source find-project-utils.sh
source general-utils.sh
source log-utils.sh
source parse-cmd-utils.sh
source usage-utils.sh
source version-control-utils.sh

if [ "$(has_opt "-v" $@)" = "true" ] || [ "$(has_opt "--version" $@)" = "true" ]; then
    forge_version $forge_process
fi
