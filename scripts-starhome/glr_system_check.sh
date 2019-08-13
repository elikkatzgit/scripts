#!/bin/bash
for i in `ll /starhome/srm/ |grep C71_ |awk  '{print $9}'` ; do NETWORK=$i; done
GLR_DIR=/starhome/srm/$NETWORK/glr/cdr
CORE_DIR=/starhome/iu/core/
LOG_FILE=/starhome/iu/workarea/system_check/Check_system_status.log_$(date +%Y%m%d_%H)
DATE=`date -d '1 hour ago' +"%Y/%m/%d %H"`
date=`date +"%m%d"`
date1=`date +"%Y%m%d"`
DISK=`df -kh | grep starhome`
sec_in_hour=3600
HOSTNAME=`hostname`
ULTICOM_LOG=/software/omni/target/$HOSTNAME/tmp/Event.225.txt.$date*
COUNTERS_DIR=/starhome/srm/$NETWORK/glr/counters
num1=0
num2=0
#num3=0
#num4=0
threshold=80

cd $GLR_DIR
#GSM
NUMBER_OF_FIRST_UL=`cat *M.tdr* |grep "$DATE"  |grep FIRST  |wc -l`
NUMBER_OF_FIRST_UL_WITHOUT_RELAY=`cat *M.tdr* |grep "$DATE"  |grep FIRST  |grep -v 5,2,U |wc -l`
NUMBER_OF_SUCCESSFUL_FIRST_UL=`cat *M.tdr* |grep "$DATE"  |grep FIRST |grep 1,2,U |wc -l`
NUMBER_OF_STEER_FIRST_UL=`cat *M.tdr* |grep "$DATE"  |grep FIRST |grep 0,2,U |wc -l`
NUMBER_OF_SystemFailure_FIRST_UL=`cat *M.tdr* |grep "$DATE"  |grep FIRST |grep 4,2,U |wc -l`
NUMBER_OF_REALYED_FIRST_UL=`cat *M.tdr* |grep "$DATE"  |grep FIRST |grep 5,2,U |wc -l`
NUMBER_OF_ABORT_FIRST_UL=`cat *M.tdr* |grep "$DATE"  |grep FIRST  |grep ABORT |wc -l`
NUMBER_OF_SECOND_UL=`cat *M.tdr* |grep "$DATE"  |grep SECOND |wc -l`
NUMBER_OF_SUCCESSFUL_SECOND_UL=`cat *M.tdr* |grep "$DATE"  |grep SECOND |grep 1,2,U |wc -l`
NUMBER_OF_SUCCESSFUL_SECOND_UL_ISD_SA=`cat *M.tdr* |grep "$DATE"  |grep SECOND |grep 1,514, |wc -l`
NUMBER_OF_SUCCESSFUL_SECOND_UL_READY_FOR_SM=`cat *M.tdr* |grep "$DATE"  |grep SECOND |grep 1,66, |wc -l`
NUMBER_OF_MT_SMS=`cat *M.tdr* |grep "$DATE"  |grep MT_FSM |wc -l`
NUMBER_OF_SUCCESSFUL_MT_SMS=`cat *M.tdr* |grep "$DATE"  |grep MT_FSM |awk -F\, '$27=='1' {print ;}'|wc -l`
NUMBER_OF_UNSUCCESSFUL_MT_SMS=`cat *M.tdr* |grep "$DATE"  |grep MT_FSM |grep -v APPLICATION_CONTEXT_NOT_SUPPORTED |grep -v ABSENT |awk -F\, '$27!='1' {print ;}'|wc -l`
FIRST_UL_ABORT_RATE=`echo "scale=2; $NUMBER_OF_ABORT_FIRST_UL * 100 / $NUMBER_OF_FIRST_UL" | bc | awk '{printf "%.2f", $0}'`

