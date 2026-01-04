#!/bin/bash
#BLOCK SB 100
PRINTER_IP="192.168.2.220"

if [ "$1" != "" ]; then
	INPUT_SECRET_MSG=$1
else
	INPUT_SECRET_MSG="KATZE"
fi

source block_shared.sh

# 1. transfer string into url format
INPUT_SECRET_MSG=`urlencode $INPUT_SECRET_MSG`
#echo "INPUT_SECRET_MSG=$INPUT_SECRET_MSG"
#read go
# 2. split into chunks of the max. possible string length (59 characters)
echo "Sending chunks of the secret msg ..."
for SECRET_MSG in `echo $INPUT_SECRET_MSG | fold -w59`; do
	#echo "Next chunk='"$SECRET_MSG"'."
	RECV_MSG="notset"
	# parameters: printer-ip  csrf  secret_msg
	post_message $PRINTER_IP "unused" $SECRET_MSG
	echo -n "#"
done
echo "done."

