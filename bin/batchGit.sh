#!/bin/bash
# encoding: utf-8
# Name  : batchGit.sh
# Descp : used for 
# Author: jaycee
# Date  : 15/03/18 13:33:15 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens

ret=`which zsh`
if [ $? -ne 0 ]
then 
    echo "no zsh installed"
fi

gst="git status"

optype=$1
action=$2

case $optype in 
    "add")
        for modify in $($gst | grep -E "new file" | awk '{print $2}'); do
            eval 'git $action $modify'
        done
        ;;
    "modified")
        for modify in $($gst | grep -E "modified" | awk '{print $2}'); do
            eval 'git $action $modify'
        done
        ;;
    "deleted")
        for modify in $($gst | grep -E "deleted" | awk '{print $2}'); do
            eval 'git $action $modify'
        done
        ;;
esac
