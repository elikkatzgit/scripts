./gctload -x
tput blink ;echo "restarting SPU...";tput sgr0
cur_day=$(date +"%Y-%m-%d-");
cur_hour=$(date +"%H-%M");
#echo "compressing log files..."
tar -czf s7_log.$cur_day$cur_hour.tgz ./logs/*
echo "s7_log.$cur_day$cur_hour.tgz created."
#echo "purging log files..."
rm -f ./logs/*.log ./logs/*.txt
#echo "log files purged."
num_of_files=$(ls -ltr | grep -c "s7_log.*.tgz");
#echo "found $num_of_files compressed archives."
if [ "$num_of_files" -ge 6 ]; then
echo "deleting old log file: $(ls -1tr s7_log.*.tgz | head -1)..."
rm -f $(ls -1tr s7_log.* | head -1)
#echo "Old log files deleted."
fi
#echo "preparing to restart SPU..."
#sleep 1s
#tput blink ;echo "restarting SPU...";tput sgr0
./gctload &
sleep 2s
tput bold ; echo "Restart Completed" ; tput sgr0