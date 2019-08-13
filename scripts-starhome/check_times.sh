#!/bin/bash
#powered by elkatz
file=$1
imsi=`grep "Request to SMM" $file |awk -F\" '{print$18}'`

for i in $imsi
        do
                TIME1=`grep $i $file |grep "Request to SMM"|awk '{print$2}'|awk -F\, '{print$1}'|tail -1`
                TIME2=`grep $i $file |grep "Response from SMM"|awk '{print$2}'|awk -F\, '{print$1}'|tail -1`

# Convert the times to seconds from the Epoch
SEC1=`date +%s -d ${TIME1}`
SEC2=`date +%s -d ${TIME2}`

# Use expr to do the math, let's say TIME1 was the start and TIME2 was the finish
DIFFSEC=`expr ${SEC2} - ${SEC1}`

echo "$i , Start ${TIME1} , Finish ${TIME2} , Took ${DIFFSEC} seconds"

done