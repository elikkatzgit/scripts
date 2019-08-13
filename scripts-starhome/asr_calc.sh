#!/bin/bash
res=`grep $(date +%Y-%m-%d -d yesterday) rus-bee-moc_counter.* |grep Services_InNETO_Number_Of_SA_ISD_Outgoing_Resp_Success |awk -F\, '{ sum += $7} END { print sum }'`
req=`grep $(date +%Y-%m-%d -d yesterday) rus-bee-moc_counter.* |grep Services_InNETO_Number_Of_SA_ISD_Outgoing_Req_Sent |awk -F\, '{ sum += $7} END { print sum }'`
echo -ne "$(date +%Y-%m-%d -d yesterday) --> "
echo "scale=2; $res*100/$req" | bc