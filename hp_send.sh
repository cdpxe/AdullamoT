#!/bin/bash
#HP LaserJet Pro M148dw
PRINTER_IP="192.168.2.37"

if [ "$1" != "" ]; then
	INPUT_SECRET_MSG=$1
else
	INPUT_SECRET_MSG="KATZE"
fi

source hp_shared.sh

# 1. transfer string into url format
INPUT_SECRET_MSG=`urlencode $INPUT_SECRET_MSG`
#echo "INPUT_SECRET_MSG=$INPUT_SECRET_MSG"
#read go
# 2. split into chunks of the max. possible string length (255 characters)
echo "Sending chunks of the secret msg ..."
for SECRET_MSG in `echo $INPUT_SECRET_MSG | fold -w255`; do
	#echo "Next chunk='"$SECRET_MSG"'."
	RECV_MSG="notset"
	#echo "Waiting for CR's \"OK\" msg ..."
	while [ ! "$RECV_MSG" == "OK" ]; do
		RECV_MSG=`curl --insecure 'https://'$PRINTER_IP'/hp/device/info_config_AirPrint.html?tab=Networking&amp;menu=AirPrintStatus' 2>&1 | grep DeviceLocation\" | sed 's/.*VALUE=\"//' | sed 's/\".*//g'`
		#echo "RECV_MSG=$RECV_MSG"
		echo -n "#"
	done; echo -n "K" #echo " received 'OK'. Sending secret msg chunk."

	# parameters: printer-ip  csrf  secret_msg
	post_message $PRINTER_IP "unused" $SECRET_MSG
	echo -n "#"
done
echo -n "sending EOF: "
post_message $PRINTER_IP "unused" "EOF"
echo "done."

