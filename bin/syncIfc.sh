#!/bin/bash
# encoding: utf-8
# Name  : syncIfc.sh
# Descp : used for 
# Author: jaycee
# Date  : 19/04/18 09:17:32 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens

function usage()
{
    echo "usage:$0 <ip address>"
}
if [ $# -eq 1 ]
then
    echo $1 > ~/bin/ifc
    echo "$1:12345" > ~/bin/ifcdebug
    scpPush -s 1 ~/bin/ifc /home/PREHCN/wang_j11/bin/ifc
    scpPush -s 0 ~/bin/ifc /root/ifc
    scpPush -s 0 ~/bin/ifcdebug /root/ifcdebug
else
    usage
fi
#zr3Cmd "./routeOnTarget.sh"

