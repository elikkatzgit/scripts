#!/bin/bash -x
# Powered by elkatz
# Version 1.0 2017

aps_list="10.105.78.35"
#aps_list=`cat /etc/hosts|egrep -i "aps|dbu"|awk '{print$1}'`
mng="10.105.78.37"
ccs_list="10.105.78.36"

folder=/starhome/support/
log=$folder/vrs_test_$(date +%Y-%m-%d-%H%M).csv
tmp=$folder/.tmp
tmp2=$folder/.tmp2

echo "======Application========" > $log
echo "Hostname,Gate_Name,SCHEMA,DB_IP,IG_Version,DB_Version,IG_status" >> $log

for i in $aps_list
    do
         /usr/bin/ssh -q $i "uname -n;
                            echo "$i""
                            /usr/bin/ssh $i "ls /starhome/igate/ |grep -v sp1|grep -v sp2" > $tmp
                        for ig in `cat $tmp`                     
                                        do
                                                /usr/bin/ssh $i "
uname -n;
echo "$ig";
cat /starhome/igate/$ig/conf/config.xml|grep user|head -1| awk -F\> '{print\$2}'|awk -F\< '{print\$1}';
cat /starhome/igate/$ig/conf/config.xml|grep serverIPAddress| awk -F\> '{print\$2}'|awk -F\< '{print\$1}';
cat /starhome/igate/$ig/logs/wrapper.log | grep 'IG2 version' |tail -1| awk '{print\$12}';
cat /starhome/igate/$ig/logs/wrapper.log | grep 'IG version' |tail -1| awk '{print\$12}';
cat /starhome/igate/$ig/logs/wrapper-sfi.log | grep 'Clover version' |tail -1| awk '{print\$12}';
cat /starhome/igate/$ig/logs/wrapper-sfi.log | grep 'DB version' |tail -1| awk '{print\$15}'; 
cat /starhome/igate/$ig/logs/wrapper.log | grep 'DB version' |tail -1| awk '{print\$15}'" > $tmp2
cat $tmp2 | tr "\\n" "," >>$log
echo >> $log
                    done
done

echo "======Provisioning========" >> $log
echo "base_installation,url,version" >> $log

ssh -q $mng "
grep Implementation-Version /starhome/igateprov/webapps/*/META-INF/MANIFEST.MF |awk -F\/ '{print\$3,\$5,\$7}' |sed 's/ MANIFEST.MF:Implementation-Version: /,/g' |sed 's/ /,/g'|sed 's/war.//g';
grep Implementation-Version /starhome/igprov/*/webapps/*/META-INF/MANIFEST.MF |awk -F\/ '{print\$4,\$6,\$8}' |sed 's/ MANIFEST.MF:Implementation-Version: /,/g' |sed 's/ /,/g'|sed 's/war.//g'" >> $log

echo "======CCS========" >> $log
for i in $ccs_list
        do
        ssh -q $i "uname -n;
           ls /home/utu/|grep TCAP|grep -v bkp;
           ls /home/utu/|grep CNF|grep -v bkp"  > $tmp2
           cat $tmp2 | tr "\\n" "," >>$log
           echo >> $log
        done

rm -rf $tmp
rm -rf $tmp2