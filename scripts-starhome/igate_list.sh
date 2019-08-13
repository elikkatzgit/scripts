#!/bin/bash
# Powered by elkatz
# Version 3.0 - 2014-05-20

log=/starhome/support/igate_list.dat
tmp=/starhome/support/tmp.tmp
tmp2=/starhome/support/tmp2.tmp
list=`cat /starhome/support/bics.hosts | egrep -v "glr|localhost|ora|alpha|beta" |grep -v \# |awk '{print$1}'`

rm -rf $log

if [ "$EUID" == "0" ] && [ "$OSTYPE" == "linux-gnu" ];then
        for i in $list
        do

                      /usr/bin/ssh $i "uname -n;
                                                                           echo "$i";
                                       dmidecode | grep DL|grep Pro|awk -F\: '{print\$2}';
                                                                           less /proc/meminfo|head -1"  >> $log

                                  /usr/bin/ssh $i "ls /starhome/igate/ ; ls /starhome/ |grep ftm" > $tmp
                                                echo "Gate_Name,DB_Schema,JvmID,Jmx_Port,Initmemory,Maxmemory,IG_Version,DB_Version,IG_status" >> $log
                        for ig in `cat $tmp`
                     
                                        do
                                                /usr/bin/ssh $i "
echo "$ig";
cat /starhome/igate/$ig/conf/config.xml|grep user| awk -F\> '{print\$2}'|awk -F\< '{print\$1}';
cat /starhome/igate/$ig/conf/config.xml|grep jvmID| awk -F\> '{print\$2}'|awk -F\< '{print\$1}';
cat /starhome/igate/$ig/conf/wrapper.conf|grep jmxremote.port|grep -v '#'|awk -F\= '{print\$3}';
cat /starhome/igate/$ig/conf/wrapper.conf|grep initmemory |grep -v '#'|awk -F\= '{print\$2}';
cat /starhome/igate/$ig/conf/wrapper.conf|grep maxmemory |grep -v '#'|awk -F\= '{print\$2}';
cat /starhome/igate/$ig/logs/wrapper.log | grep 'IG2 version' |tail -1| awk '{print\$12}';
cat /starhome/igate/$ig/logs/wrapper.log | grep 'IG version' |tail -1| awk '{print\$12}';
cat /starhome/igate/$ig/logs/wrapper.log | grep 'DB version' |tail -1| awk '{print\$15}'; 
cat /starhome/igate/$ig/logs/wrapper.log |tail -1| awk -F\| '{print\$4}'" > $tmp2
cat $tmp2 | tr "\\n" "," >>$log
echo >> $log

                    done
echo "--provinstall---" >> $log
/usr/bin/ssh $i "grep Implementation-Version /starhome/igateprov/webapps/*/META-INF/MANIFEST.MF |awk -F\\\/ '{print\$5,\$7}' |awk '{print\$1,\$3}'" >> $log
echo "----base001-----" >> $log
/usr/bin/ssh $i "grep Implementation-Version /starhome/igprov/base001/webapps/*/META-INF/MANIFEST.MF|awk -F\\\/ '{print\$6,\$8}'|awk '{print\$1,\$3}'" >> $log
echo "----base002-----" >> $log
/usr/bin/ssh $i "grep Implementation-Version /starhome/igprov/base002/webapps/*/META-INF/MANIFEST.MF|awk -F\\\/ '{print\$6,\$8}'|awk '{print\$1,\$3}'" >> $log

done
else
        echo "------------------------------------------------"
        echo "You are root, please run this script as iu"
        echo "------------------------------------------------"
fi
rm -rf $tmp
rm -rf $tmp2