#GPRS
NUMBER_OF_FIRST_GPRS_UL=`cat *GPRS.tdr* |grep "$DATE"  |grep FIRST  |wc -l`
NUMBER_OF_FIRST_GPRS_UL_WITHOUT_RELAY=`cat *GPRS.tdr* |grep "$DATE"  |grep FIRST  |grep -v 5,23,U |wc -l`
NUMBER_OF_SUCCESSFUL_FIRST_GPRS_UL=`cat *GPRS.tdr* |grep "$DATE"  |grep FIRST |grep 1,23,U |wc -l`
NUMBER_OF_STEER_FIRST_GPRS_UL=`cat *GPRS.tdr* |grep "$DATE"  |grep FIRST |grep 0,23,U |wc -l`
NUMBER_OF_SystemFailure_FIRST_GPRS_UL=`cat *GPRS.tdr* |grep "$DATE"  |grep FIRST |grep 4,23,U |wc -l`
NUMBER_OF_REALYED_FIRST_GPRS_UL=`cat *GPRS.tdr* |grep "$DATE"  |grep FIRST |grep 5,23,U |wc -l`
NUMBER_OF_ABORT_FIRST_GPRS_UL=`cat *GPRS.tdr* |grep "$DATE"  |grep FIRST  |grep ABORT |wc -l`
NUMBER_OF_SECOND_GPRS_UL=`cat *GPRS.tdr* |grep "$DATE"  |grep SECOND |wc -l`
NUMBER_OF_SUCCESSFUL_SECOND_GPRS_UL=`cat *GPRS.tdr* |grep "$DATE"  |grep SECOND |grep 1,23,U |wc -l`
GPRS_FIRST_UL_ABORT_RATE=`echo "scale=2; $NUMBER_OF_ABORT_FIRST_GPRS_UL * 100 / $NUMBER_OF_FIRST_GPRS_UL"  | bc | awk '{printf "%.2f", $0}'`
GPRS_SECOND_UL_SUCCESS_RATE=`echo "scale=2; $NUMBER_OF_SUCCESSFUL_SECOND_GPRS_UL * 100 / $NUMBER_OF_SECOND_GPRS_UL" | bc | awk '{printf "%.2f", $0}'`

cd $COUNTERS_DIR
#GSM
GSM_UL_COUNT=`cat *M.cntrs$date1* |grep 10124091 |grep "$DATE" |awk -F, '{print $6}'`
for i in $GSM_UL_COUNT ; do num1=$(( $i + $num1 )) ;done

#GPRS
GPRS_UL_COUNT=`cat *M_GPRS.cntrs$date1* |grep 10124093 |grep "$DATE" |awk -F, '{print $6}'`
for i in $GPRS_UL_COUNT ; do num2=$(( $i + $num2 )) ;done

#LTE
#NUMBER_OF_ULR_ATTEMPTS=`cat *M_GPRS.cntrs$date1* |grep 10124195 |grep "$DATE" |grep 316 |awk -F, '{print $6}'`
#NUMBER_OF_ULR_SUCCESS=`cat *M_GPRS.cntrs$date1* |grep 10124196 |grep "$DATE" |grep 316 |awk -F, '{print $6}'`
#for i in $NUMBER_OF_ULR_ATTEMPTS ; do num3=$(( $i + $num3 )) ;done
#for i in $NUMBER_OF_ULR_SUCCESS ; do num4=$(( $i + $num4 )) ;done

#UL_PER_SEC=`echo "scale=2; ($num1+$num2+$num3+$num4) / $sec_in_hour"  | bc | awk '{printf "%.2f", $0}'`
UL_PER_SEC=`echo "scale=2; ($num1+$num2) / $sec_in_hour"  | bc | awk '{printf "%.2f", $0}'`

cd $CORE_DIR
NUMBER_OF_CORE=`find -type f -mmin -60 |awk -F/ '{print $2}' | wc -l`
CORE=`find -type f -mmin -60 |awk -F/ '{print $2}'`

#ULTICOM
Links=`cat $ULTICOM_LOG |grep "has been deleted" | grep C77 |wc -l`
switchover=`cat $ULTICOM_LOG |grep C77 |grep registered |grep GLR_W1 |wc -l`

