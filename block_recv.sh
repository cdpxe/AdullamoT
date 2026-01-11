#!/bin/bash
# BLOCK SB 100

PRINTER_IP="192.168.2.220"

nc $PRINTER_IP 514 2>/dev/null | grep "fsfsFlashFileHandleOpen: File" #| sed 's/.*flash:\/\///g' 

