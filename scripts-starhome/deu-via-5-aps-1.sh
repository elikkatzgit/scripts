#!/bin/bash
# Powered by elkatz

log=/starhome/ftm/ftm_sfi.log
sfi_ip=10.0.156.92
file=Whitelist_ROWBCSbusiness.txt
is_sfi=`ifconfig |grep $sfi_ip |wc -l`


if [ "$is_sfi" -eq "1" ]; then
FTPHOST='82.113.112.65'
USR='starho93'
PASS='StAr9933'
ftp -n -v $FTPHOST <<EOF
user $USR $PASS
prompt
binary
lcd /starhome/igate/deu-o2q-sfi/data/Services/DEU_O2QQQ_SPARX/work
mget $file
mdel $file

bye
EOF

        if [ -f /starhome/igate/deu-o2q-sfi/data/Services/DEU_O2QQQ_SPARX/work/$file ]; then
                echo -ne `date +"%Y-%m-%d %H:%M"` "--> " >>$log ; echo "File transfered successfully" >>$log
        else
                echo -ne `date +"%Y-%m-%d %H:%M"` "--> ---ERROR--- " >>$log ;echo "FTP failed or file doesnt exist, sending SNMP" >>$log
                send_snmp.sh Critical "FTM-FTP could not retrieve SFI $file file from customer FTP server" 987989  up 10.227.3.51
        fi

else
        echo -ne `date +"%Y-%m-%d %H:%M"` "--> " >>$log ; echo "SFI is not running here" >>$log
fi