TEST=`echo "scale=2; ($NUMBER_OF_SUCCESSFUL_FIRST_UL + $NUMBER_OF_STEER_FIRST_UL ) * 100 / $NUMBER_OF_FIRST_UL_WITHOUT_RELAY" | bc | awk '{printf "%.2f", $0}'`
TEST1=`echo "scale=2; ($NUMBER_OF_SUCCESSFUL_SECOND_UL + $NUMBER_OF_SUCCESSFUL_SECOND_UL_ISD_SA + $NUMBER_OF_SUCCESSFUL_SECOND_UL_READY_FOR_SM) * 100 / $NUMBER_OF_SECOND_UL" |bc | awk '{printf "%.2f", $0}'`
TEST2=`echo "scale=2; ($NUMBER_OF_SUCCESSFUL_FIRST_GPRS_UL + $NUMBER_OF_STEER_FIRST_GPRS_UL) *100 / $NUMBER_OF_FIRST_GPRS_UL_WITHOUT_RELAY" |bc | awk '{printf "%.2f", $0}'`
TEST3=`echo "scale=2; $NUMBER_OF_SUCCESSFUL_SECOND_GPRS_UL * 100 / $NUMBER_OF_SECOND_GPRS_UL" | bc | awk '{printf "%.2f", $0}'`
#TEST4=`echo "scale=2; ($num2) * 100 / $num1" | bc | awk '{printf "%.2f", $0}'`
TESTinteger=`expr \( $NUMBER_OF_SUCCESSFUL_FIRST_UL + $NUMBER_OF_STEER_FIRST_UL \) \* 100 / $NUMBER_OF_FIRST_UL_WITHOUT_RELAY`
#echo $TEST
if [ $TESTinteger -le "50" ]; then
        echo
        echo
        echo "GSM FIRST UL success rate is to low, please check"
        echo
        echo
fi
TEST1integer=`expr \( $NUMBER_OF_SUCCESSFUL_SECOND_UL + $NUMBER_OF_SUCCESSFUL_SECOND_UL_ISD_SA + $NUMBER_OF_SUCCESSFUL_SECOND_UL_READY_FOR_SM \) \* 100 / $NUMBER_OF_SECOND_UL`
#echo $TEST1
if [ $TEST1integer -le "90" ]; then
        echo
        echo
        echo "GSM SECOND UL success rate is to low, please check"
        echo
        echo
fi
TEST2integer=`expr \( $NUMBER_OF_SUCCESSFUL_FIRST_GPRS_UL + $NUMBER_OF_STEER_FIRST_GPRS_UL \) \* 100 / $NUMBER_OF_FIRST_GPRS_UL_WITHOUT_RELAY`
#echo $TEST2
if [ $TEST2integer -le "50" ]; then
        echo
        echo
        echo "GPRS FIRST UL success rate is to low, please check"
        echo
        echo
fi
TEST3integer=`expr \( $NUMBER_OF_SUCCESSFUL_SECOND_GPRS_UL \) \* 100 / $NUMBER_OF_SECOND_GPRS_UL`
#echo $TEST3
if [ $TEST3integer -le "90" ]; then
        echo
        echo
        echo "GPRS SECOND UL success rate is to low, please check"
        echo
        echo
fi
#TEST4integer=`expr \( $num2 \) \* 100 / $num1`
#echo $TEST4
#if [ $TEST4integer -le "50" ]; then
#        echo
#        echo
#        echo "LTE ULR success rate is to low, please check"
#       echo
#       echo
#fi
echo `date` > $LOG_FILE
echo >>$LOG_FILE
echo "GSM_STATISTIC" >> $LOG_FILE
echo "NUMBER_OF_FIRST_UL = $NUMBER_OF_FIRST_UL" >> $LOG_FILE
echo "NUMBER_OF_SUCCESSFUL_FIRST_UL = $NUMBER_OF_SUCCESSFUL_FIRST_UL" >> $LOG_FILE
#echo "NUMBER_OF_STEER_FIRST_UL = $NUMBER_OF_STEER_FIRST_UL" >> $LOG_FILE
#echo "NUMBER_OF_SystemFailure_FIRST_UL = $NUMBER_OF_SystemFailure_FIRST_UL" >> $LOG_FILE
#echo "NUMBER_OF_REALYED_FIRST_UL = $NUMBER_OF_REALYED_FIRST_UL" >> $LOG_FILE
#echo "NUMBER_OF_ABORT_FIRST_UL = $NUMBER_OF_ABORT_FIRST_UL" >> $LOG_FILE
echo "NUMBER_OF_SECOND_UL = $NUMBER_OF_SECOND_UL" >> $LOG_FILE
echo "NUMBER_OF_SUCCESSFUL_SECOND_UL = $NUMBER_OF_SUCCESSFUL_SECOND_UL" >> $LOG_FILE
#echo "NUMBER_OF_MT_SMS = $NUMBER_OF_MT_SMS" >> $LOG_FILE
#echo "NUMBER_OF_SUCCESSFUL_MT_SMS = $NUMBER_OF_SUCCESSFUL_MT_SMS" >> $LOG_FILE
#echo "NUMBER_OF_UNSUCCESSFUL_MT_SMS = $NUMBER_OF_UNSUCCESSFUL_MT_SMS" >> $LOG_FILE
echo >> $LOG_FILE
echo "FIRST_UL_SUCCESS_RATE = $TEST%" >> $LOG_FILE
echo "FIRST_UL_ABORT_RATE = $FIRST_UL_ABORT_RATE%" >> $LOG_FILE
echo "SECOND_UL_SUCCESS_RATE = $TEST1%" >> $LOG_FILE
echo >> $LOG_FILE

