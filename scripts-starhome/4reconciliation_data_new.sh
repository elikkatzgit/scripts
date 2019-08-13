#!/bin/bash
# reconciliation_data.sh
# Reconciliation script between APS01 & APS02
# This Script will compare ig1 - sort INI Files &
# ig2 - xml files between each service installed
cd /starhome/support/
reconcile_output=/starhome/support/reconcile_test.dat
cluster_type=`sudo getaclu`
if [ $cluster_type = 'VCS' ];then
cluster_node1=`hostname`
cluster_node2=`sudo hastatus -sum |head -20 |grep "^A" |grep "RUNNING" |awk '{print $2}' |grep -v $cluster_node1 |head -1`
cd /starhome/
if [ -d !=/starhome/support/reconcile ];then
mkdir /starhome/support
mkdir /starhome/support/reconcile
fi
Ig1_cluster_list=`ls -rth /starhome/igate/|egrep -v 'ipn|irm|sfi|sx1|sx2'`
Ig2_cluster_list=`ls -rth /starhome/igate/|egrep -v 'sp1|sp2|spx|sx1|sx2'`
Ig1_INI_list=`ls -rth /starhome/igate/*/ig1/*.INI |grep -v "[A-Z][A-Z][A-Z]-[A-Z]*" |awk -F "/" '{print $NF}' |grep -v [a-z] |grep -v "-"|sort |uniq`
Ig2_conf_flie_list=`ls -larth /starhome/igate/*/conf/*.conf /starhome/igate/*/conf/*.xml /starhome/igate/*/conf/*.properties /starhome/igate/*/conf/iu_profile|grep  -v "^d" |grep -v log4j|grep -v "lic_" |grep -v redundancy.xml |grep "^-r" |awk -F "/" '{print $NF}'|sort |uniq`
echo "IG1 configuration file(.INI) difference"  > $reconcile_output
echo "##################################################"  >> $reconcile_output

{

for i in $Ig1_cluster_list
        do
                        for j in $Ig1_INI_list
                                do
                                                count=0
                                                if [ -f /starhome/igate/$i/ig1/$j ];then
                                                        scp -q ${cluster_node2}:/starhome/igate/$i/ig1/$j /starhome/support/reconcile/
                                                        if [ -f /starhome/support/reconcile/$j ];then
                                                                count=`sdiff -s /starhome/igate/$i/ig1/$j /starhome/support/reconcile/$j |wc -l`
                                                        fi
                                                        if [ $count -gt 0 ];then
                                                                echo "IG1 Conf: difference count in $i - $j = $count"  >> $reconcile_output
                                                        fi
                                                fi
if [ -f /starhome/support/reconcile/$j ];then
                                                        rm /starhome/support/reconcile/$j
fi
                                done
        done
}
echo "###############################################" >> $reconcile_output
echo " " >> $reconcile_output
echo "IG2 configuration file difference"  >> $reconcile_output
echo "##################################################"  >> $reconcile_output

{

for i in $Ig2_cluster_list
        do
                        for j in $Ig2_conf_flie_list
                                do
                                                count=0
                                                if [ -f /starhome/igate/$i/conf/$j ];then
                                                        scp -q ${cluster_node2}:/starhome/igate/$i/conf/$j /starhome/support/reconcile/
                                                        if [ -f /starhome/support/reconcile/$j ];then
                                                                count=`sdiff -s /starhome/igate/$i/conf/$j /starhome/support/reconcile/$j |wc -l`
                                                        fi
                                                        if [ $count -gt 0 ];then
                                                                echo "IG2 Conf : difference count in $i - $j = $count"  >> $reconcile_output
                                                        fi
                                                fi
if [ -f /starhome/support/reconcile/$j ];then
                                                        rm /starhome/support/reconcile/$j
fi                                
done
        done
}
echo "##################################################"  >> $reconcile_output
cat $reconcile_output
#rm $reconcile_output
else
	echo "Script written for only Veritas cluster. It is cluster of type : $cluster_type"
fi
