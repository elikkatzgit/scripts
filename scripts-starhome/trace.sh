#!/bin/bash
# Powered by elkatz

user=`grep UserName VIP.INI|awk -F\= '{print$2}'`
pass=`grep Password VIP.INI|awk -F\= '{print$2}'`
db=`grep DataBaseName VIP.INI|awk -F\= '{print$2}'`

if [ "$1" == "check" ]; then
sqlplus -s $user/$pass@$db > .tmp << EOF
set echo off
set feedback off
set pagesize 0
select process_name from TRACE_FLAG where process_name ='$2';
EOF
cat.tmp

else

if [ "$1" == "open" ]; then
sqlplus -s $user/$pass@$db > .tmp << EOF
set echo off
set feedback off
set pagesize 0
update TRACE_FLAG set is_enabled='1' where process_name ='$2';
update TRACE_FLAG set trace_value='-1' where process_name ='$2';
select process_name from TRACE_FLAG where process_name ='$2';
EOF
echo "$2 trace was opened"

else

if [ "$1" == "close" ]; then
sqlplus -s $user/$pass@$db > .tmp << EOF
set echo off
set feedback off
set pagesize 0
update TRACE_FLAG set is_enabled='0' where process_name ='$2';
select process_name from TRACE_FLAG where process_name ='$2';
EOF
echo "$2 trace was closed"

else
        echo "run it as trace.sh {open|close|check} process_name"
fi
fi
