#!/bin/bash
# encoding: utf-8
# Name  : iptablesModification.sh
# Descp : used for 
# Author: jaycee
# Date  : 10/01/18 19:25:29 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens

iptables -A INPUT -p tcp --dport 9001 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 9001 -j ACCEPT
iptables -A INPUT -p udp --dport 9001 -j ACCEPT
iptables -A OUTPUT -p udp --sport 9001 -j ACCEPT

iptables -A INPUT -p tcp --dport 9002 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 9002 -j ACCEPT
iptables -A INPUT -p udp --dport 9002 -j ACCEPT
iptables -A OUTPUT -p udp --sport 9002 -j ACCEPT

iptables -A INPUT -p udp -s 238.0.0.25 -j ACCEPT
iptables -A OUTPUT -p udp -d 238.0.0.25 -j ACCEPT

iptables -A FORWARD -p udp -s 238.0.0.25 -j ACCEPT
iptables -A FORWARD -p udp -d 238.0.0.25 -j ACCEPT
