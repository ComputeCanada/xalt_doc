#!/bin/bash

MODULE=xalt
VERSION=2.10.13
MODULEUPPER=$(echo "${MODULE^^}")
MODULEROOT="EBROOT$MODULEUPPER"

function usage() {
    echo "Usage: $0 get | set MODULEFILE"
    exit
}

if [ -z "$1" ]; then
    usage
fi

case "$1" in
    "set")
        if [ -z "$2" ]; then
            usage
        fi
        module load xalt
        TARGET="${!MODULEROOT}/../../../../../modules/2020/Core/$MODULE/$VERSION.lua"
        cp $2 $TARGET
        chmod 755 $TARGET
        ;;
    "get")
        module --raw show $MODULE/$VERSION | tail -n +4
        ;;
    *)
        usage
        ;;
esac
