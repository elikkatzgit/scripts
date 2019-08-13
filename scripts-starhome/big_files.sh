echo "files on C users desktops "
find /cygdrive/c/Documents\ and\ Settings/*/Desktop/ -type f -size +1001k -mtime +7 \( -name *.csv -o -name *.gz -o -name *.zip -o -name *.log  -o -name *.DMP  -o -name *.pcap  -o -name *.bz2 -o -name *.PCAP \)
echo "Versions on D older then 1 month"
find /cygdrive/d/users/* -type f -size +1001k -mtime +28 \( -name igate-install* -o -name prov-v* -o -name reporting_tool* -o -name clover-* \) -exec ls -l {} \;




find /cygdrive/d/users/* -type f -size +1001k -mtime +28 \( -name igate-install*.gz -o -name prov-v*.gz -o -name reporting_tool*.gz -o -name clover-*.gz \) -exec rm -rf {} \;

