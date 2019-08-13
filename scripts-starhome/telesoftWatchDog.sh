#!/bin/bash

# set CCS env.
source /etc/profile
source ~/.bashrc

#---------------------------
# SVN version control
#--------------------------- 
svnDate="$Date: 2015-08-10 14:07:28 +0300 (Mon, 10 Aug 2015) $"
svnRevision="$Revision: 142998 $"
SvnAuthor="$Author: dcaspi $"

#---------------------------
# field definition
#--------------------------- 

# Search in files newer than x minutes. (that were modified in the last X minutes)
LastModifiyFiles=5

# SNMP Destination IP
snmpDestIP1="10.227.3.51"
snmpDestIP2="10.227.3.50"

#sbmaint File path
sbmaintPath=/home/ansty/run/sbmaint.ini

afLocationPath=/home/ansty/run/af_stats_*

# Failed channels text file
failedChannels=/home/ansty/run/.failedChannels.txt

# log file path 
logPath=/home/ansty/run/telesoftWatchDog.log

# Char that is being used as a comment (at the beginning of the line)
commentChar=#

declare -a channels;
declare -a raisedChannels;


############################################
#
#	Function: LOAD_CHANNELS_STATUS
#	
############################################
function LOAD_CHANNELS_STATUS {
touch -a $logPath
touch -a $failedChannels
isTrafficOk=false


#Check $logPath file size and backup if size > 10mb
sizeCount=`find $logPath -size +10M | wc -l`

if [ "$sizeCount" -gt "0" ]; then
{
        mv $logPath "$logPath_$(date +"%Y%m%d")"
}
fi

LOGGER "##### Start Telesoft watchdog script #####"

#add 1 minute to last modify files to make sure we don`t miss anything
((LastModifiyFiles+=1))

#clean watchdog temp files
echo /dev/null > watchDog.tmp
echo /dev/null > watchDog2.tmp

#Insert all channels (exclude commented ones) into array - channels
text="userid="
arr=`grep userid= $sbmaintPath | grep -v "$commentChar$text" | awk -F"=" '{print $2}'`
channels=($arr)

#insert all failed channels (from previous run) into array - raisedChannels
arrStatus=`cat $failedChannels | awk -F"|" '{print $2}' | awk -F"|" '{print $1}'`
raisedChannels=($arrStatus)

#Loop all failed channels to see if they still present in sbmaint and remove if not.
for (( i=0; i<${#raisedChannels[@]}; i++ ))
{
        if ! [[ " ${channels[@]} " =~ " ${raisedChannels[$i]} " ]]; then
        {
				#echo "Value is not present in SBMAINT - ${raisedChannels[$i]}"
				grep -v "|${raisedChannels[$i]}|" $failedChannels > .failedChannels.tmp; cat .failedChannels.tmp > $failedChannels
        }
        fi
}
}

############################################
#
#	Function: CHECK_CHANNELS
#	
############################################
function CHECK_CHANNELS {

d1=$(date --date="-$LastModifiyFiles min" +"%d/%m/%y %H:%M")
d2=$(date +"%d/%m/%y %H:%M")

#Get all af_log files that were modified in the last x ($LastModifiyFiles) minutes
files=( $(find $afLocationPath -mmin -$LastModifiyFiles -type f) )
if [ "${#files[@]}" -gt "0" ]; then
{	
		#loop on all files that were modified and marge them to one file (watchDog2)
        for i in ${files[@]};
                do
                        cat $i >> watchDog2.tmp
                done
		
		#Loop on all lines in watchDog2 file and take only the lines
		#That were modified in the last x minutes and add to watchDog.txt
        while IFS= read -r line2
        do
                line=${line2#"["}
                [[ $line > $d1 && $line < $d2 || $line =~ $d2 ]] && echo $line >> watchDog.tmp
        done < watchDog2.tmp

		#Loop on all sbmaint channels
        for (( i=0; i<${#channels[@]}; i++ ));
                do
						#Grep the channel[i] in watchdog.txt and get the count of lines
                        count=`grep "channel ${channels[$i]} =" watchDog.tmp | wc -l`
						
                        #Make sure there are 2 or more lines in watchDog.txt
						if [ "$count" -gt "1" ]; then 
                        {
								#Take the earliest line that was written in the x ($LastModifiyFiles) minutes 
                                old=`grep "channel ${channels[$i]} =" watchDog.tmp | head -1 | awk -F"= " '{print $2}'`
                                new=`grep "channel ${channels[$i]} =" watchDog.tmp | tail -1 | awk -F"= " '{print $2}'`
								
								#check that both new and old are not 0 or empty!
								if [ ! -z "$new" ] || [ ! -z "$old" ]; then
								{
									#Check if new is grater then old
									if [ "$new" -gt "$old" ]; then
									{
											#There was activity on channel - check if need to drop alarm
											SEND_DROP_ARLARM_IF ${channels[$i]}
											isTrafficOk=true
									}
									else
									{
											#There was no activity on channel - check if need to raise a new alarm
											SEND_RAISE_ARLARM_IF ${channels[$i]}
									}
									fi
								}
								else
								{
									#There was no activity on channel - check if need to raise a new alarm
									SEND_RAISE_ARLARM_IF ${channels[$i]}
								}
								fi
                        }
                        else
                        {									
                                #There is less then 2 rows for this channel - check if need to raise a new alarm
								SEND_RAISE_ARLARM_IF ${channels[$i]}
                        }
                        fi
                done
}
else
{
		#Non of the Af_log files were modified in the last X ($LastModifiyFiles) minutes, Telesoft probe is down!
		SEND_RAISE_ARLARM_IF "all"
}
fi

#There was traffic, check if we need to drop the alarm
if [ "$isTrafficOk" = true ] ; then
{
	SEND_DROP_ARLARM_IF "all"
}
fi

#delete temp files
rm watchDog.tmp
rm watchDog2.tmp
LOGGER "##### Finish Telesoft watchdog script #####"
}

############################################
#
#	Function: SEND_RAISE_ARLARM_IF
#       input: Channel ID
#	
############################################
function SEND_RAISE_ARLARM_IF {
#Check if channel is already known if not Send alarm
if [ "$1" == "all" ]; then
{
        count=`grep all $failedChannels | wc -l`
        if [ "$count" -eq "0" ]; then
        {
                echo "Sending "
                LOGGER "Raise Alarm: TDR is down or there are no af_stats log in the past $LastModifiyFiles minutes."
                SEND_SNMP_ALARM "TDR is down or there are no af_stats log in the past $LastModifiyFiles minutes." "up"
                echo "$(date +"%Y/%m/%d %H:%M:%S") - All channels are down." >> $failedChannels
        }
        fi
}
else 
{
        if ! [[ " ${raisedChannels[@]} " =~ " $1 " ]]; then
        {
                        echo "Sending SNMP alarm on channel: $1"
                        #Channel is not known, sending alarm and adding to failedChannels.
                        SEND_SNMP_ALARM "No traffic on channel $1 in the last $LastModifiyFiles minutes." "up"

                        #Add failed channel to failed channels file
                        echo "$(date +"%Y/%m/%d %H:%M:%S") - Failed channel |$1|" >> $failedChannels

                        #Check in sbmaint for card, Trunk and timeSlot base on the channel id (userid)
                        text="userid="
                        arr=`grep -A3 "$text$1" "$sbmaintPath"`
                        array=($arr)

                        LOGGER "STATUS=NOT OK Channel=$1 , Card=${array[1]} , Trunk=${array[2]} , TimeSlot=${array[3]}"
        }
        fi
}
fi
}

############################################
#
#	Function: SEND_DROP_ARLARM_IF
#       input: Channel ID
#	
############################################
function SEND_DROP_ARLARM_IF {
if [ "$1" == "all" ]; then
{

        count=`grep all $failedChannels | wc -l`
        if [ "$count" -ne "0" ]; then
        {
                echo "DROP ALARM: TDR is down or there are no af_stats log in the past $LastModifiyFiles minutes." 
                # Alarm is raised for this channel, drop it!
        	SEND_SNMP_ALARM "TDR is down or there are no af_stats log in the past $LastModifiyFiles minutes." "down"
        	LOGGER "DROP Alarm: TDR is down or there are no af_stats log in the past $LastModifiyFiles minutes."
        	grep -v "all" $failedChannels > .failedChannels.tmp; cat .failedChannels.tmp > $failedChannels
        }
        fi
}
else
{
        if [[ " ${raisedChannels[@]} " =~ " $1 " ]]; then
        {
                        echo "DROP ALARM: No traffic on channel $1 in the last $LastModifiyFiles minutes."
                        # Alarm is raised for this channel, drop it!
                        SEND_SNMP_ALARM "No traffic on channel $1 in the last $LastModifiyFiles minutes." "down"
                        LOGGER "DROP Alarm: No traffic on channel $1 in the last $LastModifiyFiles minutes."
                        grep -v "|$1|" $failedChannels > .failedChannels.tmp; cat .failedChannels.tmp > $failedChannels
        }
        fi
}
fi
}

############################################
#
#	Function: SEND_SNMP_ALARM
#       input: Alarm text, alarm status (up/down)
#	
############################################
function SEND_SNMP_ALARM {
	if [ ! -z "$snmpDestIP1" ]; then
	{
		send_snmp.sh Critical "$1" 987989 $2 $snmpDestIP1
	}
	fi
	
	if [ ! -z "$snmpDestIP2" ]; then
	{
		send_snmp.sh Critical "$1" 987989 $2 $snmpDestIP2
	}
	fi
}

############################################
#
#	Function: LOGGER
#       input: text to log
#	
############################################
function LOGGER {
        echo $(date +"%Y/%m/%d %H:%M:%S") - $1 >> $logPath
        echo $(date +"%Y/%m/%d %H:%M:%S") - $1
}


LOAD_CHANNELS_STATUS
CHECK_CHANNELS