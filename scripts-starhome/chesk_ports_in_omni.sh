for i in `ps -ef |grep CAP|grep -v grep |awk '{print$2}'`;do echo -ne `ps -ef |grep $i|grep -v grep|awk '{print$2,$10}'`; echo -ne " -->  " ;netstat -nap 2>/dev/null |grep udp|grep $i|awk '{print$4}'|awk -F\: '{print$2}';done |awk '{print$4" --> "$2,"("$1")"}' |sort -n