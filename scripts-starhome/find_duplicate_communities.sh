#!/bin/bash
#Powered by elkatz

file=ipn_sdr_31.dat

imsi=`cat $file |awk -F\; '{print$5}'`

for i in $imsi
        do
                list=`cat $file |grep $i |awk -F\; '{print$29}' |sort -u|wc -l`
                if [ "$list" != "1" ];then
                        echo "$i , $list"
                        echo "-----------------"
                fi
        done




262073978906493|262032000005755|262032017725572



"491635740928|4917661969240|4915779001215"
262073978906493
	262032000005755
	262032017725572
