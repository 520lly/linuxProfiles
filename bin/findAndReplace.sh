#!/bin/bash
# encoding: utf-8
# Name  : findAndReplace.sh
# Descp : used for 
# Author: jaycee
# Date  : 08/04/18 14:18:37 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens
function Usage() {
    echo $@            
    echo "Usage: ${0##*/} <Directory> <filetype> <patten>"
    exit 1
}

DIR=${1:-"."}
FILETYPE=${2:-"cpp"}
PATTEN=${3}

if [ $# -lt 3 ]
then
    Usage
fi
#find $DIR -type f -name "*.${2}" | xargs perl -pi -e 's|\<(LOG_[DE]\()[NBGRY].*"\([ =-]\)|\1"\2|g' 
find $DIR -type f -name "*.${FILETYPE}" | xargs perl -pi -e '${PATTEN}' 
