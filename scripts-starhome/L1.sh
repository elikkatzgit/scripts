#!/bin/bash
#powered by elkatz

trunk=`grep card-trunk /home/ansty/run/sbmaint.ini|awk -F\= '{print$2}'`
for i in $trunk
        do
                cat sbmaint_0.log |grep "trunk $i" |tail -1
        done
