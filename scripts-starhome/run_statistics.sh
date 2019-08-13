#!/bin/bash -x
sleep 30
(
export ORASH=/etc/sh/orash
export BAS_ORACLE_LIST=igt
export ORA_VER=1120
export ORACLE_SID=igt
export ORACLE_BASE=/software/oracle
export ORACLE_ENV_DEFINED=yes
export ORA_NLS33=/software/oracle/112/ocommon/nls/admin/data
export ORACLE_HOME=/software/oracle/112
export ORA_EXP=/backup/ora_exp

. /etc/sh/orash/oracle_login.sh igt

sqlplus GBR_VODAF_SPARX/GBR_VODAF_SPARX@igt @/starhome/ftm/statistics/statistics.sql

datee=$(date +%Y%m%d%H%M)
site="PR"
dir=/starhome/ftm/statistics

for i in `ls $dir|grep report|cut -c-10`
    do
        mv $dir/$i $dir/transfer/$site\_$i-$datee.dat
    done

sleep 3

scp $dir/transfer/$site* mft22471@10.145.17.76:/data1/home/mft22471/xfer00068/

if [ "$?" -eq 0 ]; then
    zip -m $dir/archive/$site-$datee.zip $dir/transfer/$site*.dat
else
    sleep 30
    scp $dir/transfer/$site* mft22471@10.145.17.76:/data1/home/mft22471/xfer00068/
fi

if [ "$?" -eq 0 ]; then
    zip -m $dir/archive/$site-$datee.zip $dir/transfer/$site*.dat
else
    scp $dir/transfer/$site* mft22471@10.145.17.75:/data1/home/mft22471/xfer00068/
    zip -m $dir/archive/$site-$datee.zip $dir/transfer/$site*.dat
fi

) | tee -a /starhome/ftm/statistics/log.log