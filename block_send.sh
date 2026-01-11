#!/bin/bash
# BLOCK SB 100

PRINTER_IP="192.168.2.220"

if [ "$1" != "" ]; then
	INPUT_SECRET_MSG=$1
else
	INPUT_SECRET_MSG="KATZE"
fi

# 1. transfer string into url format
INPUT_SECRET_MSG=`urlencode $INPUT_SECRET_MSG`

# 2. split into chunks of the max. possible string length (59 characters)
echo "Sending chunks of the secret msg ..."
for SECRET_MSG in `echo $INPUT_SECRET_MSG | fold -w59`; do
	GET "http://"$PRINTER_IP"/"$SECRET_MSG >/dev/null
	echo -n "#"
done
echo "done."

