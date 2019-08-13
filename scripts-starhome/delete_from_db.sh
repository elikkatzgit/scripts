#!/bin/bash
#subscriber finder by Elik Katz
echo " "
echo "Enter MSISDN" ;read msisdn
echo " "
echo "Searching"
sleep 1
echo -ne '#####                     (33%)\r'
sleep 1
echo "Number of records with this MSISDN"
sqlplus -s jpn_sbmqq_sparx/jpn_sbmqq_sparx@igt > tmp.tmp << EOF
select count(*) from sga_w_subscriber where msisdn= '$msisdn';
EOF
cat tmp.tmp
rm tmp.tmp

echo "DO YOU WANT TO DELETE THIS MSISDN?" ; read -t 10 -p "Press CTRL-C to Cancel, ENTER to continue or just wait 10 seconds"
sqlplus -s jpn_sbmqq_sparx/jpn_sbmqq_sparx@igt > tmp.tmp << EOF
delete sga_w_subscriber where msisdn= '$msisdn';
EOF
echo " ----------> Deleted, going to verify..."
echo "Number of records with this MSISDN"
sqlplus -s jpn_sbmqq_sparx/jpn_sbmqq_sparx@igt > tmp.tmp << EOF
select count(*) from sga_w_subscriber where msisdn= '$msisdn';
EOF
cat tmp.tmp
rm tmp.tmp
