#!/bin/bash
# encoding: utf-8
# Name  : vmstatGraph.sh
# Descp : used for 
# Author: jaycee
# Date  : 27/09/17 14:07:07 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens

cd $1
for lf in *app*.log; do
  ../vmplot.py -t $lf -c 21 -s $(wc -l $lf) -k 1024 -m 4096 $lf
done
for lf in *lb*.log *db*log; do
  ../vmplot.py -t $lf -c 21 -s $(wc -l $lf) -k 1024 -m 2048 $lf
done
ls -1 *.png |sort |sed -e 's/^/<img src="/' -e 's/$/"><br>/' >index.html
cd ..
