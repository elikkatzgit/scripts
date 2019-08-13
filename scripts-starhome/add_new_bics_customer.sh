#!/bin/bash
#Powered by elkatz
echo ""
echo ""
echo "Enter customer name in format ccc-ooo"
echo "(example: nga-mtn)" ; read gate
cd /starhome/bicsftp/ftp/
mkdir /starhome/bicsftp/ftp/$gate
getfacl nld-zig | setfacl --set-file=- $gate

if [ "$?" -eq 0 ]; then
sleep 1
echo ""
echo "Gate greated as:"
ls -ltr |grep $gate
sleep 1
echo ""
echo "Completed successfuly"
echo ""
else
echo "Operation Fail, please run manualy"
fi



chown -R nobody:comcust gnb-mtn


