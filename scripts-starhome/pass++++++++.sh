#!/bin/bash
# Powered by elkatz

ls /starhome/igprov/*/conf/Catalina/localhost/* |rev|cut -c 5-|rev |awk -F\/ '{print$8}' |grep -v manager |grep -v subsc |sort

echo "+-----------------------------+"
echo "|Provisioning Password manager|"
echo "|   Centrlized version 4.0    |"
echo "|     Powered by  elkatz      |"
echo "+-----------------------------+"
echo "choose url to reset password (copy - paste) from above list" ; read url

ls -ltr /starhome/igprov/*/conf/Catalina/localhost/$url.xml> /dev/null 2>&1

if [ "$?" -eq 0 ]; then


sleep 1
user=`grep user /starhome/igprov/*/conf/Catalina/localhost/$url.xml |grep -v report |awk -F\" '{print$2}'`
pass=`grep user /starhome/igprov/*/conf/Catalina/localhost/$url.xml |grep -v report |awk -F\" '{print$4}'`



echo ""
echo "+-----------+"
echo "| Thank you |"
echo "+-----------+"
sleep 1
echo ""
echo " What do you want me to do with $url ? "
echo "+------------------------------------------+"
echo "| 1] reset support Password to support     |"
echo "| 2] reset gsoc password to Starhome1      |"
echo "| 3] reset Admin password to administrator |"
echo "+------------------------------------------+"
echo "Enter your choice";read choose

if [ "$choose" -eq "1" ] 
then
sqlplus -s $user/$pass@kep01 > gsoc.pass << EOF
set echo off
set feedback off
set pagesize 0
update PROV_USERS set password='434990c8a25d2be94863561ae98bd682',TS_LAST_MODIFIED=sysdate+999,TS_LAST_PASSWORD_CHANGE=sysdate+999,USER_STATUS=1,INITIAL_PASSWORD_FLAG=0 where username='support';
delete PROV_PASSWORD_HISTORY where user_id =(select user_id from prov_users where username='support');
update prov_users set user_status='1' where username like 'support';
select password from prov_users where username='support';
EOF
echo "support password was reset to support"
else

if [ "$choose" -eq "2" ]
then
sqlplus -s $user/$pass@kep01 > gsoc.pass << EOF
set echo off
set feedback off
set pagesize 0
update PROV_USERS set password='8b4e113994dca77ee126f978f903538',TS_LAST_MODIFIED=sysdate+999,TS_LAST_PASSWORD_CHANGE=sysdate+999,USER_STATUS=1,INITIAL_PASSWORD_FLAG=0 where username='gsoc';
delete PROV_PASSWORD_HISTORY where user_id =(select user_id from prov_users where username='gsoc');
update prov_users set user_status='1' where username like 'gsoc';

EOF
echo "gsoc password has been reset to Starhome1"
rm gsoc.pass
else

if [ "$choose" -eq "3" ] ;
then
sqlplus -s $user/$pass@kep01 > gsoc.pass << EOF
set echo off
set feedback off
set pagesize 0
update PROV_USERS set password='20ceb26807d6bf99fd6f4f0d1ca54d4',TS_LAST_MODIFIED=sysdate+999,TS_LAST_PASSWORD_CHANGE=sysdate+999,USER_STATUS=1,INITIAL_PASSWORD_FLAG=0 where username='Admin';
delete PROV_PASSWORD_HISTORY where user_id =(select user_id from prov_users where username='Admin');
update prov_users set user_status='1' where username like 'Admin';
EOF
echo "Admin password has been reset to administrator"
rm gsoc.pass

        fi
                fi
                        fi

else
sleep 1
echo "Hummm......"
sleep 2
echo "+-------------------------------------+"
echo "|Cant find the URL.. going to exit....|"
echo "+-------------------------------------+"
sleep 1
fi