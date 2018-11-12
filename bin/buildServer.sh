#!/bin/bash
# encoding: utf-8
# Name  : buildServer.sh
# Descp : used for connecting to cnninvmwkst01 server for build tasks
# Author: jaycee
# Date  : 22/12/17 14:50:58 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens

USER=${1:-"wang_j11"}
PASSWD=${2:-"`cat ~/bin/pw4wang_j11 | tr -d ['\r\n']`"}
#HOST=cnninvmwkst01 
HOST="10.57.9.145"
CMD_PROMPT="\](\$|#)" 
CLEAR="\0C"


expect -c " 
   spawn ssh $USER@$HOST
   send_user connecting\ to\ $TARGET_NAME...\r 
   expect {
           *yes/no* { send -- yes\r;exp_continue;}  
           *password* { 
           send -- $PASSWD\r;
           set timeout 0
           expect -re $CMD_PROMPT
           #send -- $CLEAR\r;            #clear screen
       }  
   }
   #expect -re $CMD_PROMPT
   #send -- $CLEAR\r;            #clear screen
   interact
"  

