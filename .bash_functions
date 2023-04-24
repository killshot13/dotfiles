#!/bin/bash
function cl() {
    DIR="$*"
    # if no DIR given, go home
    if [ $# -lt 1 ]; then
        DIR=$HOME
    fi
    builtin cd "${DIR}" &&
        # use your preferred ls command
        ls -F --color=auto
}
function tmpclean() {
    DIR="/tmp"
    # use sudo to make sure everything is deleted
    sudo find "${DIR}" -type f -atime +14 -delete
}
