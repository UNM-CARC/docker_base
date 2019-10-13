#!/bin/bash -l
set -e
spack env activate wheeler
exec "$@"
