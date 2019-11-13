#!/bin/bash -l

unset CURRENTLY_BUILDING_DOCKER_IMAGE
export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
export PATH=/usr/local/bin:/usr/local/sbin:${PATH}
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:${PYTHONPATH}
export INCLUDE=/usr/local/include:${INCLUDE}
export SHARE=/usr/local/share:${SHARE}
export MANPATH=${SHARE}/man

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
