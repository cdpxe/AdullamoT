#!/bin/bash
# HP LaserJet Pro M148dw
PRINTER_IP="192.168.2.37"

source hp_shared.sh

while [ 1 ]; do
	RECV_MSG="$ACK_MESSAGE"
	#echo "Waiting for CS to set a message that is != "$ACK_MESSAGE" ..."
	while [ "$RECV_MSG" == "$ACK_MESSAGE" ]; do
		RECV_MSG=`curl --insecure 'https://'$PRINTER_IP'/hp/device/info_config_AirPrint.html?tab=Networking&amp;menu=AirPrintStatus' 2>&1 | grep DeviceLocation\" | sed 's/.*VALUE=\"//' | sed 's/\".*//g'`
		echo -n "#"
	done
	if [ "$RECV_MSG" == "EOF" ]; then
		echo "Recv'd EOF."
	fi
	#echo " received secret message. Setting printer location to "$ACK_MESSAGE" to indicate the successful transmission."
	echo " MSG=$RECV_MSG"
	
	# parameters: printer-ip  post_data_len  csrf  secret_msg
	post_message $PRINTER_IP "unused" "$ACK_MESSAGE"
done

