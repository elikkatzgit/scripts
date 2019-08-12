#!/bin/bash
#WhiteSource - Elik Katz

if [ $# -ne 1 ]; then
        echo " Run like this: ./projectName2projrctId.sh {apikey} "
        exit 1
else
		apikey=$1
        echo " Punch in the project name to search " ; read p_name
        curl -s -H "Content-Type: application/json" https://saas.whitesourcesoftware.com/api -d '{"requestType" : "getOrganizationProjectVitals","orgToken" : '"$apikey"'}' |sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' |grep -B1 "$p_name" |tac
fi
