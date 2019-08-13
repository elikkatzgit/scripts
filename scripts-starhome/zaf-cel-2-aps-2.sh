#!/bin/bash
#powered by elkatz

ftp_user=starhome
ip=41.156.64.188
feed_dir=/starhome/igate/zaf-cel-nro/data/
file_prefix=nro_sdr_1.`date +"%Y-%m-%d-%H" --date="1 hour ago"`

datee=`date +"%Y-%m-%d %H:%M"`
log=/starhome/ftm/$ftp_user.log

cd $feed_dir
gzip $file_prefix*

if [ "$?" -eq 0 ]; then
echo "$datee - File [ $file_prefix ] zipped and going to be delivered"  >> $log
sftp -C $ftp_user@$ip <<EOF
lcd $feed_dir/
mput $file_prefix*
EOF
if [ "$?" -eq 0 ]; then
echo "$datee - File [ $file_prefix ] delivered successfuly to $ip "  >> $log
else
echo "$datee - ERROR - Unable send file to $ip" >> $log
fi
else
echo "$datee - ERROR - Unable to zip and send file" >> $log
fi