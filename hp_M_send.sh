#!/bin/bash
#HP LaserJet M15w
PRINTER_IP="192.168.178.137"

if [ "$1" != "" ]; then
	INPUT_SECRET_MSG=$1
else
	INPUT_SECRET_MSG="KATZE"
fi

source hp_M_shared.sh

# 1. transfer string into url format
#INPUT_SECRET_MSG=`urlencode $INPUT_SECRET_MSG` ##FIXME
#echo "INPUT_SECRET_MSG=$INPUT_SECRET_MSG"
#read go
# 2. split into chunks of the max. possible string length (64 characters)
echo "Sending chunks of the secret msg ..."
for SECRET_MSG in `echo $INPUT_SECRET_MSG | fold -w64`; do
	#echo "Next chunk='"$SECRET_MSG"'."
	RECV_MSG="notset"
	#echo "Waiting for CR's \"OK\" msg ..."
	COUNTER=0
	while [ ! "$RECV_MSG" == "OK" ]; do
		RECV_MSG=`curl --insecure 'https://'$PRINTER_IP'/hp/device/info_config_AirPrint.html?tab=Networking&amp;menu=AirPrintStatus' 2>&1 | grep DeviceLocation\" | sed 's/.*VALUE=\"//' | sed 's/\".*//g'`
		#echo "RECV_MSG=$RECV_MSG"
		echo -n "#"
		COUNTER=$((COUNTER+1))
		if [ "$COUNTER" = "10" ]; then
			# get out of a race condition, just post this thing again
			post_message $PRINTER_IP "unused" $SECRET_MSG
		fi
	done; echo -n "K" #echo " received 'OK'. Sending secret msg chunk."

	# parameters: printer-ip  csrf  secret_msg
	post_message $PRINTER_IP "unused" $SECRET_MSG
	echo -n "#"
done
#echo -n "sending EOF: "
#post_message $PRINTER_IP "unused" "EOF"
echo "done."

