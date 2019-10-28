#!/bin/bash -l

unset CURRENTLY_BUILDING_DOCKER_IMAGE
spack env activate stampede2-skx

if [ "$1" '=' 'docker-shell' ] ; then
    if [ -t 0 ] ; then
        exec bash -il
    else
        (
            echo -n "It looks like you're trying to run an intractive shell"
            echo -n " session, but either no psuedo-TTY is allocateed for this"
            echo -n " container's STDIN, or it is closed."
            echo

            echo -n "Make sure you run docker with the --interactive and --tty"
            echo -n " options."
            echo
        ) >&2

        exit 1
    fi
else
    /home/docker/commands.sh "$@"
    exit $?
fi
