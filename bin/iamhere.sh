#!/bin/bash
# encoding: utf-8
# Name  : iamhere.sh
# Descp : used for 
# Author: jaycee
# Date  : 04/08/18 11:17:19 +0800
__version__=0.1

set -x                     #print every excution log
set -e                     #exit when error hanppens


sudo mongod --port 27018
sudo nsqd --lookupd-tcp-address=localhost:4160
