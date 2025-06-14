#!/bin/bash

#------------------------------------------------------------------------
# USAGE:
# cd /tf/avm/scripts/bin # ** must run from this directory
# ./generate_config.sh
#------------------------------------------------------------------------


WORKING_DIR="/tf/avm"

# goto working directory
cd "${WORKING_DIR}/scripts/bin"

echo "You are currently in the directory: $(pwd)"

# Source utility scripts
#------------------------------------------------------------------------
# pre - prepare the environment
#------------------------------------------------------------------------
source "$(dirname "$0")/../lib/prompt.sh"
source "$(dirname "$0")/../lib/prepare_environment.sh"
#------------------------------------------------------------------------
# pre - generate config
#------------------------------------------------------------------------
source "$(dirname "$0")/../lib/generate_config.sh"
