#!/bin/bash
# encoding: utf-8
# Name  : rmAttic.sh
# Descp : used for 
# Author: jaycee
# Date  : 20/12/17 13:59:29 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens


find dev/src/ -maxdepth 5 -type d -name "attic" -exec rm -rfy {} \;
