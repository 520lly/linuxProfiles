#!/bin/bash
# encoding: utf-8
# Name  : /home/PREHCN/wang_j11/bin/submoduleAdder.sh
# Descp : used for 
# Author: jaycee
# Date  : 09/11/18 11:44:38 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens

find ${1:-"."} -name config |                            # find all config files
    grep git/config |                            # include only those that have "git/config" in their path
    grep -v ProjectToExclude |                   # exclude config files with ProjectToExclude in their path
    grep -v AnotherProjectToExclude |            # ditto
    xargs -n 1 -I % sh -c '                      # one line at a time, execute the following commands, substituting the path for `%`
        cat % |                                  # print the config file contents
            grep -m 1 url |                      # take the first line that contains `url`
            sed "s/url = //g";                   # remove the "url = " part
        echo % |                                 # print the path to the config file
            sed "s/.git\/config//g";             # remove '.git/config' to keep only the project path
    ' |                                          # summary: print the remote url on every 2nd line; the path on every 2nd line 
    xargs -n 2 echo git submodule add            # take two lines at a time, print them with the command
