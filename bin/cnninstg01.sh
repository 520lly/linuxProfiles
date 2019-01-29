#!/bin/bash
# encoding: utf-8
# Name  : /home/jacking/bin/cnninstg01.sh
# Descp : used for 
# Author: jaycee
# Date  : 22/01/19 21:40:10 -0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens

sudo mount -v -t cifs -o username=jpcc_guest,password=Start12345,vers=1.0 //10.57.69.5/TestLog ~/work/cnninstg01
