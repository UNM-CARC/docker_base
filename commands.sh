#!/bin/bash
set -e

# We choose *not* to run as a login shell to always avoid the commands
. /etc/profile.d/00-modulefiles.sh
. /etc/profile.d/spack.sh
. /etc/profile.d/z00-lmod.sh

# set env and view paths
# SPACK_ENV_PATH="$GITHUB_WORKSPACE/spack/env"
# SPACK_ENV_VIEW="$SPACK_ENV_PATH/view"

# create environment if it doesn't exist
# if [ ! -d "$SPACK_ENV_PATH" ]; then
#  mkdir -p "$SPACK_ENV_PATH"
#  spack env create --dir "$SPACK_ENV_PATH" --with-view "$SPACK_ENV_VIEW"
#fi

# activate environment
# spack env activate "$SPACK_ENV_PATH"

# add environment view to PATH
#PATH="$PATH:$SPACK_ENV_VIEW/bin"
module load openmpi-3.1.4-gcc-4.8.5-2e57mrc
exec "$@"
