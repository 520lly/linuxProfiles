#!/bin/bash
# encoding: utf-8
# Name  : buildServer.sh
# Descp : used for connecting to cnninvmwkst01 server for build tasks
# Author: jaycee
# Date  : 22/12/17 14:50:58 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens

USER="wang_j11"
PASSWD="`cat ~/bin/pw4wang_j11 | tr -d ['\r\n']`"
#HOST=cnninvmwkst01 
HOST1="10.57.9.145"
HOST2="10.57.69.11"
CMD_PROMPT="\](\$|#)" 
CLEAR="\0C"
#HOST=${HOST1}

function usage()
{
cat << EOF
usage:$0  [-h?sup] <server -s> <username -u> <password -p>
-------- server 1 : cnninvmwkst01 
-------- server 2 : cnninvmwkst02
EOF
}

while getopts "h?s:u:p:" opt; do
    case "$opt" in
        h|\?)
            usage
            exit 0
            ;;
        s)  
            SERVER=$OPTARG
            #drop the first two parameters
            shift 2
            ;;
        u)  
            USER=$OPTARG
            #drop the first two parameters
            shift 2
            ;;
        p)  
            PASSWD=$OPTARG
            #drop the first two parameters
            shift 2
            ;;
    esac
done

echo "SERVER = ${SERVER}"
if [ ${SERVER} == "1" ]
then
   echo "HOST1"
   HOST=${HOST1}
elif [ ${SERVER} == "2" ]
then
   echo "HOST2"
   HOST=${HOST2}
else
   echo "nothing "
   usage
   exit 1
fi

echo "HOST = ${HOST}"
#exit

expect -c " 
   spawn ssh $USER@$HOST
   send_user connecting\ to\ $TARGET_NAME...\r 
   expect {
           *yes/no* { send -- yes\r;exp_continue;}  
           *password* { 
           send -- $PASSWD\r;
           set timeout 1
           expect -re $CMD_PROMPT
           send -- zsh\r;            #clear screen
           expect -re $CMD_PROMPT
           send -- mtmux\r;            #clear screen
           #send -- $CLEAR\r;            #clear screen
       }  
   }
   #expect -re $CMD_PROMPT
   #send -- $CLEAR\r;            #clear screen
   interact
"  

