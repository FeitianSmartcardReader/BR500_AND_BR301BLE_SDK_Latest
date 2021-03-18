#!/bin/bash
curuser=`stat -f '%Su' /dev/console`
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
LAUNCH_AGENT_PLIST="$LAUNCH_AGENTS_DIR/com.ftsafe.VirtualSoftCCID.plist"

su "$curuser" -c  "launchctl unload $LAUNCH_AGENT_PLIST"
sudo rm -rf    $LAUNCH_AGENT_PLIST 
sudo rm -rf    /etc/reader.conf
sudo rm -rf    /Library/Frameworks/FTSoftCCID
sudo rm -rf    /Applications/FTSoftCCID2.app
sudo rm -rf    /usr/local/libexec/SmartCardServices/drivers/ifd-FeiTianBLEDriver.bundle


pid=`ps ax | grep com.apple.ifdbundle|grep -v "grep"|awk '{print $1}'`
if [ -n "$pid" ];then
        sudo kill -9 $pid
fi

pid=`ps ax | grep com.apple.ifdreader| grep -v "grep"|awk '{print $1}'`
if [ -n "$pid" ];then
        sudo kill -9 $pid
fi

exit 0
