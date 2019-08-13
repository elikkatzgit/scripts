#!/bin/bash

testip=2
JONTE=10.80.12.197
TORCUATO=10.80.12.133
RESULT_1=`ping $JONTE |grep "TTL"|wc -l`

date >> /cygdrive/d/bat_files/ping_probe.log
if [ "$testip" -gt "$RESULT_1" ] 
then
	echo " - sending alarm for JONTE - " >> /cygdrive/d/bat_files/ping_probe.log
	/usr/local/bin/send_snmp.sh Critical "Lost Connection to JONTE Probe (no drop for this alarm, need to check ping to 10.80.12.197)" 987989  up 10.227.3.51
else
	echo " - JONTA OK - " >> /cygdrive/d/bat_files/ping_probe.log
fi

RESULT_2=`ping $TORCUATO |grep "TTL"|wc -l`

if [ "$testip" -gt "$RESULT_2" ]
then
	echo " - sending alarm for TORCUATO - " >> /cygdrive/d/bat_files/ping_probe.log
        /usr/local/bin/send_snmp.sh Critical "Lost Connection to TORCUATO Probe (no drop for this alarm, need to check ping to 10.80.12.133)" 987989  up 10.227.3.51
else
	echo " - TORCUATO OK - " >> /cygdrive/d/bat_files/ping_probe.log
fi