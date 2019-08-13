#!/bin/bash

datee=`date +"%b%d" --date="2 days ago"`
list=`ps -ef |grep /usr/libexec/openssh/sftp-server|grep $datee| awk '{print$2}'`
num=`echo $list |wc -w`
echo "Too Many open ftp connections: $num " ; read -n1 -r -t 5 -p "Press space or wait 5 seconds to kill them all..." key

   for i in $list
    do
        echo "$i"
        kill -9 $i
    done