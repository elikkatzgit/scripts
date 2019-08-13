#!/bin/bash

datee=`date +"%y%m%d"`

if [ ! -d "/starhome/data_export/mlt-vod/sfi" ]; then
mkdir /starhome/data_export/mlt-vod/sfi
fi
if [ ! -d "/starhome/data_export/mlt-vod/sfi/archive/" ]; then
mkdir /starhome/data_export/mlt-vod/sfi/archive/
fi


sftp -oPort=14022 shome@195.232.229.26:/data/home/shome/INFO_TEXT_PUSH/inwork/ <<EOF
lcd /starhome/data_export/mlt-vod/sfi
mget *$datee.txt

EOF

mv /starhome/data_export/mlt-vod/sfi/BLACKLIST*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_BLACKLIST.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_BSC*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_PRM*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTTYHTARPRM.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTTYHTARED.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt
mv /starhome/data_export/mlt-vod/sfi/POST_TYHTA_RED_*.txt /starhome/data_export/mlt-vod/sfi/Whitelist_POSTYHTAREDBSC.txt



scp /starhome/data_export/mlt-vod/sfi/Whitelist_*.txt iu@10.105.10.85:/starhome/igate/mlt-vod-sfi/data/Services/MLT_VODAF_SPARX/work


if [ "$?" -eq 0 ]; then
cd /starhome/data_export/mlt-vod/sfi/
zip -m sfi_files_$datee.zip *.txt
mv /starhome/data_export/mlt-vod/sfi/*.zip /starhome/data_export/mlt-vod/sfi/archive
fi
