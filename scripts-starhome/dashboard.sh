#!/bin/bash
#elkatz

file=dashboard.html
output_file=/starhome/support/$file

echo " Telefonica Germany | Updated: $(date '+%Y-%m-%d %H:%M') " > $output_file

cat >> $output_file <<EOL

<!DOCTYPE html>
<!-- saved from url=(0046)http://visjs.org/examples/network/03_images.html -->
<html><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
  <title>Dashboard</title>
  <style type="text/css">
    html, body {
      font: 10pt arial;
      padding: 0;
      margin: 0;
      width: 100%;
      height: 100%;
    }
    #mynetwork {
      width: 100%;
      height: 100%;
    }
  </style>

  <script type="text/javascript" src="vis-4.21.0-med/dist/vis.js"></script>
  <link href="vis-4.21.0-med/dist/vis-network.min.css" rel="stylesheet" type="text/css" />
  <script type="text/javascript">
    var nodes = null;
    var edges = null;
    var network = null;
    var LENGTH_MAIN = 350,
        LENGTH_SERVER = 150,
        LENGTH_SUB = 50,
        WIDTH_SCALE = 2,
        GREEN = 'green',
        RED = '#C5000B',
        ORANGE = 'orange',
    //GRAY = '#666666',
        GRAY = 'gray',
        BLACK = '#2B1B17';

    // Called when the Visualization API is loaded.
    function draw() {
      // Create a data table with nodes.
      nodes = [];
      // Create a data table with links.
      edges = [];

          //SERVICE LEVEL
  //      nodes.push({id: 1, label: 'SPARX SERVICE', group: 'SERVICE_HOK', value: 10 , physics:false});
      //nodes.push({id: 2, label: '192.168.0.2', group: 'SERVICE', value: 8});
      //nodes.push({id: 3, label: '192.168.0.3', group: 'SERVICE', value: 6});
      //edges.push({from: 1, to: 2, length: LENGTH_MAIN, width: WIDTH_SCALE * 6, label: '0.71 mbps'});
      //edges.push({from: 1, to: 3, length: LENGTH_MAIN, width: WIDTH_SCALE * 4, label: '0.55 mbps'});
EOL

########################################## APP #####################################################

SX=1
id=10
app="10.0.156.230:61616 10.0.156.122:61616 10.0.156.123:61616 10.0.156.124:61616 10.0.156.230:61618"
for i in `echo $app`
        do
                ip=`echo $i |awk -F\: '{print$1}'`
                port=`echo $i |awk -F\: '{print$2}'`
                timeout 2 bash -c "</dev/tcp/$ip/$port"
                if [ $? = 0 ] ;then
                        status="APP_OK"
                else
                        status="APP_NOK"
                fi
        echo "nodes.push({id: $id , label: 'SX$SX', group: '$status', value: 10}); edges.push({from: 1, to: $id, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '$ip $port'});" >> $output_file
                SX=$(( $SX + 1 ))
                id=$(( $id + 1 ))
        done

########################################## TDR #####################################################

TD=1
id=701
bad=0
app="10.128.156.177:61618 10.128.156.177:61619 10.128.156.177:61620 10.128.156.178:61621 10.128.156.178:61622 10.128.156.178:61623 10.128.156.177:61624 10.128.156.178:61625 "
for i in `echo $app`
        do
                ip=`echo $i |awk -F\: '{print$1}'`
                port=`echo $i |awk -F\: '{print$2}'`
                timeout 2 bash -c "</dev/tcp/$ip/$port"
                if [ $? = 0 ] ;then
                        status="APP_OK"
                else
                        status="APP_NOK"
                        bad=$(( $bad + 1 ))
                fi
        echo "nodes.push({id: $id , label: 'TD$TD', group: '$status', value: 10}); edges.push({from: 700, to: $id, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '$ip $port'});" >> $output_file
                TD=$(( $TD + 1 ))
                id=$(( $id + 1 ))
        done

if [ $bad = 0 ];then
     status=PROV_OK
elif [ $bad = 8 ] ;then
    status=PROV_NOK
else
    status=PROV_HOK
fi
echo "nodes.push({id: 700, label: 'SH Probe', group: '$status', value: 14});  edges.push({from: 1, to: 700, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: ''});"  >> $output_file

################################################ SFI APP ##############################################
id=25
ip=10.0.156.119
app=SFI
if [ `ping -c 1 $ip |grep "1 received" |wc -l` = 1 ] ;then
        status="APP_OK"
else
        status="APP_NOK"
fi
echo "nodes.push({id: $id , label: '$app', group: '$status', value: 14});  edges.push({from: 1, to: $id, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '$ip'});" >> $output_file

################################################ PEI ##############################################

id=15
ip=10.0.156.240
app=PEI

timeout 2 bash -c "</dev/tcp/82.113.112.35/9443"
if [ $? != 0 ];then
     ldap_status=INT_NOK
else
    ldap_status=INT_OK
fi
echo "nodes.push({id: 406, label: 'SOA GW', group: '$ldap_status', value: 300}); edges.push({from: $id, to: 406, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '82.113.112.35 9443'});" >> $output_file

if [ `ping -c 1 $ip |grep "1 received" |wc -l` = 1 ] ;then
        status="APP_OK"
else
        status="APP_NOK"
fi
echo "nodes.push({id: $id , label: '$app', group: '$status', value: 14});  edges.push({from: 1, to: $id, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '$ip'});" >> $output_file

############################################# SMM ###################################################

id=601
bad=0

list="10.31.171.133:16611 10.31.159.133:16611 10.31.167.133:16611"
for i in `echo $list`
        do
                ip=`echo $i |awk -F\: '{print$1}'`
                port=`echo $i |awk -F\: '{print$2}'`
                timeout 2 bash -c "</dev/tcp/$ip/$port"
                if [ $? = 0 ] ;then
                        status="INT_OK"
                else
                        status="INT_NOK"
                        bad=$(( $bad + 1 ))
                fi
        echo "nodes.push({id: $id, label: 'LDAP', group: '$status', value: 300}); edges.push({from: 600, to: $id, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '$i'});" >> $output_file

                id=$(( $id + 1 ))
        done
if [ $bad = 0 ];then
     status=PROV_OK
elif [ $bad = 8 ] ;then
    status=PROV_NOK
else
    status=PROV_HOK
fi

id=600
ip=10.0.156.246
app=SMM

if [ `ping -c 1 $ip |grep "1 received" |wc -l` = 1 ] ;then
        status="APP_OK"
else
        status="APP_NOK"
fi

echo "nodes.push({id: $id , label: '$app', group: '$status', value: 14});  edges.push({from: 1, to: $id, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '$ip'});" >> $output_file

####################################################### DB ########################################

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
/software/oracle/112/bin/tnsping igt

if [ $? = 0 ] ;then
        status="DB_OK"
else
        status="DB_NOK"
fi

echo "nodes.push({id: 200, label: 'IGT DataBase', group: '$status', value: 200});  edges.push({from: 1, to: 200, length: 200, color: GRAY, width: WIDTH_SCALE * 1, label: '1521'});" >> $output_file

################################################## Tomcat ########################################

id=501
bad=0

for i in `ssh -q deu-via-5-mng-2 "ls /starhome/igateprov/work/Catalina/localhost|grep -v manager|grep -vw _"`
        do
                wget https://10.128.156.201:8443/$i --no-check-certificate
                        if [ $? = 0 ] ;then
                        status="PROV_OK"
                else
                        status="PROV_NOK"
                        bad=$(( $bad + 1 ))
                fi
                echo "nodes.push({id: $id, label: 'URL', group: '$status', value: 14});  edges.push({from: 500, to:  $id , length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '$i'});" >> $output_file
                id=$(( $id + 1 ))
        done

timeout 2 bash -c "</dev/tcp/10.128.156.201/8443"

if [ $? != 0 ];then
     status=PROV_NOK
elif [ $bad != 0 ] ;then
    status=PROV_HOK
else
    status=PROV_OK
fi
echo "nodes.push({id: 500, label: 'Tomcat', group: '$status', value: 14});  edges.push({from: 1, to: 500, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '8443'});"  >> $output_file


################################################### END ###########################################

cat >> $output_file <<EOL
         
         // INTERFACE LEVEL
nodes.push({id: 300, label: 'SMSC', group: 'INT_OK', value: 300}); edges.push({from: 10, to: 300, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '172.10.2.30:3333'});
nodes.push({id: 301, label: 'SMSC', group: 'INT_OK', value: 300}); edges.push({from: 10, to: 301, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '172.10.2.30:3366'});
nodes.push({id: 302, label: 'SMSC', group: 'INT_OK', value: 300}); edges.push({from: 11, to: 302, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '172.10.2.30:4444'});
nodes.push({id: 303, label: 'SMSC', group: 'INT_OK', value: 300}); edges.push({from: 11, to: 303, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '172.10.2.30:3355'});
nodes.push({id: 304, label: 'SMSC', group: 'INT_OK', value: 300}); edges.push({from: 12, to: 304, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '172.10.2.30:5555'});
nodes.push({id: 305, label: 'SMSC', group: 'INT_OK', value: 300}); edges.push({from: 12, to: 305, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '172.10.2.30:3355'});
nodes.push({id: 307, label: 'SMSC', group: 'INT_NOK', value: 300}); edges.push({from: 14, to: 307, length: LENGTH_SERVER, color: GRAY, width: WIDTH_SCALE * 1, label: '172.10.2.30:6666'});

nodes.push({id: 1, label: 'SPARX SERVICE', group: 'SERVICE_HOK', value: 10 , physics:false});

      // legend

      // create a network
      var container = document.getElementById('mynetwork');
      var data = {
        nodes: nodes,
        edges: edges
      };
      var options = {
        nodes: {
          scaling: {
            min: 16,
            max: 32
          }
        },
        edges: {
          color: GRAY,
          smooth: false
        },
        physics:{
          barnesHut:{gravitationalConstant:-30000},
          stabilization: {iterations:2500}
        },
        groups: {
          SERVICE: {
            shape: 'box',
            color: '#FFFFFF' // orange
          },
                SERVICE_OK: {
            shape: 'hexagon',
            color: "#109618" // green
          },
                SERVICE_NOK: {
            shape: 'hexagon',
            color: "#C5000B" // red
          },
                 SERVICE_HOK: {
            shape: 'circle',
            color: '#FF9900' // orange
          },
                 APP_OK: {
            shape: 'circle',
            color: "#109618" // green
          },
                APP_NOK: {
            shape: 'circle',
            color: "#C5000B" // red
          },
                 APP_HOK: {
            shape: 'circle',
            color: '#FF9900' // orange
          },
                  PROV_OK: {
            shape: 'circle',
            color: "#109618" // green
          },
                PROV_NOK: {
            shape: 'circle',
            color: "#C5000B" // red
          },
                 PROV_HOK: {
            shape: 'circle',
            color: '#FF9900' // orange
          },
                 INT_OK: {
            shape: 'circle',
            color: "#109618" // green
          },
                INT_NOK: {
            shape: 'circle',
            color: "#C5000B" // red
          },
                 INT_HOK: {
            shape: 'circle',
            color: '#FF9900' // orange
          },
                  DB: {
            shape: 'database',
            color: "#FFFFFF"
          },
                 DB_OK: {
            shape: 'database',
            color: "#109618" // green
          },
                DB_NOK: {
            shape: 'database',
            color: "#C5000B" // red
          },
                 DB_HOK: {
            shape: 'database',
            color: '#FF9900' // orange
          },
          desktop: {
            shape: 'circle',
            color: "#2B7CE9" // blue
          },
          mobile: {
            shape: 'circle',
            color: "#5A1E5C" // purple
          },
          server: {
            shape: 'box',
            color: "#C5000B" // red
          },
          internet: {
            shape: 'box',
            color: "#109618" // green
          }
        }
      };
      network = new vis.Network(container, data, options);
    }
  </script>
  
</head>

<body onload="draw()">
<div id="mynetwork"></div>

</body></html> 
EOL

scp $output_file deu-via-5-mng-2://starhome/igateprov/webapps/ROOT/$file