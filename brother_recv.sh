#!/bin/bash
# Brother HL-L2375DW series
PRINTER_IP="192.168.2.103"

source brother_shared.sh

while [ 1 ]; do
	RECV_MSG="OK"
	#echo "Waiting for CS to set a message that is != \"OK\" ..."
	while [ "$RECV_MSG" == "OK" ]; do
		CSRF=$(get_csrf_token)
		RECV_MSG=`cat /tmp/tmp_$$ | tail -1 | sed 's/\"\ \/><\/dd><\/dl><\/div><di.*//' | sed 's/.*value=\"//g'`
		echo -n "#"
	done
	if [ "$RECV_MSG" == "EOF" ]; then
		echo "Recv'd EOF. Existing"
	fi
	#echo " received secret message. Setting printer location to 'OK' to indicate the successful transmission."
	echo " MSG=$RECV_MSG"
	
	# parameters: printer-ip  post_data_len  csrf  secret_msg
	post_message $PRINTER_IP $CSRF "OK"
done

