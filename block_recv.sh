#!/bin/bash
#BLOCK SB 100
PRINTER_IP="192.168.2.220"
RECV_FILE=block.rcv

source block_shared.sh

if [ ! -e $RECV_FILE ]; then
	touch $RECV_FILE
fi

nc $PRINTER_IP 514 2>/dev/null | grep "fsfsFlashFileHandleOpen: File" | sed 's/.*flash:\/\///g' 

#	if [ "$RECV_MSG" == "EOF" ]; then
#		echo "Recv'd EOF. Existing"
#	fi
#	echo " MSG=$RECV_MSG"

