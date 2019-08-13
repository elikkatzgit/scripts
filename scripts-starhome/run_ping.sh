!#/bin/bash
log=/starhome/iu/workarea/ping_SLAN_check.dat
while true ;do 
echo -ne $(date +"%Y-%m-%d %H:%M:%S -") >> $log ;ping -c 1 10.20.24.18|grep icmp_seq >> $log
echo -ne $(date +"%Y-%m-%d %H:%M:%S -") >> $log ;ping -c 1 10.20.24.20|grep icmp_seq >> $log
sleep 1
done