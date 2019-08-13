#!/bin/bash
# powered by elkatz

tdr1="deu-tel-td1 deu-tel-td2 deu-tel-td3"
tdr2="deu-tel-td4 deu-tel-td5 deu-tel-td6"

if [ $# -eq 0 ]; then
    echo "please use one of the following arguments:"
    echo " version | master | wrapper | alarmer | status | stop | start | restart "
    exit 1

else

case "$1" in
        version)
                for i in $tdr1
                        do
                                tput bold ;echo $i ; tput sgr0
                                grep -i version /starhome/igate/$i/logs/wrapper.log |tail -6 |cut -c 42-
                        done
                for i in $tdr2
                        do
                                tput bold ;echo $i ; tput sgr0
                                ssh -q deu-via-5-tdr-2 "grep -i version /starhome/igate/$i/logs/wrapper.log|tail -6|cut -c 42-"
                        done
        ;;
        wrapper)
                for i in $tdr1
                        do
                                tput bold ;echo $i ; tput sgr0
                                tail -1 /starhome/igate/$i/logs/wrapper.log
                        done
                for i in $tdr2
                        do
                                tput bold ;echo $i ; tput sgr0
                                ssh -q deu-via-5-tdr-2 "tail -1 /starhome/igate/$i/logs/wrapper.log"
                        done
        ;;
        alarmer)
                for i in $tdr1
                        do
                                tput bold ;echo $i ; tput sgr0
                                tail -1 /starhome/igate/$i/logs/alarmer.txt
                        done
                for i in $tdr2
                        do
                                tput bold ;echo $i ; tput sgr0
                                ssh -q deu-via-5-tdr-2 "tail -1 /starhome/igate/$i/logs/alarmer.txt"
                        done
        ;;
        master)
                sqlplus -s DEU_TELFO_SHTDR/DEU_TELFO_PASSW@igt > .tmp << EOF
                set echo off
                set feedback off
                set pagesize 0
                select  
                case jvm_id
                when 2 then 'deu-tel-td1'
                when 3 then 'deu-tel-td2' 
                when 4 then 'deu-tel-td3' 
                when 5 then 'deu-tel-td4' 
                when 6 then 'deu-tel-td5' 
                when 7 then 'deu-tel-td6'
                end || ' (' ||
                process_type || ',' ||
                process_version || ') --> ' ||
                process_status 
                from CGA_PROCESSES;
EOF
cat .tmp
        ;;
        *)
                action="$1"
                for i in $tdr1
                        do
                                tput bold ;echo $i ; tput sgr0
                                cd /starhome/igate/$i/bin ; ./ig2 $action
                        done
                for i in $tdr2
                        do
                                 tput bold ;echo $i ; tput sgr0
                                ssh -q deu-via-5-tdr-2 "cd /starhome/igate/$i/bin; ./ig2 $action"
                        done
esac
fi