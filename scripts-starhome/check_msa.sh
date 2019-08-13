#!/bin/bash -x

msa_ip=`grep msa_ip /usr/local/etc/starhome/load_alarm/conf/load_alarm.conf |awk -F\= '{print$2}'`

for msa in $msa_ip
        do 
                echo $msa
                snmpwalk -c starro -v 2c  $msa experimental.94.1.6.1.6
        done