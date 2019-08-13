#!/bin/bash -x
# Powered by elkatz

(

### bring SPU counters ###

num_spu=10
ini=/starhome/ftm/sigtran_probes.ini
ip=`cat $ini |awk '{print$3}'|grep -v SERVICE`
datee=`date +"%d%m%Y" --date="1 days ago"`
work=/starhome/ftm/tmp

for i in $ip
        do
                scp $i:/starhome/igate/*/DSI/logs/MSU_License*$datee*.csv $work
        done

FTPHOST='10.0.156.75'
USR='iu'
PASS='Sgc-Prvi'
ftp -n -v $FTPHOST <<EOF
user $USR $PASS
prompt
binary
lcd $work
cd /starhome/igate/fra-tdm-spu/DSI/logs/
mget MSU_License*$datee*.csv
bye
EOF

FTPHOST='10.0.156.76'
USR='iu'
PASS='Sgc-Prvi'
ftp -n -v $FTPHOST <<EOF
user $USR $PASS
prompt
binary
lcd $work
cd /starhome/igate/fra-tdm-spu/DSI/logs/
mget MSU_License*$datee*.csv
bye
EOF


#if [ `ls $work|wc -l` = $num_spu ]; then
#echo "all files arrived to calc"
#else
#echo "continue but zipping for debug"
#cd $work
#zip ../SPU_stat-$datee.zip $work/*.csv
#mv $work/*.csv $dest/
#send_snmp.sh Critical "FTM-Not all SPU statistics arrived to DB" 987989  up 10.227.3.51
#fi

. /etc/sh/orash/oracle_login.sh igt
. /starhome/iu/.set_profile

cd /starhome/ftm/
/software/oracle/112/bin/sqlplus DEU_O2QQQ_SPARX/DEU_O2QQQ_SPARX@igt @/starhome/ftm/statistics.sql
mv /starhome/ftm/tmp/sparx_counters.csv /starhome/ftm/tmp/sparx_counters_$datee.csv
cp /starhome/ftm/tmp/sparx_counters_$datee.csv /starhome/ftm/archive/

cd $work
zip -m $datee.zip *$datee*.csv

) | tee -a /starhome/ftm/log_$datee.log