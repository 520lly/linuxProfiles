#!/bin/sh -f
# encoding: utf-8
# Name  : routeOnTarget.sh
# Descp : used for running on target to set route
# Author: jaycee
# Date  : 27/12/17 18:24:46 +0800
__version__=0.1

set -x                     #print every excution log
#set -e                     #exit when error hanppens

TARGET_IP=`cat /root/ifc4BuildServer | tr -d ['\r\n']`
route add -host $TARGET_IP dev eth0 
route add -host 10.57.16.87 dev eth0 
TARGET_IP=`cat /root/ifc4Lanptop | tr -d ['\r\n']`
route add -host $TARGET_IP dev eth0
iptables -P OUTPUT ACCEPT


#iptables -F 
#iptables -P INPUT ACCEPT
#iptables -P FORWARD ACCEPT
#iptables -P OUTPUT ACCEPT


#rm /root//ifc4Lanptop 
#rm /root/ifc4BuildServer



