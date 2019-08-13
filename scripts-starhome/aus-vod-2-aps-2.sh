#!/bin/bash
#Powered by elkatz

mng=10.98.20.52:/starhome/data_export/

if [ ! -d "/starhome/igate/aus-vod-spx/data/tmp" ]; then
mkdir /starhome/igate/aus-vod-spx/data/tmp
fi
cd /starhome/igate/aus-vod-spx/data/
find . -name "sparx_edr_1.201*" -mmin -10 -print |xargs zip tmp/sparx_edr_$(date +%Y%m%d%H%M).zip
if [ "$?" -eq 0 ]; then
echo "OK" >/dev/null
else
send_snmp.sh Critical "EDR Files were not zipped to be sent to customer" 987989  up 10.227.3.51
fi
scp /starhome/igate/aus-vod-spx/data/tmp/sparx_edr_$(date +%Y%m%d%H%M).zip $mng
if [ "$?" -eq 0 ]; then
/usr/bin/ssh 10.98.20.52 "find /starhome/data_export/ -name "sparx_edr_1.201*" -mtime +3 -exec rm -rf {} \; " 
else
send_snmp.sh Critical "EDR Files were not Delivered to customer FTP dolfer in MNG for customer" 987989  up 10.227.3.51
fi
