rhes-5.8_64-ig_v3.5.0
Last login: Sun Jun 22 11:05:51 2014 from 85.205.247.215
iu@esp-vod-1-mng-1:~>% crontab -l
# ftm counters
*/15 * * * * /starhome/ftm/ftm_counter_collect.sh
# ftm data
1 * * * * /starhome/ftm/ftm_data_collect.sh
iu@esp-vod-1-mng-1:~>% 
iu@esp-vod-1-mng-1:~>% 
iu@esp-vod-1-mng-1:~>% 
iu@esp-vod-1-mng-1:~>% cat /starhome/ftm/ftm_counter_collect.sh
#!/bin/bash
#Powered by elkatz
arr1=(`awk '{print $1}' /starhome/ftm/gates.ini`) # IP
arr2=(`awk '{print $2}' /starhome/ftm/gates.ini`) # gate
mng="10.105.10.62:/starhome/data_export/infovista/counters/"
i=1
last=`cat /starhome/ftm/.last.tmp`
zip -m /starhome/data_export/infovista/counters/counters_$last.zip /starhome/data_export/infovista/counters/*counter.dat
sleep 1
while [ $i -le ${#arr1[*]} ]     
        do  
                /usr/bin/ssh ${arr1[$i-1]} "scp /starhome/igate/${arr2[$i-1]}/data/*counter.dat  $mng"  
                i=$((i+1))
        done

echo "$(date +"%Y%m%d%H%M")" > /starhome/ftm/.last.tmp
iu@esp-vod-1-mng-1:~>% cat /starhome/ftm/ftm_data_collect.sh
#!/bin/bash
#Powered by elkatz
arr1=(`awk '{print $1}' /starhome/ftm/gates.ini`) # IP
arr2=(`awk '{print $2}' /starhome/ftm/gates.ini`) # gate
arr3=(`awk '{print $3}' /starhome/ftm/gates.ini`) # customer
mng="10.105.10.62:/starhome/"
now=$(date +"%Y%m%d")
last=`cat /starhome/ftm/.last2.tmp`
i=1

if [ $now != $last ]; then
        while [ $i -le ${#arr1[*]} ]
                do
                zip -m /starhome/data_export/${arr3[$i-1]}/sdr/sdr_$last.zip /starhome/data_export/${arr3[$i-1]}/sdr/*.dat
                        zip -m /starhome/data_export/${arr3[$i-1]}/edr/edr_$last.zip /starhome/data_export/${arr3[$i-1]}/edr/*.dat
                        zip -m /starhome/data_export/${arr3[$i-1]}/mdr/mdr_$last.zip /starhome/data_export/${arr3[$i-1]}/mdr/*.dat
                        i=$((i+1))
                done
else
        echo "Do nothing" > /dev/null
fi

i=1
while [ $i -le ${#arr1[*]} ]     
do  
/usr/bin/ssh ${arr1[$i-1]} "scp /starhome/igate/${arr2[$i-1]}/data/*moco*sdr*.20*  $mng/data_export/${arr3[$i-1]}/sdr" 
/usr/bin/ssh ${arr1[$i-1]} "rm /starhome/igate/${arr2[$i-1]}/data/*moco*sdr*.20*" 
/usr/bin/ssh ${arr1[$i-1]} "scp /starhome/igate/${arr2[$i-1]}/data/*edr*.20*.dat  $mng/vrs_operations/${arr3[$i-1]}/edr" 
/usr/bin/ssh ${arr1[$i-1]} "rm /starhome/igate/${arr2[$i-1]}/data/*edr*.20*.dat" 
/usr/bin/ssh ${arr1[$i-1]} "scp /starhome/igate/${arr2[$i-1]}/data/*mdr*.20*.dat  $mng/vrs_operations/${arr3[$i-1]}/mdr" 
/usr/bin/ssh ${arr1[$i-1]} "rm /starhome/igate/${arr2[$i-1]}/data/*mdr*.20*.dat*" 

i=$((i+1))
done

#Keep zipped SDRs for 3 months, delete older than 90 days#Bostrov#
i=1
while [ $i -le ${#arr1[*]} ]
do
find /starhome/data_export/${arr3[$i-1]}/sdr/* -mtime +90 -exec rm {} \;
i=$((i+1))
done
  
echo "$(date +"%Y%m%d")" > /starhome/ftm/.last2.tmp
