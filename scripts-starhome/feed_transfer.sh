#!/bin/bash
#powered by elkatz

ftp_user=ITASPN
ip=193.108.190.136
feed_dir=/starhome/igate/probe/outgoing/
file_prefix=TLS

datee=`date +"%Y-%m-%d %H:%M"`
log=/starhome/ftm/$ftp_user.log
if [ ! -d $feed_dir/tmp ]; then
mkdir $feed_dir/tmp
fi

mv $feed_dir/$file_prefix* $feed_dir/tmp/

sftp -C $ftp_user@$ip <<EOF
lcd $feed_dir/tmp/
cd incoming/
mput $file_prefix*
EOF

if [ "$?" -eq 0 ]; then
rm $feed_dir/tmp/$file_prefix*
echo "$datee - Files delivered and removed"  >> $log
else
echo "$datee - ERROR - Unable to deliver files" >> $log
fi
