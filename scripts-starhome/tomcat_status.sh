#!/bin/sh
#powered by elkatz

if [ $# -eq 0 ]; then
    echo "Please specify base, example: ./tomcat_status.sh 005"
    exit 1
fi

sum=`ls /starhome/igprov/base$1/conf/Catalina/localhost|grep -v manager |wc -l`
last=`grep "Server startup" /starhome/igprov/base$1/logs/webserver/catalina-daemon.out |tail -1`
i=`grep -A1000 "$last" /starhome/igprov/base$1/logs/webserver/catalina-daemon.out |grep subsystem|wc -l`

tail -f /starhome/igprov/base$1/logs/webserver/catalina-daemon.out | while read line ; do
        echo "$line" | egrep "subsystem|ms" >/dev/null

if [ $? = 0 ]; then
        if [[ $line == *"ms"* ]]; then
                echo "$line"
                echo " --> tomcat is up"
        else
        echo "$line" |awk -F\: '{print$2}' 
        echo " --> $i out of $sum is up"
        i=$((i+1))
        fi
fi
done