#!/bin/bash
# encoding: utf-8
# Name  : backupTarget.sh
# Descp : used for update phone module and phonemanager module on target
# Author: jaycee
# Date  : 12/01/18 19:49:31 +0800
__version__=0.1

#set -x                     #print every excution log
set -e                     #exit when error hanppens

WORKSPACE="phone"
#WORKSPACE="test"

back_datename=$(date +%Y%m%d-%H%M%S)
foldername="backup-"$back_datename
BACK_PATH=/root/$WORKSPACE/$foldername

function backTarget()
{
    #create a folder to save orginal files and environment
    zr3Cmd mkdir /root/$WORKSPACE
    zr3Cmd mkdir /root/$WORKSPACE/$foldername
    zr3Cmd cp /usr/lib/libtsd.organizer.mib3.api.stub.so $BACK_PATH
    zr3Cmd cp /usr/lib/libtsd.organizer.mib3.api.proxy.so $BACK_PATH
    zr3Cmd cp /usr/lib/libtsd.bt.management.mib3.api.proxy.so $BACK_PATH
    zr3Cmd cp /usr/lib/libtsd.bt.management.mib3.api.stub.so $BACK_PATH
    zr3Cmd cp /usr/lib/libtsd.blueware.mib3.bluego.api.proxy.so $BACK_PATH
    zr3Cmd cp /usr/lib/libtsd.blueware.mib3.bluego.api.stub.so $BACK_PATH
    zr3Cmd cp /usr/lib/libtsd.bt.media.mib3.api.proxy.so $BACK_PATH
    zr3Cmd cp /usr/lib/libtsd.bt.media.mib3.api.stub.so $BACK_PATH
    zr3Cmd cp /usr/bin/tsd.bt.phone.mib3 $BACK_PATH
    zr3Cmd cp /usr/bin/tsd.phonemanager $BACK_PATH
    echo "Back Up orginal file and environment Done!"
}

update_datename=$(date +%Y%m%d-%H%M%S)
update_foldername="update-"$update_datename
UPDATE_PATH=/root/$WORKSPACE/$update_foldername

function configuration()
{
    echo "Current directory is: `pwd`"
    find ./dev/dist/phone -type f -name "*.so" -exec ls {} \;
    find ./dev/dist/phone -maxdepth 7 -type f -name "tsd.bt.phone.mib3" -exec ls {} \;
    find ./dev/dist/phone -maxdepth 7 -type f -name "tsd.phonemanager" -exec ls {} \;
    echo "Do you realy want to continue[Y/N]?"
    read resp
    if [ "$resp" == 'Y' ]
    then 
        echo "Yes continue!!!"
    else
        echo "Now EXIT!!!"
        exit
    fi
}

function updateToTarget()
{
    zr3Cmd mkdir -p $UPDATE_PATH
    find ./dev/dist/phone -type f -name "*.so" -exec scpPush -s ${1:-0} {} $UPDATE_PATH \;
    scpPush -s ${1:-0} ./dev/dist/phone/bt-phone/tsd-bt-phone-mib3-target/1/workspace/usr/bin/tsd.bt.phone.mib3 $UPDATE_PATH
    scpPush -s ${1:-0} ./dev/dist/phone/phonemanager/tsd-phonemanager-target/1/workspace/usr/bin/tsd.phonemanager $UPDATE_PATH
    scpPush -s ${1:-0} ~/bin/updateOnTarget.sh $UPDATE_PATH
}

function restartNew()
{
    #create a new folder to save new version of software and configuration files
    zr3Cmd systemctl stop phone
    zr3Cmd systemctl stop phonemanager
    zr3Cmd cp $UPDATE_PATH/libtsd.organizer.mib3.api.stub.so /usr/lib/libtsd.organizer.mib3.api.stub.so 
    zr3Cmd cp $UPDATE_PATH/libtsd.organizer.mib3.api.proxy.so /usr/lib/libtsd.organizer.mib3.api.proxy.so 
    zr3Cmd cp $UPDATE_PATH/libtsd.bt.management.mib3.api.proxy.so /usr/lib/libtsd.bt.management.mib3.api.proxy.so 
    zr3Cmd cp $UPDATE_PATH/libtsd.bt.management.mib3.api.stub.so /usr/lib/libtsd.bt.management.mib3.api.stub.so 
    zr3Cmd cp $UPDATE_PATH/libtsd.blueware.mib3.bluego.api.proxy.so /usr/lib/libtsd.blueware.mib3.bluego.api.proxy.so 
    zr3Cmd cp $UPDATE_PATH/libtsd.blueware.mib3.bluego.api.stub.so /usr/lib/libtsd.blueware.mib3.bluego.api.stub.so 
    zr3Cmd cp $UPDATE_PATH/libtsd.bt.media.mib3.api.proxy.so /usr/lib/libtsd.bt.media.mib3.api.proxy.so 
    zr3Cmd cp $UPDATE_PATH/libtsd.bt.media.mib3.api.stub.so /usr/lib/libtsd.bt.media.mib3.api.stub.so 
    zr3Cmd cp $UPDATE_PATH/tsd.bt.phone.mib3 /usr/bin/tsd.bt.phone.mib3 
    zr3Cmd cp $UPDATE_PATH/tsd.phonemanager /usr/bin/tsd.phonemanager
    #zr3Cmd cp $UPDATE_PATH/libtsd.organizer.mib3.api.stub.so /root/$WORKSPACE/dir
    #zr3Cmd cp $UPDATE_PATH/libtsd.organizer.mib3.api.proxy.so /root/$WORKSPACE/dir
    #zr3Cmd cp $UPDATE_PATH/libtsd.bt.management.mib3.api.proxy.so /root/$WORKSPACE/dir
    #zr3Cmd cp $UPDATE_PATH/libtsd.bt.management.mib3.api.stub.so /root/$WORKSPACE/dir
    #zr3Cmd cp $UPDATE_PATH/libtsd.blueware.mib3.bluego.api.proxy.so /root/$WORKSPACE/dir
    #zr3Cmd cp $UPDATE_PATH/libtsd.blueware.mib3.bluego.api.stub.so /root/$WORKSPACE/dir
    #zr3Cmd cp $UPDATE_PATH/libtsd.bt.media.mib3.api.proxy.so /root/$WORKSPACE/dir
    #zr3Cmd cp $UPDATE_PATH/libtsd.bt.media.mib3.api.stub.so /root/$WORKSPACE/dir
    #zr3Cmd cp $UPDATE_PATH/tsd.bt.phone.mib3 /root/$WORKSPACE/dir
    #zr3Cmd cp $UPDATE_PATH/tsd.phonemanager /root/$WORKSPACE/dir
    zr3Cmd systemctl start phone
    zr3Cmd systemctl start phonemanager
    echo "Update new version of files and environment Done!"
}

configuration
backTarget
updateToTarget
restartNew




