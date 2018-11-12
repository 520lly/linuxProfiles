#!/bin/sh

DIR=`pwd`

if [ $# -eq 2 ]
then
    find $DIR -type f -name "${1}" | xargs perl -pi -e '${2}' 
else
    echo "far: <file name> <patten and operation>"
fi


