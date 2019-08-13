#!/bin/bash
#Powered by elkatz

log=/starhome/ftm/ftm.log

if [ ! -d "/starhome/igate/probe/for_celcom_use/tmp" ]; then
        mkdir /starhome/igate/probe/for_celcom_use/tmp
fi
if [ ! -d "/starhome/igate/probe/for_celcom_use/archive" ]; then
    mkdir /starhome/igate/probe/for_celcom_use/archive
fi

find /starhome/igate/probe/for_celcom_use/archive/ . -name "TLS*.zip" -mtime +7 -exec rm -rf {} \;
cd /starhome/igate/probe/for_celcom_use/
find . -name "TLS*" -mmin -60 -print |xargs zip -m tmp/TDR_$(date +%Y%m%d%H%M).zip

sftp starhome@10.10.62.158 << EOF
put /starhome/igate/probe/for_celcom_use/tmp/TDR_$(date +%Y%m%d%H%M).zip
quit
EOF

if [ "$?" -eq 0 ]; then
        echo "$(date +%Y-%m-%d_%H:%M) TLS files were delivered successfully" >> $log
        mv /starhome/igate/probe/for_celcom_use/tmp/TDR_$(date +%Y%m%d%H%M).zip /starhome/igate/probe/for_celcom_use/archive
else
        echo "$(date +%Y-%m-%d_%H:%M) ==ERROR== fail to deliver TLS file, going to send SNMP" >> $log
        send_snmp.sh Critical "TLS Files were not delivered to customer" 987989  up 10.227.3.51
fi
