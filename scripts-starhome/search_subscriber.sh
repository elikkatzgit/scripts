
#!/bin/bash
clear
echo "----------------------------------------"
echo "ENTER DATE OF CALL  example: 23.07.14 " ; read datee
echo "----------------------------------------"
echo "ENTER SUBSCRIBER ID " ; read msisdn
 /usr/bin/ssh 10.0.156.122 "uname -n; grep -h $msisdn /starhome/igate/deu-o2q-sx1/data/sparx_* |grep $datee ">tmp
 /usr/bin/ssh 10.0.156.123 "uname -n; grep -h $msisdn /starhome/igate/deu-o2q-sx2/data/sparx_* |grep $datee ">>tmp
 /usr/bin/ssh 10.0.156.124 "uname -n; grep -h $msisdn /starhome/igate/deu-o2q-sx3/data/sparx_* |grep $datee ">>tmp
clear
cat tmp
rm tmp
~
~