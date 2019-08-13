#!/bin/bash
#powered by elkatz

last=`grep RedundancyLogger-printSpuSnapshot logs/redundancy_log.txt |tail -1 |awk '{print$1,$2}'`
grep -A18 "$last" logs/redundancy_log.txt|grep id |awk '{print$4","$6","$8","$9","$10","$11","$19","$15}' > result.dat 

echo "----------------------"
echo -ne "Current time" ;date
echo "----------------------"
echo $last
echo "----------------------"
echo "`grep -A18 "$last" logs/redundancy_log.txt|grep List`"
echo "----------------------"
f=0
for i in `cat result.dat`
        do
        id=`echo $i |awk -F\, '{print$1}'`
        status=`grep -w $id result.dat |grep raise|wc -l`
                if [ "$status" -eq "1" ];then
                        tput bold ; echo "$i" ; tput sgr0
                        i=$((i+1))
                else
                        echo "$i"
                fi
        done
echo "----------------------"
tput blink ; echo "Total issues detected: $f " ; tput sgr0
echo "----------------------"