echo "GPRS_STATISTIC" >> $LOG_FILE
echo "NUMBER_OF_FIRST_GPRS_UL = $NUMBER_OF_FIRST_GPRS_UL" >> $LOG_FILE
echo "NUMBER_OF_SUCCESSFUL_FIRST_GPRS_UL = $NUMBER_OF_SUCCESSFUL_FIRST_GPRS_UL" >> $LOG_FILE
#echo "NUMBER_OF_STEER_FIRST_GPRS_UL = $NUMBER_OF_STEER_FIRST_GPRS_UL" >> $LOG_FILE
#echo "NUMBER_OF_SystemFailure_FIRST_GPRS_UL = $NUMBER_OF_SystemFailure_FIRST_GPRS_UL" >> $LOG_FILE
#echo "NUMBER_OF_REALYED_FIRST_GPRS_UL = $NUMBER_OF_REALYED_FIRST_GPRS_UL" >> $LOG_FILE
#echo "NUMBER_OF_ABORT_FIRST_GPRS_UL = $NUMBER_OF_ABORT_FIRST_GPRS_UL" >> $LOG_FILE
echo "NUMBER_OF_SECOND_GPRS_UL = $NUMBER_OF_SECOND_GPRS_UL" >> $LOG_FILE
echo "NUMBER_OF_SUCCESSFUL_SECOND_GPRS_UL = $NUMBER_OF_SUCCESSFUL_SECOND_GPRS_UL" >> $LOG_FILE
echo >> $LOG_FILE
echo "GPRS_FIRST_UL_SUCCESS_RATE = $TEST2%" >> $LOG_FILE
echo "GPRS_FIRST_UL_ABORT_RATE = $GPRS_FIRST_UL_ABORT_RATE%" >> $LOG_FILE
echo "GPRS_SECOND_UL_SUCCESS_RATE = $TEST3%" >> $LOG_FILE
echo >> $LOG_FILE

#echo "LTE_STATISTIC" >> $LOG_FILE
#echo "NUMBER_OF_LTE_URL_ATTEMPTS = $num1" >> $LOG_FILE
#echo "NUMBER_OF_LTE_URL_SUCCESS = $num2" >> $LOG_FILE
#echo "LTE_ULR_SUCCESS_RATE = $TEST4" >> $LOG_FILE
#echo >> $LOG_FILE

if [[ $NUMBER_OF_CORE = 0 ]] ; then
   echo "CORE_FILE = No New Core"  >> $LOG_FILE
else
   echo "CORE_FILE = $CORE" >> $LOG_FILE
fi

ok=0
for i in `df -hP |grep -v Filesystem|awk '{print$5}' |awk -F\% '{print$1}'`
        do 
                if [ "$i" -gt "$threshold" ]
                        then 
                                ok=$(( $ok + 1 ))
                fi
        done

if [ $ok = "0" ]
        then 
                echo "File System = File system is OK"  >> $LOG_FILE
        else
                echo "File System = Please check File system" >> $LOG_FILE 
fi
#echo "DISK_SPACE" = $DISK >> $LOG_FILE
echo
echo "UL_PER_SEC = $UL_PER_SEC" >> $LOG_FILE

echo  >> $LOG_FILE
echo "ULTICOM" >> $LOG_FILE
echo "NUMBER_OF_TIME_LINKS_DEACTIVATED = $Links"  >> $LOG_FILE
echo "NUMBER_OF_TIME_SWITCHOVER_HAPPEN = $switchover"  >> $LOG_FILE

LIST=`find /starhome/iu/workarea/system_check/Check_system_status.log_* -mtime +7`
for i in $LIST; do rm $i; done