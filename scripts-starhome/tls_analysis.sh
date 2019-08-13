#!/bin/bash
#elkatz

prefix=TLS

num_of_files=`ls |grep $prefix |wc -l`
num_of_records=`cat $prefix* |wc -l`
num_of_ul=`cat $prefix* |grep "OPCODE=2;" |wc -l`
num_of_gprs_ul=`cat $prefix* |grep "OPCODE=23;" |wc -l`
num_of_cl=`cat $prefix* |grep "OPCODE=3;" |wc -l`
num_of_no_msisdn=`cat $prefix* |grep "OPCODE=2;" |grep "MSISDN=;" |wc -l`
num_of_no_imsi=`cat $prefix* |grep "OPCODE=2;" |grep "IMSI=;" |wc -l`
num_of_map_err=`cat $prefix* |grep "OPCODE=2;" |grep "MSISDN=;" |grep -v "MAP_ERR=-1" |wc -l`
num_of_no_msisdn_no_map_err=`cat $prefix* |grep "OPCODE=2;" |grep "MSISDN=;" |grep "MAP_ERR=-1" |wc -l`


echo "Number of files                                   [ $num_of_files ] "
echo "Number of records                                 [ $num_of_records ] "
echo -ne "Number of UL (opcode=2)                       [ $num_of_ul ] "        ; echo "scale=2; $num_of_ul * 100 / $num_of_records" | bc | awk '{printf "%.2f", $0}' ; echo " %"
echo -ne "Number of CNL(opcode=2)                       [ $num_of_cl ] "        ; echo "scale=2; $num_of_cl * 100 / $num_of_records" | bc | awk '{printf "%.2f", $0}' ; echo " %"
echo -ne "Number of GPRS-UL(opcode=23)                  [ $num_of_gprs_ul ] "        ; echo "scale=2; $num_of_gprs_ul * 100 / $num_of_records" | bc | awk '{printf "%.2f", $0}' ; echo " %"
echo -ne "Number of no MSISDN in UL records             [ $num_of_no_msisdn ] " ; echo "scale=2; $num_of_no_msisdn * 100 / $num_of_ul" | bc | awk '{printf "%.2f", $0}'  ; echo " %"
echo -ne "Number of no IMSI in UL records               [ $num_of_no_imsi ] " ; echo "scale=2; $num_of_no_imsi * 100 / $num_of_ul" | bc | awk '{printf "%.2f", $0}'  ; echo " %"
echo -ne "Number of MAP ERR in IL records               [ $num_of_map_err ] " ; echo "scale=2; $num_of_map_err * 100 / $num_of_ul" | bc | awk '{printf "%.2f", $0}'  ; echo " %"
echo -ne "Number of no MSISDN, No MAP ERR in UL records [ $num_of_no_msisdn_no_map_err ] " ;  echo "scale=2; $num_of_no_msisdn_no_map_err * 100 / $num_of_ul" | bc | awk '{printf "%.2f", $0}'  ; echo " % <-- Indicate missing traffic"