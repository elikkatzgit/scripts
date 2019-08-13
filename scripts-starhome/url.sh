#!/bin/bash
# Powered by elkatz
#2016-10-02 Version 2 - supporting chrome
#2017-12-14 Version 3 - supporting MicroStrategy
#2018-08-15 automatic IP and hostname, removing error when no bases

mng=`ifconfig|grep "inet addr" |head -1 |awk '{print$2}' |awk -F\: '{print$2}'`
site=`echo $HOSTNAME`

page=/starhome/igateprov/webapps/ROOT/index.html
tmp=/starhome/support/url.dat
datee=`date +"%Y-%m-%d %H:%M"`
echo "<h1>$site</h1>elkatz &copy | $datee">$tmp

num=`ls /starhome/igateprov/conf/Catalina/localhost/ |grep -v manager|wc -l`
echo "----------igateprov---($num)-------" >>$tmp
if [ -d /starhome/igateprov/work/Catalina/localhost/MicroStrategy ];then echo "https://$mng:8443/MicroStrategy/servlet/mstrWeb"  >>$tmp ;fi
for i in `ls /starhome/igateprov/conf/Catalina/localhost/ |grep -v manager`
        do
                echo "https://$mng:8443/$i" |rev |cut -c 5- |rev >>$tmp
        done
port=8444

if [ -d  /starhome/igprov/ ] ;then
echo " There are also bases in this provisioning, going to fetch"
sleep 1

for g in `ls /starhome/igprov/ |sort`
        do
                num=`ls /starhome/igprov/$g/conf/Catalina/localhost/ |grep -v manager|wc -l`
                echo "------------$g---($num)---------" >>$tmp
                if [ -d /starhome/igprov/$g/work/Catalina/localhost/MicroStrategy ];then echo "https://$mng:$port/MicroStrategy/servlet/mstrWeb" >>$tmp ;fi
                for i in `ls /starhome/igprov/$g/conf/Catalina/localhost/ |grep -v manager`
                        do
                                echo "https://$mng:$port/$i"|rev |cut -c 5- |rev >>$tmp

                        done
                port=`echo $port+1|bc`
        done
fi

awk '
BEGIN{print "<html>\n<head>\n<title>Elik URL Page</title>\n<style>\ntable border-collapse:collapse;\n}\n</style>\n</head>\n<body>\n<table width="400">"
    }
    {print "<tr>"
    for(i=1;i<=NF;i++) if($i ~/http/)
        print "<a href="$i" target=""_blank"">"$i"</a>"
else
        print $i
    print "</tr> <br />"
    }
    END{
    print "\n</table>\n</Body>\n</html>\n"
    }' $tmp > $page