#!/bin/bash
# encoding: utf-8
# Name  : updateOnHost.sh
# Descp : used for 
# Author: jaycee
# Date  : 31/01/18 15:09:24 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens

if [ $# -lt 2 ]
then 
    echo "$0 server [0/1] <update direcory path>"
else
    find ./ -type f -name "*.so" -exec scpPush -s ${1:-0} {} /root/phone/${2:-""}
    scpPush -s ${1} /home/user/jpcc/debug/phone/onTarget/updateOnTarget.sh /root/phone/${2}
fi

