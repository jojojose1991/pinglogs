#!/bin/bash

### Author: Jojo Jose
### Description: Run continuous ping against an IP and initate tracepath if 5 continuous ping fails

ip=$1
outfile=$2
counter=0

if [ -z "$outfile" ]
then
    echo "Usage: $0 <ip> <output_file>"
    exit 1
fi

echo "Press [CTRL+C] to stop.."

while true
do
	output=`ping -c 1 $ip -W 1 | grep "1 received"`

	if [ -z "$output" ]
	then
		echo "Ping missed at `date`" >> $outfile
		counter=$(($counter+1))
		if [ $counter -eq 5 ]
		then
			echo "5 continuous pings missed. Initating tracepath" >> $outfile
			tracepath $ip >> $outfile
			counter=0
		fi
	else
		# sleep 1 sec after successful ping
		sleep 1
		counter=0
	fi
done
