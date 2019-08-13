#!/bin/bash -x
#Powered by elkatz
(
datee=$(date +%Y-%m-%d-%H%M)
folder=/starhome/ftm/

export ORASH=/etc/sh/orash
export BAS_ORACLE_LIST=igt
export ORA_VER=1120
export ORACLE_SID=igt
export ORACLE_BASE=/software/oracle
export ORACLE_ENV_DEFINED=yes
export ORA_NLS33=/software/oracle/112/ocommon/nls/admin/data
export ORACLE_HOME=/software/oracle/112
export ORA_EXP=/backup/ora_exp

. /etc/sh/orash/oracle_login.sh igt

cd $folder

sqlplus -s ARG_CLARO_MOCOQ/ARG_CLARO_MOCOQ@igt @/starhome/ftm/select.sql

zip -m $datee-SMM_CUSTOMER_PROFILE.zip SMM_CUSTOMER_PROFILE.csv

#sftp -C starhome@10.92.49.18 <<EOF
#lcd $folder
#cd /exa1nfs/desa/prueba RAF
#mput SMM_CUSTOMER_PROFILE.zip
#EOF

) | tee -a /starhome/ftm/ftm.log